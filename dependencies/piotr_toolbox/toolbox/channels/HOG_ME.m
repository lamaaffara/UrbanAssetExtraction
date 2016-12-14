 clear all;close all;
imdir='E:\E\KAUST\GMSV\Datasets\Urban\strasburg\rectified\';
imname='IMG_2996.jpg'; 

I1=imResample(single(imread([imdir imname])),[480 640])/255;

figure;imshow(I1)

W=[53 77 20 40];

tic
for k=1:100
P=I1((W(2)):((W(2)+W(4))),(W(1)):((W(1)+W(3))),:);
p_r=imresize(P,[128,128]);
hog(p_r,8,9);
end
toc


P=I1((W(2)):((W(2)+W(4))),(W(1)):((W(1)+W(3))),:);
p_r=imresize(P,[128,128]);
H_0=hog(p_r,8,9);

figure;imshow(P)

binsize=2;

tic
parfor s=1:24
H=hog(I1,binsize,9);
H=H(:,:,1:end);
for k=1:1000
p_h=H(round(W(2)/binsize):round((W(2)+W(4))/binsize),round(W(1)/binsize):round((W(1)+W(3))/binsize),:);
imresize(p_h,[16 16]);
end
end
toc



tic
for k=1:1
S1=imresize(p_h,[16 16]);
end
toc

tic
for k=1:1
    for d=1:36
S2(:,:,d)=resizem(p_h(:,:,d),[16 16]);
    end
end
toc

M=p_h;
[m,n,p]=size(M); %<-- fixed

 M=sum( reshape(M,3,[]) );
 M=reshape(M,m/p,[]).';
 
 M=sum( reshape(M,3,[]) );
 M=reshape(M,n/p,[]).';

M=reshape(M,m/p,n/p,p); %<--- added


p_h=H(round(W(2)/binsize):round((W(2)+W(4))/binsize),round(W(1)/binsize):round((W(1)+W(3))/binsize),:);
F_d=imresize(p_h,[16 16]);

% 
% tic
% binsize=4;
% chnns=chnsCompute(I1);
% H=chnns.data{3};
% parfor k=1:10000
% p_h=H(round(W(2)/binsize):round((W(2)+W(4))/binsize),round(W(1)/binsize):round((W(1)+W(3))/binsize),:);
% imresize(p_h,[16 16]);
% end
% toc
% return
% 
% p_h=H(round(W(2)/binsize):round((W(2)+W(4))/binsize),round(W(1)/binsize):round((W(1)+W(3))/binsize),:);
% F_d=imresize(p_h,[32 32]);
% % 
% 
% P=I1((W(2)):((W(2)+W(4))),(W(1)):((W(1)+W(3))),:);
% p_r=imresize(P,[128,128]);
% chnns=chnsCompute(p_r);
% H=chnns.data{3};

V=hogDraw(H_0,25);figure; im(V)
V=hogDraw(F_d,25);figure; im(V)

 diff=sqrt((H_0-F_d).^2);
 mean(diff(:))
% 
% imdir='E:\E\KAUST\GMSV\Datasets\Urban\strasburg\rectified\';
% imname='IMG_2737.jpg'; 
% 
% I2=imResample(single(imread([imdir imname])),[480 640])/255;
% 
% 
% H1_0=hog(I1,2,9);
% H1_1=hog(I1,8,9);
% H1_2=hog(I1,16,9);
% 
% 
% H1=hog(I1,10,9);
% 
% 
% %downsalmple
% F_d=single(zeros(size(H1_1)));
% for i=1:36
% F_d(:,:,i)=imresize(H1_0(:,:,i),[size(H1_1,1) size(H1_1,2)],'bicubic');
% end
%  
% 
% %upsample
% F_u=single(zeros(size(H1)));
% for i=1:36
% F_u(:,:,i)=imresize(H1_2(:,:,i),[size(H1,1) size(H1,2)],'bicubic');
% end
%  
% F=(F_d+F_u)/2;
% 
% D=sqrt((F_d-H1_1).^2);
% mean(D(:))
% 
for k=1:36
    S1(:,:,k)=(S1(:,:,k))+abs(min(S1(:)));
    s=squeeze(S1(:,:,k));
    s(s>0.2)=0.2;
    S1(:,:,k)=s;
end
 subplot(1,3,1);imagesc(S1(:,:,k));
 subplot(1,3,2);imagesc((S2(:,:,k)));
subplot(1,3,3);imagesc(H_0(:,:,k));colormap gray
input('')
end
% 
% for k=1:3
%  subplot(1,3,1);imagesc(I1);
%  subplot(1,3,2);imagesc(imresize(I1,);
% subplot(1,3,3);imagesc((H1_1(:,:,k))-(F_d(:,:,k)));colormap gray
% input('')
% end
% 
% 
% D=sqrt((F_u-H1).^2);
% mean(D(:))
% 
% D=sqrt((F-H1).^2);
% mean(D(:))
% 
% D=sqrt((H1-H2).^2);
% mean(D(:))
% 
% D=sqrt((H1-F).^2);
% mean(D(:))
% 
% figure;
% V=hogDraw(H1,25);subplot(3,1,1); im(V)
% V=hogDraw(H2,25);subplot(3,1,2); im(V)
% V=hogDraw(F,25);subplot(3,1,3); im(V)

% 
% 
% D=sqrt((H1_0-H2_0).^2);
% mean(D(:))
% 
% D=sqrt((H1_0-F).^2);
% mean(D(:))
% 
% figure;
% V=hogDraw(H1_0,25);subplot(3,1,1); im(V)
% V=hogDraw(H2_0,25);subplot(3,1,2); im(V)
% V=hogDraw(F,25);subplot(3,1,3); im(V)
% 
% 
% Vq = interp2(H1(:,:,1));