clc;clear;close all;

img=imread('kodim19.png');  
figure;
subplot(121),imshow(img),title('原图');

%% 灰度世界
R = img(:,:,1);G = img(:,:,2);B = img(:,:,3);  
Rave = mean2(R);
Gave = mean2(G); 
Bave = mean2(B);
K = (Rave + Gave + Bave) / 3;

R_new=(K/Rave)*R;G_new=(K/Gave)*G;B_new=(K/Bave)*B;

subplot(122),imshow(cat(3,R_new,G_new,B_new)),title('平衡后');

%% 全反射
histRGB=zeros(765);
[m,n,h]=size(img);
for i=1:m
    for j=1:n
        s=sum(img(i,j,:));
        histRGB(s)=histRGB(s)+1;
    end
end

num=0;
for i=1:765
    num=num+histRGB(766-i);
    if num>m*n*0.1
        thresh=765-i;
        break
    end
end

amount=0;
Rave=0;Gave=0;Bave=0;
for i=1:m
    for j=1:n
        s=sum(img(i,j,:));
        if s>thresh
            Rave=(Rave*amount+R(i,j))/(amount+1);
            Gave=(Gave*amount+G(i,j))/(amount+1);
            Bave=(Bave*amount+B(i,j))/(amount+1);
            amount=amount+1;
        end
    end
end

for i=1:m
    for j=1:n
        R(i,j)=255*R(i,j)/Rave;
        if R(i,j)>255
            R(i,j)=255;
        end
        G(i,j)=255*G(i,j)/Gave;
        if G(i,j)>255
            G(i,j)=255;
        end
        B(i,j)=255*B(i,j)/Bave;
        if B(i,j)>255
            B(i,j)=255;
        end
    end
end
   
figure;
subplot(122),imshow(uint8(cat(3,R,G,B))),title('平衡后');
