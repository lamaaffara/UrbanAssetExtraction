function copyimages(datasetdir,location,ext)

cf = DatasetConfig.getInstance();

imageFilenames=dir([datasetdir '\*' ext]);

tic;
parfor i=1:length(imageFilenames)
    copyfile([datasetdir '\' imageFilenames(i).name], [location imageFilenames(i).name]);
end
%fprintf('Copied %d images in %.2f seconds.\n',length(imageFilenames),toc);