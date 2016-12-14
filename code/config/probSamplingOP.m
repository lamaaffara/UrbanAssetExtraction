classdef probSamplingOP < exhaustiveSearchOP
    %%
    properties
        dd;
    end
    %%
    methods
        %%
        function obj = probSamplingOP()
            obj.name = 'probSamplingOP';
        end
        %%
        function setModel(obj,model)
            obj.modeltype=model;
        end
        
        function setupOP(obj,dd,~)
            setupOP@exhaustiveSearchOP(obj);            
            obj.dd=dd;
        end
        %%
        function randomboxes=runOP(obj,I,pr)
            boxes=runOP@exhaustiveSearchOP(obj,I);
            [L,W,~]=size(I);
            randomboxes=pickOP(obj,boxes,pr,L,W);
        end
        
         %obj=op;boxes=bb_ex;
        function [randomboxes,ind]=pickOP(obj,boxes,pr,L,W)
            if ~obj.dd       
                K=obj.maxBoxes;
            else
                K=obj.maxBoxes/20;
            end
            p_x_combined=pr.combinedPrior.p_x;
            p_y_combined=pr.combinedPrior.p_y;
            p_ar_combined=pr.combinedPrior.p_ar;
            p_s_combined=pr.combinedPrior.p_s;
            
            x_=round((boxes(:,1)/W*1001));
            p_xx=[x_';p_x_combined(x_)*1e5];
            
            y_=round((boxes(:,2)/L*1001));
            p_yy=[y_';p_y_combined(y_)*1e5];
            
            s_=round(((boxes(:,4)-boxes(:,2))/L*1001));
            p_ss=[s_';p_s_combined(s_)*1e5];
            
            ar_=round((((boxes(:,3)-boxes(:,1))./(boxes(:,4)-boxes(:,2)))*100));
            p_arr=[ar_';p_ar_combined(ar_)*1e5];
            
            w=p_xx(2,:).*p_yy(2,:).*p_arr(2,:).*p_ss(2,:);w(w<0)=0;
            
            [seq,ind] = datasample(boxes,min(min(K,size(boxes,1)),sum(w>0)),'Weights',w,'replace',false);
            
            randomboxes=seq;
        end
    end
end