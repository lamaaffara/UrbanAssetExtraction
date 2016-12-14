imdir='E:\E\KAUST\GMSV\Urban_Image_Processing\LargeScaleWindowDetection\code\tools\ECP\';
imageNames=LoadFilenames(imdir,'.txt');
parfor it=1:length(imageNames)
bb=dlmread([imdir imageNames{it} '.txt']);
bb=wl2xy(bb);
fid(it)=fopen([imdir imageNames{it} '.txt'],'w');
fprintf(fid(it),'%d,%d,%d,%d\n',bb');
fclose(fid(it));
end