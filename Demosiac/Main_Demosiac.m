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

% ���� ����bayerͼ�� GRBG
bayer=zeros(m,n);
for i=1:1:m/2
    for j=1:1:n/2
        bayer(i*2-1,j*2-1)=I(i*2-1,j*2-1,2);
        bayer(i*2,j*2)=I(i*2,j*2,2);
        bayer(i*2,j*2-1)=I(i*2,j*2-1,3);
        bayer(i*2-1,j*2)=I(i*2-1,j*2,1);
    end
end
figure;imshow(uint8(bayer));imwrite(uint8(bayer),'stripes2.png');

%% bayer��չ��0Ԫ�ز��䣨Ĭ�ϣ������ܱ����и�ֵ
bayerPad = bayerPadding(bayer, m, n);
imwrite(uint8(bayerPad),'bayerPad.png');

%% matlab�Դ�demosaic��������
I2=demosaic(uint8(bayer),'grbg');
figure;imshow(I2);title('�Դ���ֵ');imwrite(I2,'mat.png');

%% �ֶ���ֵͼ��
Simple_out = Simple_Inter(bayer, m, n);
figure;imshow(uint8(Simple_out));title('�ֶ���ֵ');imwrite(uint8(Simple_out),'�ֶ�.png');

%% ˫���Բ�ֵ 
OutputTwo = Demosaic_Twointer(I,m, n);
figure;imshow(OutputTwo);imwrite(OutputTwo,'TwoOutput.png');

%% ����Ӧ��ֵ hamilton adams
OutputAda = Demosaic_Adaptiveinter(bayerPad,m, n);
imshow(uint8(OutputAda));title('����Ӧ��ֵ');imwrite(uint8(OutputAda),'OutputAda.png');
