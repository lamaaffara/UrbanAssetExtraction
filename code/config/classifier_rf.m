classdef classifier_rf < classifier
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nTrees = 100;
        useParallel = 'always';
        minLeaf = 30;
    end
    
    methods
     
        function obj = classifier_rf()
            obj.name = 'RF';
        end
        
        function Train(obj,y,x)
            n=length(y);
            trainExamples = min(obj.maxTrainExamples,n);
            
            obj.model = TreeBagger(obj.nTrees,x(1:trainExamples,1:end),y(1:trainExamples),...
            'Method','classification',...
            'MinLeaf',obj.minLeaf,...
            'Options',statset('UseParallel',obj.useParallel));
        end
        
        
        function [yPredict,accuracy,scores] = Evaluate(obj,y,x)
             n=length(y);
             testExamples =  min(obj.maxTestExamples,n);
             
             [~,scores] = predict(obj.model,x(1:testExamples,1:end));
             
             [maxval,yPredict] = max(scores,[],2);
             
             yPredict=-1*(yPredict==1)+1*(yPredict==2);
             scores=maxval.*yPredict;
             
             accuracy = 0;%100*sum(cprb'==y(1:testExamples))/testExamples;
        end
    end
    
end

