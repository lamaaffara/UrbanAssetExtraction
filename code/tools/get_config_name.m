function [config_data,config_output] = get_config_name

cf = DatasetConfig.getInstance();

try bbcount=cf.configuration.objectProp.maxBoxes; catch, bbcount='NA'; end
try dd=cf.adaptive; catch, dd='NA'; end

config_=[cf.name '_'...
    cf.configuration.name '_'...
    num2str(bbcount) '_'...
    num2str(cf.kFold) '_'...
    num2str(dd)];

config_data=[cf.evaluationLocation 'data_' config_ '/'];

config_output=[cf.evaluationLocation 'output_' config_ '/'];

end