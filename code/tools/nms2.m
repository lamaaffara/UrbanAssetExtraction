function [top,pick] = nms2(boxes, overlap)
% top = nms_fast(boxes, overlap)
% Non-maximum suppression. (FAST VERSION)
% Greedily select high-scoring detections and skip detections
% that are significantly covered by a previously selected
% detection.
% NOTE: This is adapted from Pedro Felzenszwalb's version (nms.m),
% but an inner loop has been eliminated to significantly speed it
% up in the case of a large number of boxes
% Tomasz Malisiewicz (tomasz@cmu.edu)

 
if isempty(boxes)
  top = [];
  return;
end
 
x1 = boxes(:,1);
y1 = boxes(:,2);
x2 = boxes(:,3);
y2 = boxes(:,4);
s = boxes(:,end);
 
area = (x2-x1+1) .* (y2-y1+1);
[val, inds] = sort(s);
 
pick = s*0;
counter = 1;
while ~isempty(inds)
  
  last = length(inds);
  i = inds(last);  
  pick(counter) = i;
  counter = counter + 1;
  
  xx1 = max(x1(i), x1(inds(1:last-1)));
  yy1 = max(y1(i), y1(inds(1:last-1)));
  xx2 = min(x2(i), x2(inds(1:last-1)));
  yy2 = min(y2(i), y2(inds(1:last-1)));
  
  w = max(0.0, xx2-xx1+1);
  h = max(0.0, yy2-yy1+1);
  
  o = w.*h ./ area(inds(1:last-1));
  
  
  % keep parents (boxes in which current box is fully inside)
  inds([last; find(o<overlap & o>0.3)]) = [];
end
 
pick = pick(1:(counter-1));
top = boxes(pick,:);