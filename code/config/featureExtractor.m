classdef featureExtractor < handle

    properties
        name
        pad
        modelsize
        isExact
    end
    
    
    methods
        function setupFE(obj)
            obj.pad=0.5;
            obj.modelsize=[40 40];
            obj.isExact=0;
        end
    end
    
%     methods (Abstract)
%         
%         extractFeatures(obj,I,boxes);
%         %extractSlidingWindowFeatures(obj,I);
%         
%     end
end
