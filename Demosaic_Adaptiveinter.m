function Output = Demosaic_Adaptiveinter(Input_bayer, hei, wid)

bayerPad = Input_bayer;
[hei_be,wid_be,p]=size(bayerPad);
add_h =(hei_be - hei)/2;%扩展行列数
add_w =(wid_be - wid)/2;
%% 自适应插值
%输入 bayer生成bayer图像 GRBG
figure;imshow(bayerPad);title('bayer');

Out(:,:,1) =bayerPad ;Out(:,:,2) =bayerPad ;Out(:,:,3) = bayerPad;
figure;imshow(uint8(Out));title('baye插值');imwrite(uint8(Out),'Out.png');


%% GBRG
% G R G R G R
% B G B G B G
% G R G R G R
% B G B G B G
%%
%判断bayer图像、bayer排列、是否扩展\
Out_R = zeros(hei_be,wid_be);
Out_G = zeros(hei_be,wid_be);
Out_B = zeros(hei_be,wid_be);

%% 补充红、蓝 通道缺失的的G像素
%% 计算R像素关于G的水平梯度、垂直梯度
for ver = (add_h+1):2:hei+1
    for hor = (add_w+1):2:wid+1
        Out_G(ver, hor) = bayerPad(ver, hor);    
    end
    for hor = (add_w+2):2:wid+2
        %构建R滤光片缺失的G分量
        H_Rg = abs(bayerPad(ver, hor-1)-bayerPad(ver, hor+1)) + abs(2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)); %水平梯度
        V_Rg = abs(bayerPad(ver-1, hor)-bayerPad(ver+1, hor)) + abs(2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor)); %垂直梯度
        
        if(H_Rg < V_Rg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2))/4;
        elseif(H_Rg > V_Rg)
            G = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/4 ;  
        elseif(H_Rg == V_Rg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1)+bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/4 + ...
               (4*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/8;    
        end
        Out_G(ver, hor) = G; 
        % raw数据R分量提取
        Out_R(ver, hor) = bayerPad(ver, hor);  
    end
end

figure;imshow(uint8(Out_G));imwrite(uint8(Out_G),'Out_G_111.png');

%% 计算B通道关于G的水平梯度、垂直梯度
for ver = (add_h+2):2:hei+2
    for hor = (add_w+1):2:wid+1
        
        H_Bg = abs(bayerPad(ver, hor-1)-bayerPad(ver, hor+1)) + abs(2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)); %水平梯度
        V_Bg = abs(bayerPad(ver-1, hor)-bayerPad(ver+1, hor)) + abs(2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor)); %垂直梯度
        
        if(H_Bg < V_Bg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2))/4;
        elseif(H_Bg > V_Bg)
            G = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver-2, hor))/4 ;   
        elseif(H_Bg == V_Bg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1)+bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/4 + ...
               (4*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/8;    
        end
        Out_G(ver, hor) = G;
        % raw数据B分量提取
        Out_B(ver, hor) = bayerPad(ver, hor); 
    end
    for hor = (add_w+2):2:wid+2
        Out_G(ver, hor) = bayerPad(ver, hor);
    end
end
%% G分量构建完成
figure;imshow(uint8(Out_G));title('G插值');imwrite(uint8(Out_G),'Out_G.png');


%% 补充绿色通道缺失的R\B像素
%% GBRG
% G R G R G R
% B G B G B G
% G R G R G R
% B G B G B G
for ver = (add_h+1):2:hei+1
    for hor = (add_w+1):2:wid+1

        R = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*Out_G(ver, hor)-Out_G(ver, hor-1)-Out_G(ver, hor+1))/2;
        B = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor)-Out_G(ver+1, hor))/2;
        Out_R(ver, hor) = R;
        Out_B(ver, hor) = B;
       
    end
end

for ver = (add_h+2):2:hei+2
    for hor = (add_w+2):2:wid+2

        B = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*Out_G(ver, hor)-Out_G(ver, hor-1)-Out_G(ver, hor+1))/2;
        R = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor)-Out_G(ver+1, hor))/2;
        Out_R(ver, hor) = R;
        Out_B(ver, hor) = B;
    end
end

%% 补充红（蓝）通道缺失的B（R）像素
%% GBRG
% G R G R G R
% B G B G B G
% G R G R G R
% B G B G B G
%计算红通道关于G的倾斜左下梯度(N_Rg)、倾斜左上梯度(P_Rg)
for ver = (add_h+1):2:hei+1
    for hor = (add_w+2):2:wid+2
        N_Rg = abs(bayerPad(ver-1, hor-1)-bayerPad(ver+1, hor+1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)); %水平梯度
        P_Rg = abs(bayerPad(ver-1, hor+1)-bayerPad(ver+1, hor-1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1)); %垂直梯度
        
        if(N_Rg < P_Rg)
            B = (bayerPad(ver-1, hor-1)+bayerPad(ver+1, hor+1))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1))/2;
        elseif(N_Rg > P_Rg)
            B = (bayerPad(ver-1, hor+1)+bayerPad(ver+1, hor-1))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1))/2 ;   
        elseif(N_Rg == P_Rg)
            B = (bayerPad(ver-1, hor-1)+bayerPad(ver+1, hor+1)+bayerPad(ver-1, hor+1)+bayerPad(ver+1, hor-1))/4 + ...
               (4*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1))/4;    
        end
        Out_B(ver, hor) = B;
    end
end

%计算蓝通道关于R的倾斜左下梯度(N_Bg)、倾斜左上梯度(P_Bg)
for ver = (add_h+2):2:hei+2
    for hor = (add_w+1):2:wid+1
        N_Bg = abs(bayerPad(ver-1, hor-1)-bayerPad(ver+1, hor+1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)); %水平梯度
        P_Bg = abs(bayerPad(ver-1, hor+1)-bayerPad(ver+1, hor-1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1)); %垂直梯度
        
        if(N_Bg < P_Bg)
            R = (bayerPad(ver-1, hor-1)+bayerPad(ver+1, hor+1))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1))/2;
        elseif(N_Bg > P_Bg)
            R = (bayerPad(ver-1, hor+1)+bayerPad(ver+1, hor-1))/2 + (2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1))/2 ;   
        elseif(N_Bg == P_Bg)
            R = (bayerPad(ver-1, hor-1)+bayerPad(ver+1, hor+1)+bayerPad(ver-1, hor+1)+bayerPad(ver+1, hor-1))/4 + ...
                (4*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1))/4;    
        end
        Out_R(ver, hor) = R;
    end
end

figure;imshow(uint8(Out_R));title('r插值');imwrite(uint8(Out_R),'Out_R.png');
figure;imshow(uint8(Out_G));title('g插值');imwrite(uint8(Out_G),'Out_G.png');
figure;imshow(uint8(Out_B));title('B插值');imwrite(uint8(Out_B),'Out_B.png');

Output(:,:,1) = Out_R(add_h+1:hei+2,add_w+1:wid+2);
Output(:,:,2) = Out_G(add_h+1:hei+2,add_w+1:wid+2);
Output(:,:,3) = Out_B(add_h+1:hei+2,add_w+1:wid+2);
