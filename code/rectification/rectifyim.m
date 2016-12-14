function [Irect,H]=rectifyim(I)

gI = rgb2gray(I);

%lsd line detection
L = lsd(double(gI));

%apply vertical perspective
[Hv,Lv,imw_v,iml_v]=verticalPerspective(gI,L);

%apply horizontal perspective
Hh=horizontalPerspective(imw_v,iml_v,Lv);

H=Hh*Hv;

t=(maketform('projective',H'));
Irect = imtransform(I,t);

end