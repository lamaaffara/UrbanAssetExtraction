I1=rgb2gray(I);

H=(sum(U,1));V=(sum(U,2));

[subs_h,~] = nonMaxSupr(H,2);
[subs_v,~] = nonMaxSupr(V',2);


c=[1;sort(subs_h(:,2));size(I,2)];
r=[1;sort(subs_v(:,2));size(I,1)];
k=1;
S2=zeros(size(I1));
for i=2:length(r)
    for j=2:length(c)
        S2(r(i-1):r(i)-1,c(j-1):c(j)-1)=k;
        k=k+1;
    end
end
        