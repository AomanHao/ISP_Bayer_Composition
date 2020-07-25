function Simple_out = Simple_Inter(img, m ,n)
%%
%简单插值
%输入
%img bayer图像, m 长 ,n 宽

img_pro=zeros(m+2,n+2);
for i=1:1:m
    for j=1:1:n
        img_pro(i+1,j+1)=img(i,j);
    end
end
for i=1:1:m/2
    for j=1:1:n/2
        Simple_out(i*2-1,j*2-1,2)=img_pro(i*2,j*2);
        Simple_out(i*2-1,j*2-1,1)=(img_pro(i*2,j*2-1)+img_pro(i*2,j*2+1))/2;
        Simple_out(i*2-1,j*2-1,3)=(img_pro(i*2-1,j*2)+img_pro(i*2+1,j*2))/2;
        Simple_out(i*2,j*2,2)=img_pro(i*2+1,j*2+1);
        Simple_out(i*2,j*2,1)=(img_pro(i*2+2,j*2+1)+img_pro(i*2,j*2+1))/2;
        Simple_out(i*2,j*2,3)=(img_pro(i*2+1,j*2+2)+img_pro(i*2+1,j*2))/2;
        Simple_out(i*2,j*2-1,3)=img_pro(i*2+1,j*2);
        Simple_out(i*2,j*2-1,2)=(img_pro(i*2,j*2)+img_pro(i*2+2,j*2)+img_pro(i*2+1,j*2-1)+img_pro(i*2+1,j*2+1))/4;
        Simple_out(i*2,j*2-1,1)=(img_pro(i*2,j*2-1)+img_pro(i*2,j*2+1)+img_pro(i*2+2,j*2-1)+img_pro(i*2+2,j*2+1))/4;
        Simple_out(i*2-1,j*2,1)=img_pro(i*2,j*2+1);
        Simple_out(i*2-1,j*2,2)=(img_pro(i*2-1,j*2+1)+img_pro(i*2+1,j*2+1)+img_pro(i*2,j*2)+img_pro(i*2,j*2+2))/4;
        Simple_out(i*2-1,j*2,3)=(img_pro(i*2-1,j*2)+img_pro(i*2-1,j*2+2)+img_pro(i*2+1,j*2)+img_pro(i*2+1,j*2+2))/4;
    end
end