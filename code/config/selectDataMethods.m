function [datasets,dt,opType,ftType,clType,rectMethod]=selectDataMethods(dt,op,ft,cl,rect)

narg=nargin;

datasets={
    %1
    'Graz',              '..\Dataset_final\graz50\rectified',       '..\Dataset_final\graz50\groundtruth\map2';
    %2
    'ECP_windows',       '..\Dataset_final\ECP\rectified',          '..\Dataset_final\ECP\groundtruth\map2';
    %3
    'cmp_windows',       '..\Dataset_final\CMP\windows\rectified',  '..\Dataset_final\CMP\windows\groundtruth\map2';
    %4
    'eTrims',            '..\Dataset_final\eTrims\rectified',       '..\Dataset_final\eTrims\groundtruth\map2';
    %5
    'london',            '..\Dataset_final\london\rectified',       '..\Dataset_final\london\groundtruth\map';
    %6
    'strasburg',         '..\Dataset_final\strasburg\rectified',    '..\Dataset_final\strasburg\groundtruth\map';
    %7
    'test',               '..\data\images','..\data\groundtruth'
};

%               1                   2               3               4               5                                                     
objectprop={'geodesicBasicOP','edgeBoxesOP','randomSamplingOP','probSamplingOP','exhaustiveSearchOP'};

features={'HOG','ACF'};

classifier={'linearSVM','nonlinearSVM','randomForest'};

rectification={'None','Ours','VP','VP-refined'};

if narg <= 0 || isempty(dt)
    dt = listdlg('PromptString','Select Dataset:',...
        'SelectionMode','single',...
        'InitialValue',7,...
        'ListString',datasets(:,1));
end

if narg <= 1 || isempty(op)
    op = listdlg('PromptString','Select Search Strategy:',...
        'SelectionMode','single',...
        'InitialValue',6,...
        'ListString',objectprop);
end

if narg <= 2 || isempty(ft)   
    ft = listdlg('PromptString','Select Feature Type:',...
        'SelectionMode','single',...
        'InitialValue',2,...
        'ListString',features);
end

if narg <= 3 || isempty(cl)
    cl = listdlg('PromptString','Select Classifier:',...
        'SelectionMode','single',...
        'InitialValue',1,...
        'ListString',classifier);    
end

if narg <= 4 || isempty(rect)
    rect = listdlg('PromptString','Select Rectification Method:',...
        'SelectionMode','single',...
        'InitialValue',1,...
        'ListString',rectification);    
end

opType=objectprop{op};
ftType=features{ft};
clType=classifier{cl};
rectMethod=rectification{rect};
end
