function [Hh,d]=horizontalPerspective(imw_v,iml_v,Lv)

params=rectifParams;

%%
%sort line segments by y-coordinate
ind=Lv(:,3)>Lv(:,1);
Lv=[Lv(ind,1:2) Lv(ind,3:4);Lv(~ind,3:4) Lv(~ind,1:2)];

%segment endpoints
X1=Lv(:,1); X2=Lv(:,3); Y1=Lv(:,2); Y2=Lv(:,4);
XY=[X2-X1 Y2-Y1];

%segment orientations
lineangle =(atan(XY(:,2)./XY(:,1)))/pi*180;

%discard vertical line segments
vind=abs(lineangle)>90-params.lineangleth;
lineangle_d=lineangle(~vind);
Ld=Lv(~vind,:);
X1=Ld(:,1); X2=Ld(:,3); Y1=Ld(:,2); Y2=Ld(:,4);

M=[(X1+X2)/2,(Y1+Y2)/2];

%%
%RANSAC fit line to lineangles
options=params.ransacoptions;
X=[M(:,2) lineangle_d]';X_=X;indices=1:size(X,2);
for k=1:1
[results,~] = RANSAC(X_, options);
% Inlier indices
ind = results.CS;
IND{k}=indices(ind);
X_(:,ind)=[];
indices(ind)=[];
end

%%
%Calculate homography using inlier segments
A=Ld(ind,1:2)';B=Ld(ind,3:4)';

imw=imw_v;iml=iml_v;

myFunc= @(x) homofun_h(x,[imw;iml]-1,A,B);

% optimization
options = optimset;
options = optimset(options,'Display', 'off');
options = optimset(options,'Algorithm', 'active-set');
[d,f] = fmincon(myFunc,[0 0],[],[],[],[],[-4*iml -4*iml],[4*iml 4*iml],[],options);
%[d,f] = fminsearch(myFunc,[0 0]);
[~,Hh]=homofun_h(d,[imw;iml]-1,[],[]);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Pipeline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if params.plotflag
    
    cmap=jet;
    nc = length(cmap);
    lb=round((lineangle_d+90-params.lineangleth)/(180-2*params.lineangleth)*(nc-1))+1;
    
    %--------------------------
    figure(1);
    imshow(gI);hold on;
    drawLines(Ld,lb,cmap)
    medianth=params.medianth;
    scatter(M(lineangle_d<=90-medianth,1),M(lineangle_d<=90-medianth,2),'bo','linewidth',1);
    scatter(M(lineangle_d>=90+medianth,1),M(lineangle_d>=90+medianth,2),'r+','linewidth',1);
    scatter(M(lineangle_d<90+medianth & lineangle_d>90-medianth,1),M(lineangle_d<90+medianth & lineangle_d>90-medianth,2),'g*','linewidth',1);
    
    %--------------------------
    figure(2);hold on
    plot(X(1, ind), X(2, ind), 'g*')
    plot(X(1, ~ind), X(2, ~ind), 'ro')
    
    legend('Inliers', 'Outliers')
    
    d = linspace(1, size(gI,2), 256);
    y = -results.Theta(1)/results.Theta(2)*d - results.Theta(3)/results.Theta(2);
    plot(d, y, 'g', 'LineWidth', 2)
    
    %--------------------------
    figure(3);imshow(vRect);hold on;
    drawLines(Ld(ind,:), lb(ind),cmap)
    
    %--------------------------
    figure(4);
    imshow(Irect);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
