classdef classifier < handle
    
    properties (SetAccess = protected)
        model
        onlinemodel
        name 
        c=0.5;
        
        maxTrainExamples = 1e7;
        maxTestExamples = 1e7;
    end
    
    methods
        function setModel(obj,m)
            obj.model=m;
        end
        
        function initializeOnline(obj)
            obj.onlinemodel=obj.model;
        end
    end
        
    
    methods (Abstract)
        
        Train(obj,t,x);
        [yPred,acc,yProb] = Evaluate(obj,t,x);
        [yPred,acc,yProb] = EvaluateOnline(obj,t,x);
        Update(obj,t,x,model);
        
    end
    
end

