classdef exhaustiveSearchOP < objectProp
    %%
    properties
        modeltype;
        model;
        opts;
    end
    %%
    methods
        %%
        function obj = exhaustiveSearchOP()
            obj.name = 'exhaustiveSearchOP';
        end
        %%
        function setModel(obj,model)
            obj.modeltype=model;
        end
        
        function setupOP(obj,~,~)
            %% load pre-trained edge detection model and set opts (see edgesDemo.m)
            model_=load([get_adr(obj.modeltype) 'modelBsds']); model_=model_.model;
            model_.opts.multiscale=0; model_.opts.sharpen=2; model_.opts.nThreads=4;
            obj.model=model_;
            
            %% set up opts for Exhaustive Search
            opts_.gradientMapType='sf'; % sf for priotr_Dollar edge map, basic uses gradient
            opts_.nmsThr=2;
            opts_.merge=2e-3;
            opts_.maxsizeThr=0.2;
            opts_.minsizeThr=0.025;
            opts_.minarThr=0.25;
            opts_.maxarThr=4;
            obj.opts=opts_;
        end
        %%
        function bbs=runOP(obj,I,~)
            nmsThr=obj.opts.nmsThr;
            
            [h,w,~]=size(I);
            
            if strcmp(obj.opts.gradientMapType,'sf')
                M=edgesDetect(I,obj.model);
            elseif strcmp(obj.opts.gradientMapType,'basic')
                M=gradientMag(convTri(single(I),nmsThr)); M=M/max(M(:));
            else
                error('Check ExhaustiveSearchOP gradientMapType parameter')
            end
            
            H=double(sum(M,1));V=double(sum(M,2));
            
            if nmsThr>0
                [subs_h,~] = nonMaxSupr(H,nmsThr);
                subs_h=subs_h(:,2);
                [subs_v,~] = nonMaxSupr(V',nmsThr);
                subs_v=subs_v(:,2);
            else
                [~,subs_h]=findpeaks(H');
                [~,subs_v]=findpeaks(V);
            end
            [c,r]=fixIndices(subs_h,subs_v,w,h);
            
            S=convertToSuperpixels(c,r,h,w);
            
            S_ = spDetectMex('merge',uint32(S),M,obj.opts.merge);
            
            
            
            locs_c=zeros(h,w);locs_c(:,c)=1;
            locs_r=zeros(h,w);locs_r(r,:)=1;
            locs_sp=zeros(h,w);locs_sp(S_==0)=1;
            
            locs=(locs_c & locs_r & locs_sp);
            [y,x]=find(locs);
            
            a=imfilter(locs_sp,[0 0 0;0 1 1;0 1 0],'same');
            locs_sp_c=(a==3);
            
            locs_tl=(locs_c & locs_r & locs_sp_c);
            [y_tl,x_tl]=find(locs_tl);
            
            n=length(x_tl);
            bb=cell(n,1);
            for i=1:n
                p=[x_tl(i) y_tl(i)];
                [x2,y2]=meshgrid(x(y==p(2)),y(x==p(1)));
                w=x2(:)-p(1);l=y2(:)-p(2);
                w2=w(w>0 & l>0);l2=l(w>0 & l>0);
                bb{i}=[repmat(p,[length(w2) 1]) w2 l2];
            end
            
            bball=cell2mat(bb);
            
            maxsizeind=bball(:,3)<obj.opts.maxsizeThr*size(I,2) & bball(:,4)<obj.opts.maxsizeThr*size(I,1);
            minsizeind=bball(:,3)>obj.opts.minsizeThr*size(I,2) & bball(:,4)>obj.opts.minsizeThr*size(I,1);
            arind=(bball(:,3)./bball(:,4))>obj.opts.minarThr & (bball(:,3)./bball(:,4))<obj.opts.maxarThr;
            
            bb2=bball( maxsizeind & minsizeind & arind,:);
            boxes=bb2;
            
            bbs=boxes;
            bbs(:,3)=bbs(:,1)+bbs(:,3);
            bbs(:,4)=bbs(:,2)+bbs(:,4);
        end
    end
end