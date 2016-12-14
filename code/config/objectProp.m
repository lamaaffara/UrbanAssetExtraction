classdef objectProp < handle
    
    properties (SetAccess = protected)
        name
        maxBoxes
    end  
    
    methods
         function setMaxBoxes(obj,numProp)
             obj.maxBoxes=numProp;
         end
    end
    
    methods (Abstract)
        
        setupOP(obj,round_);
    end
    
    
    
end