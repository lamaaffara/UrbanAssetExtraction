pdir='\\gmsv-strgcon-01\Lama\LargeScaleWindowDetection\evalutaion\output_strasburg_linearSVM_newOP_ACF_2000_1_0\results\proposals\';
imdir='\\gmsv-strgcon-01\Lama\Dataset_final\strasburg\rectified\';
imname='IMG_2705';
bboxes=dlmread([pdir imname '.txt']);
I=imread([imdir imname '.jpg']);
bb=xy2wl(bboxes(1:end,:));

N=length(bb);

G = sparse(rectint(bb,bb));

A=bb;B=bb;

leftA = A(:,1);
bottomA = A(:,2);
rightA = leftA + A(:,3);
topA = bottomA + A(:,4);

leftB = B(:,1)';
bottomB = B(:,2)';
rightB = leftB + B(:,3)';
topB = bottomB + B(:,4)';

numRectA = size(A,1);
numRectB = size(B,1);

leftA = repmat(leftA, 1, numRectB);
bottomA = repmat(bottomA, 1, numRectB);
rightA = repmat(rightA, 1, numRectB);
topA = repmat(topA, 1, numRectB);

leftB = repmat(leftB, numRectA, 1);
bottomB = repmat(bottomB, numRectA, 1);
rightB = repmat(rightB, numRectA, 1);
topB = repmat(topB, numRectA, 1);


G = (max(0, min(rightA, rightB) - max(leftA, leftB))) .* ...
    (max(0, min(topA, topB) - max(bottomA, bottomB)));

A=G~=abs(leftA-rightA).*abs(topA-bottomA);

G=G.*A;
G=G.*(1-eye(N));

% draw_graph(G>0);

[i,j]=ind2sub([N N],find(G>0));
E=[i';j'];
V=1:N;

[coloring] = dsatur(V',E');

for s=max(degree):-1:min(degree);
    clf;
imshow(I);
hold on
draw2Lines(wl2xy(bb(degree>s,:)), coloring(degree>s),jet);
input('');
end

[S, C] = graphconncomp(sparse(G));

for s=1:S;
    clf;
imshow(I);
hold on
draw2Lines(wl2xy(bb(C==s,:)), coloring(C==s),jet);
input('');
end

D = degree(G);







