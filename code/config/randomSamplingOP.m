classdef randomSamplingOP < exhaustiveSearchOP
    %%
    properties

    end
    %%
    methods
        %%
        function obj = randomSamplingOP()
            obj.name = 'randomSamplingOP';
        end
        %%
        function setModel(obj,model)
            obj.modeltype=model;
        end
        
        function setupOP(obj,~,~)
            setupOP@exhaustiveSearchOP(obj);
        end
        %%
        function randomboxes=runOP(obj,I,~)
            boxes=runOP@exhaustiveSearchOP(obj,I);
            
            K=size(boxes,1);
            
            r = randsample(K,min(obj.maxBoxes,K));
            
            randomboxes=boxes(r,:);
        end
    end
end