%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

%% ISP处理之Demosiac
clear
close all
clc
%% 原始图像采样生成bayer图像
I=imread('kodim19.png');
figure;imshow(I);title("原始图像");
[m,n,p]=size(I);

% 采样 生成bayer图像
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

%% matlab自带demosaic函数处理
I2=demosaic(uint8(I1),'grbg');
figure;imshow(I2);title('自带插值');imwrite(I2,'mat.png');

%% 手动插值图像
Simple_out = Simple_Inter(I1, m, n);
figure;imshow(Simple_out/255);title('手动插值');imwrite(Simple_out/255,'手动.png');

%% 双线性插值
Two_out = Demosaic_Twointer(I, m, n);
figure;imshow(Two_out);title('双线性插值');imwrite(Two_out,'双线性插值.png');

%% 插值优化图像 减少拉链和伪色情况+
Output = Demosaic_Inter (I1);
figure;imshow(Output);title('优化');imwrite(Output,'优化插值.png');

