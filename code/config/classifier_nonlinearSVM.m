classdef classifier_nonlinearSVM < classifier
    %classifier_nonlinearSVM libSVM classification
    %   Detailed explanation goes here
    
    properties
        log2c = -1;
        log2g = -3;
        type = 2;   % 0: linear SVM, 2: Gaussian kernel
    end
    
    methods
        function obj = classifier_nonlinearSVM()
            obj.name = 'nonlinSVM';
        end
        
        function Train(obj,y,x)
            n=length(y);
            trainExamples = min(obj.maxTrainExamples,n);
            obj.model = svmtrain(y(1:trainExamples),x(1:trainExamples,1:end));
        end
        
        
        function [yPred,accuracy, yProb] = Evaluate(obj,y,x)
             n=length(y);
             testExamples =  min(obj.maxTestExamples,n);
             [yPred, accuracy, yProb] = svmpredict(y(1:testExamples), x(1:testExamples,:), obj.model);
             
        end
        
    end
    
end

