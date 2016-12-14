function [grid_bb,pdfx,pdfy,pdfs,pdfar,tx_best,ty_best]=expandgrid(bball,W,L)

ww=exp(bball(:,9));

x = bball(:,1);
y = bball(:,2);
w = abs([bball(:,3)-bball(:,1)]);
l = abs([bball(:,4)-bball(:,2)]);
pdfx= ksdensity(x,1:W,'weight',ww*1000,'bandwidth',5);
pdfy= ksdensity(y,1:L,'weight',ww*1000,'bandwidth',5);
pdfw= ksdensity(w,1:W,'weight',ww*1000,'bandwidth',5);
pdfl= ksdensity(l,1:L,'weight',ww*1000,'bandwidth',5);
pdfar= ksdensity(w./l,0:0.01:10,'weight',ww*1000,'bandwidth',0.05);pdfar=pdfar/sum(pdfar); 


ww=[exp(bball(:,9));exp(bball(:,9))];
tx = abs([bball(:,5);bball(:,7)]);
ty = abs([bball(:,6);bball(:,8)]);
pdftx= ksdensity(tx,1:W,'weight',ww*1000,'bandwidth',5);
pdfty= ksdensity(ty,1:L,'weight',ww*1000,'bandwidth',5);


[valx,pkx]=findpeaks(pdfx);[~,indmax]=max(valx);x_best=pkx(indmax);
[valy,pky]=findpeaks(pdfy);[~,indmax]=max(valy);y_best=pky(indmax);
[valtx,pktx]=findpeaks(pdftx);[~,indmax]=max(valtx);tx_best=pktx(indmax);
[valty,pkty]=findpeaks(pdfty);[~,indmax]=max(valty);ty_best=pkty(indmax);
[valw,pkw]=findpeaks(pdfw);[~,indmax]=max(valw);w_best=pkw(indmax);
[vall,pkl]=findpeaks(pdfl);[~,indmax]=max(vall);l_best=pkl(indmax);

if tx_best/2>w_best
    tx_best=tx_best/2;
end

if ty_best/2>l_best
    ty_best=ty_best/2;
end

xrepeat=(-10:10)*tx_best+x_best;
xrepeat=xrepeat(xrepeat>=1 & xrepeat<=W);

yrepeat=(-10:10)*ty_best+y_best;
yrepeat=yrepeat(yrepeat>=1 & yrepeat<=L);

[xx,yy]=meshgrid(xrepeat,yrepeat);
xy=[xx(:) yy(:)];
grid_bb=wl2xy([xy repmat([w_best l_best],[length(xx(:)) 1])]);

pdfx = interp1( linspace(0,1,numel(pdfx)), pdfx, linspace(0,1,1001) );
pdfy = interp1( linspace(0,1,numel(pdfy)), pdfy, linspace(0,1,1001) );
pdfs=interp1( linspace(0,1,numel(pdfl)), pdfl, linspace(0,1,1001));
% plot grid
% plot([xrepeat;xrepeat],(repmat([1;L],[1 length(xrepeat)])),'m','linewidth',2)
% plot((repmat([1;W],[1 length(yrepeat)])),[yrepeat;yrepeat],'m','linewidth',2)
% rectangle('position',[x_best y_best w_best l_best],'edgecolor','m','linewidth',2)

end
