dirloc='\\gmsv-strgcon-01\Lama\LargeScaleWindowDetection\evalutaion\';

datasets={
    'Graz',  50  ;
    'ECP', 104   ;
    'cmp',   378   ;
    'eTrims',   60    ;
    'london',   400   ;
    'strasburg',      400};


foldernames=dir(dirloc);

check=[];count=1;
for i=3:length(foldernames)
    fname=foldernames(i).name;
    delimiter=strfind(fname,'_');
    datasetname=fname(delimiter(1)+1:delimiter(2)-1);
    ind=find(ismember(datasets(:,1),datasetname));
    filenames=dir([dirloc fname '\results\bboxes\*.txt']);
    if length(filenames)< datasets{ind,2}
        fprintf([fname '\n']);
        check{count}=[dirloc fname '\results\bboxes\*.txt'];
        coount=count+1;
    end
end