function draw2Lines(L, labels,cmap)

colors = cmap;

nl = size(L,1);
for i=1:nl
    plot(L(i,1:2:4),L(i,2:2:4),'-','Color',colors(labels(i),:),'LineWidth',1);
    plot([L(i,3) L(i,1)],[L(i,2) L(i,4)],'-','Color',colors(labels(i),:),'LineWidth',1);
end

end