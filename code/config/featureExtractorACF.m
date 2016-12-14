classdef featureExtractorACF < featureExtractor
    
    properties
        shrink=4;
        addsymm=true;
    end
    
    methods
        function F = featureExtractorACF()
            F.name = 'ACF';
        end
        
        function setupFE(obj)
            setupFE@featureExtractor(obj);
            obj.shrink=4;
            obj.addsymm=true;
        end
        
        function H=extractFeatures(obj,I,boxes)
            l=(obj.modelsize(1)/obj.shrink);
            w=(obj.modelsize(2)/obj.shrink);
            
            if obj.addsymm
                ftlength=(l*w*10)*2;
            else
                ftlength=(l*w*10);
            end
            H=zeros(ftlength,size(boxes,1));
            if ~obj.isExact
                pChns.shrink=2;pChns.pColor.colorSpace='hsv';
                ACF_struct=chnsCompute(I,pChns);
                ACF_luv=ACF_struct.data{1};
                ACF_mag=ACF_struct.data{2};
                ACF_hog=ACF_struct.data{3};
                ACF=cat(3,ACF_luv,ACF_mag,ACF_hog);
            end
            for i=1:size(boxes,1)
                x1=boxes(i,1);x2=boxes(i,3);y1=boxes(i,2);y2=boxes(i,4);
                cr_w=x2-x1;cr_l=y2-y1;pad=round(round([cr_l*obj.pad cr_w*obj.pad])/pChns.shrink);
                x1_=max(1,x1-round(cr_w*obj.pad));
                y1_=max(1,y1-round(cr_l*obj.pad));
                x2_=min(size(I,2),x2+round(cr_w*obj.pad));
                y2_=min(size(I,1),y2+round(cr_l*obj.pad));
                
                if obj.isExact
                    P = I(y1_:y2_,x1_:x2_,:);
                    Ps=imResampleMex(P,obj.modelsize(2),obj.modelsize(1),1);
                    acf_features_struct = chnsCompute(Ps);
                    acf_features_luv=acf_features_struct.data{1};
                    acf_features_mag=acf_features_struct.data{2};
                    acf_features_hog=acf_features_struct.data{3};
                    acf_features=cat(3,acf_features_luv,acf_features_mag,acf_features_hog);
                else
                    yt=max(1,round(y1_/pChns.shrink));yb=min(size(ACF,1),round(y2_/pChns.shrink));
                    xl=max(1,round(x1_/pChns.shrink));xr=min(size(ACF,2),round(x2_/pChns.shrink));
 
                    p_h=ACF(yt:yb,xl:xr,:);
                    acf_features=imResampleMex(p_h,w,l,1);
                end
                if obj.addsymm
                    yt0=max(1,round(y1/pChns.shrink));yb0=min(size(ACF,1),round(y2/pChns.shrink));
                    xl0=max(1,round(x1/pChns.shrink));xr0=min(size(ACF,2),round(x2/pChns.shrink));
                    
                    p_h0=ACF(yt0:yb0,xl0:xr0,:);
                    
                    J=imPad(p_h0,pad,'symmetric');
                    l2=size(p_h0,1);w2=size(p_h0,2);
                    
                    p_h2=imResampleMex(p_h,size(J,1),size(J,2),1);
                    D=sqrt((J-p_h2).^2);
                    
                    jitterfeatures=imResampleMex(D,w,l,1);                    
                else
                    jitterfeatures=[];
                end
                H(:,i)=[jitterfeatures(:);acf_features(:)];
            end
            H=H';
        end
    end
end
