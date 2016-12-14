classdef classifier_linearSVM < classifier
    
    properties
        y;
        x;
        yonline;
        xonline;
    end
    
    methods
        function obj = classifier_linearSVM()
            obj.name = 'linSVM';
        end
        
        function Train(obj,y,x)
            n=length(y);
            trainExamples = min(obj.maxTrainExamples,n);
            
            if isempty(obj.c)
                options='-C -s 2';
                c = train(y(1:trainExamples), sparse(x(1:trainExamples,:)) ,options);
                options=['-s 2 -c' c(1) ''];
            else
                options=['-s 2 -c ' num2str(obj.c) ''];
            end
            obj.model = train(y(1:trainExamples), sparse(x(1:trainExamples,:)),options); 
            obj.y=y(1:trainExamples);
            obj.x=x(1:trainExamples,:);
        end
        
        
        function [yPred,accuracy,yProb] = Evaluate(obj,y,x)
             n=length(y);
             testExamples =  min(obj.maxTestExamples,n);
             [yPred, accuracy, yProb] = predict(y(1:testExamples), sparse(x(1:testExamples,:)), obj.model,'-q');
        end
        
        function [yPred,accuracy,yProb] = EvaluateOnline(obj,y,x)
             n=length(y);
             testExamples =  min(obj.maxTestExamples,n);
             [yPred, accuracy, yProb] = predict(y(1:testExamples), sparse(x(1:testExamples,:)), obj.onlinemodel,'-q');
        end
        
        function Update(obj,y,x,wmodel)
            
            options='-s 2';
            
            y0=obj.y;
            x0=obj.x;
            n0=length(y0);
            n=length(obj.yonline);
            
            r = randsample(1:n0,n0-n);
           
            obj.yonline=[obj.yonline;y];
            obj.xonline=[obj.xonline;x];
            
            obj.onlinemodel = train([y0(r,:);obj.yonline], sparse([x0(r,:);obj.xonline]),options);           
            
        end
        
    end
    
end

