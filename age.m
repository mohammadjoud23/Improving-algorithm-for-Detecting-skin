function [num]=age(path)
Image=imread(char(path));
figure
imshow(Image);
A=imresize(rgb2gray(Image),[500 500]);
%figure
%imshow(A);

h=fspecial('laplacian');
lap=imfilter(A,h,'replicate');
lap1=imadjust(mat2gray(A-lap));
%figure
%imshow(lap1);
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

se1=strel('disk',5);
b=imerode(bw,se1);
figure
imshow(b);
se=strel('disk',1);
o=imopen(b,se);
%figure
%imshow(o);
Image = imfill(o,'holes');
[L,ob] = bwlabel(Image);
%figure
%imshow(Image );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
se2=strel('disk',1);
rode=imerode(Image,se);
%figure
%imshow(rode);

pre=Image-rode;
figure

imshow(pre);
figure
cccc=pre+lap1;
imshow(cccc);
%%%%%%%%%%%%%%%%%%%%%%%%%

fontSize = 20;
[rows, columns, numberOfColorBands] = size(cccc);
%subplot(2, 1, 1);
%imshow(cccc, []);

binaryImage =pre;

binaryImage = imclearborder(binaryImage);
binaryImage = bwareaopen(binaryImage, 1000);
%subplot(2, 1, 2);
%imshow(binaryImage, []);
%title('Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
labeledImage = bwlabel(pre, 8);
blobMeasurements = regionprops(labeledImage , 'Centroid');
numberOfBlobs = size(blobMeasurements, 1);
%hold on;
for k = 1 : length(blobMeasurements)
	x = blobMeasurements(k).Centroid(1);
	y = blobMeasurements(k).Centroid(2);
	%plot(x, y, 'r+', 'MarkerSize', 30, 'LineWidth', 3);
	%str = sprintf('The centroid of shape %d is at (%.2f, %.2f)', ...
		%k, x, y);
	%uiwait(helpdlg(str));
end
set=A(x+size(binaryImage,1)/8+80:size(binaryImage,1)-size(binaryImage,1)/8+20,y-size(binaryImage,2)/4:y+size(binaryImage,2)/4);
%figure
%imshow(set);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_sharp=set;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z2=imadjust(I_sharp);
figure
imshow(z2)
aa=0.98;
h=fspecial('gaussian',[3 3],18);
I_smooth=imfilter(z2,h,'replicate');

I_sharp=((1+aa)*z2-aa*I_smooth)+50;
I_sharp=imadjust(I_sharp);
%figure
%imshow(I_sharp)
tt=graythresh(I_sharp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%threshold
b=1-im2bw(I_sharp,tt);
figure
imshow(b)
Image = imfill(b,'holes');
[L,ob] = bwlabel(Image);
%figure
%imshow(Image );

se1=strel('disk',3);
b=imerode(Image,se1);
%figure
%imshow(b);
se=strel('disk',3);
o=imopen(b,se);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pixl counter
t=0;
for x=1:size(o,1)
    for y=5:size(o,2)
        if o(x,y)==1
      t=t+1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bone
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[L,Num] = bwlabel(o);
 e=0;
for i=1:Num
e=e+1;
end
feature=[t,e];
display(feature);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=feature;
%the neural network consist of three layers 'two hidden layers and output layer'
turn=0;
while turn<5
net=newff(minmax(feature),[2,20,15,1],{'tansig','tansig','tansig','purelin'},'trainlm');
%determine parameters
net.trainParam.show=3;
net.trainParam.lr=0.001;
net.trainParam.epochs=100;
[net,tr]=train(net,feature,out);
outn=sim(net,feature);
final=abs(outn/100);
turn=turn+1;
end
display(final);

nntraintool('close');

con=[  71.6400   71.6400;    
       84.1900   84.1900;    
       63.8550   63.8550;    
       45.3850   45.3850;    
       49.2650   49.2650;    
       57.6750   57.6750;    
       64.3300   64.3300;    
       60.2350   60.2350;    
       66.4800   66.4800;    
       70.6050   70.6050;   
       62.3400   62.3400;
       128.6200    0.0400;
       132.9300    0.0300;
       ];
 
 def1=abs(con(1,:)-final);
 def2=abs(con(2,:)-final);
 def3=abs(con(3,:)-final);
 def4=abs(con(4,:)-final);
  def5=abs(con(5,:)-final);
   def6=abs(con(6,:)-final);
    def7=abs(con(7,:)-final);
     def8=abs(con(8,:)-final);
      def9=abs(con(9,:)-final);
       def10=abs(con(10,:)-final);
        def11=abs(con(11,:)-final);
        
     
     
     
confinal=[def1;def2;def3;def4;def5;def6;def7;def8;def9;def10;def11];
[B1 p1]=min(confinal);

if(p1==1)
num='1 -> 3 year';
end

if(p1==2)
num='1 -> 3 year';
end

if(p1==3)
num='4-> 7 year';
end
if(p1==4)
num='4->7year';
end


if(p1==5)
num='8->10year';
end


if(p1==6)
num='8->10year';
end


if(p1==7)
num='10-13 year';
end


if(p1==8)
num='15 year';
end


if(p1==9)
num='16 year';
end

if(p1==10)
num='17 year';
end
if(p1==11)
num='18 year';
end
if(p1==12)
num='13 year';
end

if(p1==13)
num='16 year';
end






end