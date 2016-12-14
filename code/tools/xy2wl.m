function boxes=xy2wl(boxes)
boxes(:,3)=boxes(:,3)-boxes(:,1);
boxes(:,4)=boxes(:,4)-boxes(:,2);
end