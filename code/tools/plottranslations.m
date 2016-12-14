function plottranslations(R,tr,cmap,winflag,lw)

if isempty(R)
    return
end

[R,ind]=sortrows(R,5);
tr=tr(ind,:);

probs=uint8((1-normalized([R(:,5);-0.01]))*(size(cmap,1)-1))+1;
for i=1:size(R,1)
       line([R(i,1) -tr(i,1)+R(i,1)],[R(i,2) R(i,2)],'color',cmap(probs(i),:),'linewidth',lw);
       scatter(-tr(i,1)+R(i,1),R(i,2),'MarkerFaceColor',cmap(probs(i),:),'MarkerEdgeColor',cmap(probs(i),:),'linewidth',lw);
        line([R(i,1) R(i,1)],[R(i,2) -tr(i,2)+R(i,2)],'color',cmap(probs(i),:),'linewidth',lw);
        scatter(R(i,1),-tr(i,2)+R(i,2),'MarkerFaceColor',cmap(probs(i),:),'MarkerEdgeColor',cmap(probs(i),:),'linewidth',lw);
end

end
