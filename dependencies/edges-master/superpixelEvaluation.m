function sc=superpixelEvaluation(map,S,th)

% gtdir='E:\E\KAUST\GMSV\Datasets\Urban\strasburg\groundtruth\map\';
% map=(imread([gtdir imname(1:end-4) '.png']));
n=double(max(S(:))+1);

%window pixels -ve and background +ve
binmap=rgb2gray(map)==76;
negposmap=ones(size(S));
negposmap(binmap)=-1;

%count negative and positive superpixels
W=(negposmap.*double(S));
b=histc(W(:),-n:n);
cp=b(n+2:end);
cn=b(n:-1:1);

%superpixels straddling the window boundary 
ind1=cn./cp>th & cp>0;
ind2=cn./cp>0 & cn./cp<=th;

%ratio of straddling superpixels to all window pixels
sc=(sum(cp(ind1))+sum(cn(ind2)))/sum(binmap(:)==1)*100;

% W2=W;
% spid=1:n;
% 
% for i=1:n
%    if ~ind2(i)
%        W2(W==-spid(i))=0;
%    end
%    if ~ind1(i)
%        W2(W==spid(i))=0;
%    end
% end
% W2(W2<0)=-1;W2(W2>0)=1;
% figure;imagesc(W2);

end
