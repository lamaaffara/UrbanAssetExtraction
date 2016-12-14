function [c,r]=fixIndices(subs_h,subs_v,w,h)
c=[1;sort(subs_h);w];
r=[1;sort(subs_v);h];

cdif=Inf;rdif=Inf;
while cdif>0 || rdif>0
    dif=c-[0;c(1:length(c)-1)];
    c([2;dif(2:end)]<=1)=[];
    dif=c-[0;c(1:length(c)-1)];
    cdif=sum(dif(2:end)<=0);
    dif=r-[0;r(1:length(r)-1)];
    r([2;dif(2:end)]<=1)=[];
    dif=r-[0;r(1:length(r)-1)];
    rdif=sum(dif(2:end)<=1);
    if c(1)>2
        c=[1;c];
    else
        c(1)=1;
    end
    if r(1)>2
        r=[1;r];
    else
        r(1)=1;
    end
    
    if c(end)<w-2
        c=[c;w];
    else
        c(end)=w;
    end
    if r(end)<h-2
        r=[r;h];
    else
        r(end)=h;
    end
end
end