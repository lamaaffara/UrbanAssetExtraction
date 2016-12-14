objdir='C:\Users\affarala\Downloads\gop_matlab\gop_matlab\matlab\objects\';
objectnames=dir([objdir '*.jpg']);

load model_svm;model_hog=model_svm;
H=[];

parfor i=1:length(objectnames)
    P=imread([objdir objectnames(i).name]);
    Pr=imresize(P,[128 128]);
    Ps=im2single(Pr);

    hog = vl_hog(Ps, 8) ;
    
H=[H;[reshape(hog,[1 256*31]) size(P,1)/size(P,2)]];

end

[tl,acc,prob]=predict(ones(size(H,1),1),sparse(double(H)),model_hog);

parfor i=1:length(objectnames)
    if prob(i)<1
        delete([objdir objectnames(i).name]);
    else
        movefile([objdir objectnames(i).name],[objdir num2str(round(prob(i)*100)) '_' objectnames(i).name]);
    end
end