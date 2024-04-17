function [num]=cancer(path)
Image=imread(char(path));

figure
imshow(Image);

A=imcrop(imresize(rgb2gray(Image),[500 600]),[95.5 26.5 433 438]);
figure
imshow(A);

h=fspecial('laplacian');
lap=imfilter(A,h,'replicate');
lap1=imadjust(mat2gray(A-lap))-0.2;
figure
imshow(lap1);
a=im2double(lap1);

T=0.5*(min(a(:))+max(a(:)));
d=0.01;
done=0;
while ~done
g=a>=T;
t=0.5*(mean(a(g))+mean(a(~g)));
done=abs(T-t)<d;
T=t;
end
bw=1-im2bw(a,T);
figure
imshow(bw);

se1=strel('disk',1);
b=imerode(bw,se1);
figure
imshow(b);
se=strel('disk',1);
o=imopen(b,se);
figure
imshow(o);
Image = imfill(o,'holes');
[L,ob] = bwlabel(Image);
figure
imshow(Image );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
se2=strel('disk',1);
rode=imerode(Image,se);
pre=Image-rode;
figure
imshow(pre+lap1);


[pixli j]=find(Image==1);
area=length(pixli);

[ii jj]=find(pre==1);
boundaryval=length(ii);

c=round((boundaryval.^2)/(4*pi*area));

lc=round(sqrt( (  ii(1)-ii(length(ii))  ).^2 + (  jj(length(ii)-jj(1) )  ).^2));
lp=round(sqrt( ( ii(length(ii)- ii(1))  ).^2 + (  jj(length(ii)-jj(1) )  ).^2));
if((abs(lc-lp)<20) || (boundaryval<=23000) ) 
circle=0;
end
if((abs(lc-lp)>20) && (boundaryval<=1500) )
 circle=1;
end

feature=[area,boundaryval,lc,lp];
display(feature);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

feature=[area,boundaryval,lc,lp,circle];
display(feature);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=feature;
%the neural network consist of three layers 'two hidden layers and output layer'
net=newff(minmax(feature),[1,20,15,1],{'tansig','tansig','tansig','purelin'},'trainlm');
%determine parameters
net.trainParam.show=3;
net.trainParam.lr=0.001;
net.trainParam.epochs=100;
[net,tr]=train(net,feature,out);
outn=sim(net,feature);
final=abs(outn/100)

nntraintool('close');
con=[117.7520,117.7520, 117.7520, 117.7520, 117.7520;
    188.9340,188.9340,188.9340,188.9340,188.9340;
    125.5400 ,125.5400 , 125.5400 , 125.5400 , 125.5400];
 
def1=abs(con(1,:)-final);
def2=abs(con(2,:)-final);
def3=abs(con(3,:)-final);
 
confinal=[def1;def2;def3];
[f1 p1]=min(confinal(:,1));
[f2 p2]=min(confinal(:,2));
[f3 p3]=min(confinal(:,3));
[f4 p4]=min(confinal(:,4));
[f5 p5]=min(confinal(:,5));

p=[p1 p2 p3 p4 p5];
am=find(p~=1);
if(length(am)>=1)
num='canser';

else
   num='safe';
    
end
end
    
  



 
       



