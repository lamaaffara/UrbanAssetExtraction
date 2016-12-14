function [Hv,Lv,imw_v,iml_v]=verticalPerspective(gI,L)

params=rectifParams;

%%
%sort line segments by y-coordinate
ind=L(:,4)>L(:,2);
L=[L(ind,1:2) L(ind,3:4);L(~ind,3:4) L(~ind,1:2)];

%segment endpoints
X1=L(:,1); X2=L(:,3); Y1=L(:,2); Y2=L(:,4);
XY=[X2-X1 Y2-Y1];

%segment orientations
lineangle =(atan(XY(:,2)./XY(:,1)))/pi*180;
lineangle(lineangle<0)=lineangle(lineangle<0)+180;

%discard horizontal line segments
vind=abs(lineangle)>(180-params.lineangleth) | abs(lineangle)<(params.lineangleth);
lineangle_d=lineangle(~vind);
Ld=L(~vind,:);
X1=Ld(:,1); X2=Ld(:,3); Y1=Ld(:,2); Y2=Ld(:,4);

M=[(X1+X2)/2,(Y1+Y2)/2];

%%
%RANSAC fit line to lineangles
options=params.ransacoptions;
X=[M(:,1) lineangle_d]';
[results,~] = RANSAC(X, options);

% Inlier indices
ind = results.CS;

%%
%Calculate homography using inlier segments
A=Ld(ind,1:2)';B=Ld(ind,3:4)';

[iml,imw]=size(gI);

myFunc= @(x) homofun_v(x,[imw;iml]-1,A,B);

[d,f] = fminsearch(myFunc,[0 0]);

[~,Hv]=homofun_v(d,[imw;iml]-1,[],[]);

%% to be used for horizontal perspective
%Calculate boundaries of vertical transformation
boundaries=Hv*[1 imw imw 1;1 1 iml iml;1 1 1 1];
boundaries=boundaries./repmat(boundaries(3,:),[3 1]);
x=boundaries(1,1);

imw_v=boundaries(1,2)+x;
iml_v=boundaries(2,3);


%transform original lines 
A=L(:,1:2)';B=L(:,3:4)';k=size(A,2);
A_=Hv*[A;ones(1,k)];A_=A_./repmat(A_(3,:),[3 1]);
B_=Hv*[B;ones(1,k)];B_=B_./repmat(B_(3,:),[3 1]);
Lv=[A_(1,:)-x;A_(2,:);B_(1,:)-x;B_(2,:)]';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Pipeline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if params.plotflag
    
    cmap=jet;
    nc = length(cmap);
    lb=round((lineangle)/(180)*(nc-1))+1;
    
    %--------------------------
    figure(1);
    imshow(gI);hold on;
    drawLines(Ld,lb,cmap)    
%     medianth=params.medianth;
%     scatter(M(lineangle<=90-medianth,1),M(lineangle<=90-medianth,2),'bo','linewidth',1);
%     scatter(M(lineangle>=90+medianth,1),M(lineangle>=90+medianth,2),'r+','linewidth',1);
%     scatter(M(lineangle<90+medianth & lineangle>90-medianth,1),M(lineangle<90+medianth & lineangle>90-medianth,2),'g*','linewidth',1);
%     
    %--------------------------
	figure(2);hold on
    plot(X(1, ind), X(2, ind), 'g*')
	plot(X(1, ~ind), X(2, ~ind), 'ro')
    
	legend('Inliers', 'Outliers')

    d = linspace(1, size(gI,2), 256);
    y = -results.Theta(1)/results.Theta(2)*d - results.Theta(3)/results.Theta(2);
    plot(d, y, 'g', 'LineWidth', 2)
    
    %--------------------------
    figure(3);imshow(gI);hold on;
    drawLines(Ld(ind,:), lb(ind),cool)
    drawLines(Ld(~ind,:), lb(~ind),autumn)
    %--------------------------
    figure(4);
     t=(maketform('projective',(Hv')));
 [vRect] = imtransform(gI,t);%,'XYScale',[1+((x(2)-x(1))/(imw)) 1]);
    imshow(vRect);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
