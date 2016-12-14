classdef configuration < handle
    %C2D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        name = '';
        featureExtractor={};
        classifier = {};
        objectProp = {};
        priors = {};
               
        resizedImagesSize = 640*480;
        minRegionArea = 150;    %segmentation  
    end
    
    methods (Access = public)
         function SetName(obj, name)
           obj.name = name; 
         end
         
         function SetFeatureExtractor(obj, featureExtractor)
           obj.featureExtractor = featureExtractor;
         end
        
         function SetClassifier(obj, classifier)
           obj.classifier = classifier; 
         end
        
         function SetOP(obj, objectprop)
           obj.objectProp = objectprop;
         end
         
         function SetPriors(obj, priors)
            obj.priors=priors;
         end
    end
    
end

