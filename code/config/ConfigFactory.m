classdef ConfigFactory < handle
    
    properties
        
    end
    %%
    methods (Static)
        function c = MakeConfig(classifier,objectprop,features,numProp)
            c = configuration();
            
            %% Setup classifier
            if strcmp(classifier,'linearSVM')
                c.SetClassifier( classifier_linearSVM() );
                name = 'linearSVM';
                
            elseif strcmp(classifier,'nonlinearSVM')
                c.SetClassifier( classifier_nonlinearSVM() );
                name = 'nonlinearSVM';
            elseif strcmp(classifier,'randomForest')
                c.SetClassifier( classifier_rf() );
                name = 'rf';
                
            elseif strcmp(classifier,'none')
                %Do nothing
            else
                error('Unsupported classifier!');
            end
            
            %% Setup object proposals
            if strcmp(objectprop,'bingTrainedOP')
                name = [name '_bingTrainedOP'];
                c.SetOP(bingTrainedOP());
                
            elseif strcmp(objectprop,'geodesicBasicOP')
                name = [name '_geodesicBasicOP'];
                c.SetOP(geodesicBasicOP());
                
            elseif strcmp(objectprop,'edgeBoxesOP')
                name = [name '_edgeBoxesOP'];
                c.SetOP(edgeBoxesOP());
                
            elseif strcmp(objectprop,'slidingWindowOP')
                name = [name '_slidingWindowOP'];
                c.SetOP(slidingWindowOP());
                
            elseif strcmp(objectprop,'exhaustiveSearchOP')
                name = [name '_exhaustiveSearchOP'];
                c.SetOP(exhaustiveSearchOP());
                
            elseif strcmp(objectprop,'randomSamplingOP')
                name = [name '_randomSamplingOP'];
                c.SetOP(randomSamplingOP());
                
            elseif strcmp(objectprop,'randomSamplingOP2')
                name = [name '_randomSamplingOP2'];
                c.SetOP(randomSamplingOP2());
                
            elseif strcmp(objectprop,'probSamplingOP')
                name = [name '_probSamplingOP'];
                c.SetOP(probSamplingOP());
                
            elseif strcmp(objectprop,'probSamplingOP3')
                name = [name '_probSamplingOP3'];
                c.SetOP(probSamplingOP3());
                
            elseif strcmp(objectprop,'exhaustiveSearchOP3')
                name = [name 'exhaustiveSearchOP3'];
                c.SetOP(exhaustiveSearchOP3());
                
            elseif strcmp(objectprop,'new')
                name = [name '_newOP'];
                c.SetOP(newOP());
                
            elseif strcmp(objectprop,'none')
                %Do nothing
            else
                error('Unsupported object proposal technique!');
            end
            
            %% Setup feature Extractors
            if strcmp(features,'HOG')
                name = [name '_HOG'];
                c.SetFeatureExtractor(featureExtractorHOG());
            elseif strcmp(features,'ACF')
                name = [name '_ACF'];
                c.SetFeatureExtractor(featureExtractorACF());
            else
                error('Unsupported feature extraction technique!');
            end
            
            %% setup Prior
            c.SetPriors(priors());
            c.objectProp.setMaxBoxes(numProp);
            
            %%
            c.SetName(name);
        end
    end
end


