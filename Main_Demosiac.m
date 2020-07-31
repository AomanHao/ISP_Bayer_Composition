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
figure;imshow(I2);title('�Դ���ֵ');imwrite(I2,'mat.png');

%% �ֶ���ֵͼ��
Simple_out = Simple_Inter(I1, m, n);
figure;imshow(Simple_out/255);title('�ֶ���ֵ');imwrite(Simple_out/255,'�ֶ�.png');

%% ˫���Բ�ֵ
Two_out = Demosaic_Twointer(I, m, n);
figure;imshow(Two_out);title('˫���Բ�ֵ');imwrite(Two_out,'˫���Բ�ֵ.png');

%% ��ֵ�Ż�ͼ�� ����������αɫ���+
Output = Demosaic_Inter (I1);
figure;imshow(Output);title('�Ż�');imwrite(Output,'�Ż���ֵ.png');

