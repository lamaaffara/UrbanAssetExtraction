classdef featureExtractorHOG < featureExtractor

    properties
        binsize
        nOrients
    end
    
    methods
        function F = featureExtractorHOG()
            F.name = 'HOG';
        end
        
        function setupFE(obj)
            setupFE@featureExtractor(obj); 
            obj.binsize=4;
            obj.nOrients=9;
        end   
            
        function H=extractFeatures(obj,I,boxes) 
            l=(obj.modelsize(1)/obj.binsize);
            w=(obj.modelsize(2)/obj.binsize);
            
            H=zeros((l*w*obj.nOrients*4)+1,size(boxes,1));
            
            if ~obj.isExact
                binsize_0=2;
                Hog=hog(I,2,obj.nOrients);
            end
            for i=1:size(boxes,1)
                x1=boxes(i,1);x2=boxes(i,3);y1=boxes(i,2);y2=boxes(i,4);
                cr_w=x2-x1;cr_l=y2-y1;
                x1_=round(max(1,x1-cr_w*obj.pad));
                y1_=round(max(1,y1-cr_l*obj.pad));
                x2_=round(min(size(I,2),x2+cr_w*obj.pad));
                y2_=round(min(size(I,1),y2+cr_l*obj.pad)); 
           
                if obj.isExact
                    P = I(y1_:y2_,x1_:x2_,:); 
                    Ps=imResampleMex(P,obj.modelsize(2),obj.modelsize(1),1);
                    hog_features = hog(Ps,obj.binsize,obj.nOrients); 
                else
                    p_h=Hog(round(y1_/binsize_0):round(y2_/binsize_0),round(x1_/binsize_0):round(x2_/binsize_0),:);
                    hog_features=imResampleMex(p_h,w,l,1);
                end
                H(:,i)=[hog_features(:);cr_l/cr_w];
            end
            H=H';
        end        
    end
end
