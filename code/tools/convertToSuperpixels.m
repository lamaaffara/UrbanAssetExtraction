function S=convertToSuperpixels(c,r,h,w)
k=1;
S=zeros(h,w);
for i=2:length(r)
    for j=2:length(c)
        S(r(i-1):r(i)-1,c(j-1):c(j)-1)=k;
        k=k+1;
    end
end
S(:,c)=0;
S(r,:)=0;
S = uint32(S);
end