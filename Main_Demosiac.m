%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

%% ISP����֮Demosiac
clear
close all
clc
%% ԭʼͼ���������bayerͼ��
I=imread('kodim19.png');
figure;imshow(I);title("ԭʼͼ��");
[m,n,p]=size(I);

% ���� ����bayerͼ��
I1=zeros(m,n);
for i=1:1:m/2
    for j=1:1:n/2
        I1(i*2-1,j*2-1)=I(i*2-1,j*2-1,2);
        I1(i*2,j*2)=I(i*2,j*2,2);
        I1(i*2,j*2-1)=I(i*2,j*2-1,3);
        I1(i*2-1,j*2)=I(i*2-1,j*2,1);
    end
end
figure;imshow(I1/255);imwrite(I1/255,'stripes2.png');

%% matlab�Դ�demosaic��������
I2=demosaic(uint8(I1),'grbg');
figure;imshow(I2);

%% �ֶ���ֵͼ��
I3=zeros(m+2,n+2);
for i=1:1:m
    for j=1:1:n
        I3(i+1,j+1)=I1(i,j);
    end
end
for i=1:1:m/2
    for j=1:1:n/2
        I4(i*2-1,j*2-1,2)=I3(i*2,j*2);
        I4(i*2-1,j*2-1,1)=(I3(i*2,j*2-1)+I3(i*2,j*2+1))/2;
        I4(i*2-1,j*2-1,3)=(I3(i*2-1,j*2)+I3(i*2+1,j*2))/2;
        I4(i*2,j*2,2)=I3(i*2+1,j*2+1);
        I4(i*2,j*2,1)=(I3(i*2+2,j*2+1)+I3(i*2,j*2+1))/2;
        I4(i*2,j*2,3)=(I3(i*2+1,j*2+2)+I3(i*2+1,j*2))/2;
        I4(i*2,j*2-1,3)=I3(i*2+1,j*2);
        I4(i*2,j*2-1,2)=(I3(i*2,j*2)+I3(i*2+2,j*2)+I3(i*2+1,j*2-1)+I3(i*2+1,j*2+1))/4;
        I4(i*2,j*2-1,1)=(I3(i*2,j*2-1)+I3(i*2,j*2+1)+I3(i*2+2,j*2-1)+I3(i*2+2,j*2+1))/4;
        I4(i*2-1,j*2,1)=I3(i*2,j*2+1);
        I4(i*2-1,j*2,2)=(I3(i*2-1,j*2+1)+I3(i*2+1,j*2+1)+I3(i*2,j*2)+I3(i*2,j*2+2))/4;
        I4(i*2-1,j*2,3)=(I3(i*2-1,j*2)+I3(i*2-1,j*2+2)+I3(i*2+1,j*2)+I3(i*2+1,j*2+2))/4;
    end
end
figure;imshow(I4/255);