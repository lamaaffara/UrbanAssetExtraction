function Rectify()

cf = DatasetConfig.getInstance();

% Create rectification folder
workFolder = get_adr('rectified');
mkdirIfNotExist(workFolder);

%% Get the list of all images
imageNames=LoadFilenames(get_adr('images'),'jpg');


%% Rectify images
tic;
parfor i=1:length(imageNames)
    imname=[get_adr('images') imageNames{i} '.jpg'];
    I=imread(imname);
    [L,W,~]=size(I);
    %s_=round(sqrt(prod([640 480])/prod([L W]))*100)/100;
    if (L*W)>640*480
        I=imresize(I,sqrt((640*480)/(L*W)));
    end
    imwrite(I,imname);
    [Irect,H{i}]=rectifyim(I);
    imwrite(Irect,[workFolder imageNames{i} '.jpg']);
end
fprintf('Rectified %d images in %.2f seconds.\n',length(imageNames),toc);

end