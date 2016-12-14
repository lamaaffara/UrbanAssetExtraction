function plotrectangles(R,cmap,winflag,lw)

if isempty(R)
    return
end
%cmap=flipud(cmap);
R=sortrows(R,5);

probs=uint8((normalized(R(:,5)))*(size(cmap,1)-1))+1;
for i=1:size(R,1)
    if R(i,3)>0 && R(i,4)>0
        rectangle('position',[R(i,1) R(i,2) R(i,3)-R(i,1) R(i,4)-R(i,2)],'edgecolor',cmap(probs(i),:),'linewidth',lw);
    end
end
%cmap(probs(i),:)
if winflag
    wx=R(:,1)-R(:,3)/6;
    wy=R(:,2)-R(:,4)/6;
    ww=R(:,3)+R(:,3)/3;
    wl=R(:,4)+R(:,4)/3;
    
    R2=[wx wy ww wl];
    for i=1:size(R2,1)
        if R(i,3)>0 && R(i,4)>0
            rectangle('position',R2(i,1:4),'LineStyle',':','edgecolor',cmap(probs(i),:),'linewidth',1)
        end
    end
end
end
