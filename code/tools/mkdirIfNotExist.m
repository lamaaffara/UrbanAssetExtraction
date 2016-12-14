function dirName=mkdirIfNotExist(dirName)
    if ~exist(dirName,'dir')
        mkdir(dirName);
    end
end