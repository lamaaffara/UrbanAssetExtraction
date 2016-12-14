function [pr,databoxes]=imageUpdate(imageNames,pr,ft,cl,op,I_all,X_all,X2_all,kdtree_all,kdtree2_all,first,last)

for it=first:last
    I=I_all{it}; [L,W,~]=size(I);
    strictth=0;th=0;stop=0;
    X=X_all{it};
    X2=X2_all{it};
    kdtree=kdtree_all{it};
    kdtree2=kdtree2_all{it};
    
    
    imageboxes=cell(20,1);
    proposals=cell(20,1);
    detected=cell(20,1);
    bbimage=cell(20,1);
    
    
    for dd=1:20;
        bbi=[];Hp=[];Hn=[];bb=[];count=0;
        while isempty(bbi)
            count=count+1;
            [bb,ind]=op.pickOP(X,X2,kdtree,kdtree2,pr,L,W);
            bb=bb(:,1:4);
%             bb_ex(ind,:)=[];
            
            H=ft.extractFeatures(I,bb);
            
            H_=double((H));
            
            [~,~,prob] = cl.EvaluateOnline(ones(size(H_,1),1),(H_));
            
            %             [boxes_nms,ind]=nms([double(bb) prob],0);
            boxes_nms=[double(bb) prob];
            
            % get features of positive and negative detections to update SVM model
%             indp=boxes_nms(:,5)>strictth;
%             indn=boxes_nms(:,5)<-strictth;
%             Hp=[Hp;H_(indp,:)];
%             Hn=[Hn;H_(indn,:)];
            
            indb=boxes_nms(:,5)>th;
            boxes_nms=boxes_nms(indb,:);
            
            bbi=xy2wl(boxes_nms(boxes_nms(:,5)>strictth,:));
            if count>20
                strictth=strictth-0.5;
                th=th-0.5;
            end
            if dd~=1
                break;
            end
            
        end
        bbimage{dd,1}=bbi;
        detected{dd,1}=boxes_nms;
        proposals{dd,1}=bb;
        
        if ~isempty(bbi)
            imageboxes{dd,1}=[bbi(:,1)/W bbi(:,2)/L bbi(:,3)/W bbi(:,4)/L bbi(:,3)./bbi(:,4) bbi(:,5)];
        end
        
        if ~isempty(cell2mat(imageboxes))
            pr.TrainImage(imageboxes);
        end
        %===========================================================================================
                figure(1);clf;pr.Plot
                drawnow;
                %
                figure(2);clf;
                im(I);hold on;
                %                                     bbApply('draw',xy2wl(bb));
                bbApply('draw',xy2wl(nms(wl2xy(cell2mat(bbimage)),0)),'red');
        
                f=normalized(pr.combinedPrior.p_x)*L/2;
                x=linspace(1,W,length(f));
                plot(x,f,'linewidth',2);
                f2=normalized(pr.combinedPrior.p_y)*W/2;
                y=linspace(1,L,length(f2));
                plot(f2,y,'r','linewidth',2);
        
                %
                drawnow;
                input('');
        %===========================================================================================
        
        
        %% update prior
        pr.Update;
        if stop
            break;
        end
        
        %                 fcount=fcount+1;
    end
    
    bbd=cell2mat(bbimage);
    databoxes{it,1}=[bbd(:,1)/W bbd(:,2)/L bbd(:,3)/W bbd(:,4)/L bbd(:,3)./bbd(:,4) bbd(:,5)];
    
    
    dlmwrite([get_adr('results_bboxes') imageNames{it} '.txt'],nms(cell2mat(detected),0));
    dlmwrite([get_adr('results_proposals') imageNames{it} '.txt'],cell2mat(proposals));
    
    
end

end