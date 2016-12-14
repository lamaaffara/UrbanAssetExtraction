function Imap=spVisualize(I,S)

n=double(max(S(:))+1);
[h,w,d]=size(I);
Ir=reshape(I,[h*w d]);
Imap=zeros(size(I));
Imapr=reshape(Imap,[h*w d]);

for i=0:n
Imapr(S(:)==i,1)=round(mean(Ir(S(:)==i,1)));
Imapr(S(:)==i,2)=round(mean(Ir(S(:)==i,2)));
Imapr(S(:)==i,3)=round(mean(Ir(S(:)==i,3)));
end
Imapr(Imapr<=0)=1;Imapr(Imapr>=256)=255;
Imap=uint8(reshape(Imapr,[h w d]));
end