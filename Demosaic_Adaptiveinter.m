function Output = Demosaic_Adaptiveinter(Input_bayer, hei, wid)

bayerPad = Input_bayer;
[hei_be,wid_be,p]=size(bayerPad);
add_h =(hei_be - hei)/2;%��չ������
add_w =(wid_be - wid)/2;
%% ����Ӧ��ֵ
%���� bayer����bayerͼ�� GRBG
figure;imshow(bayerPad);title('bayer');

Out(:,:,1) =bayerPad ;Out(:,:,2) =bayerPad ;Out(:,:,3) = bayerPad;
figure;imshow(uint8(Out));title('baye��ֵ');imwrite(uint8(Out),'Out.png');


%% GBRG
% G R G R G R
% B G B G B G
% G R G R G R
% B G B G B G
%%
%�ж�bayerͼ��bayer���С��Ƿ���չ\
Out_R = zeros(hei_be,wid_be);
Out_G = zeros(hei_be,wid_be);
Out_B = zeros(hei_be,wid_be);

%% ����졢�� ͨ��ȱʧ�ĵ�G����
%% ����R���ع���G��ˮƽ�ݶȡ���ֱ�ݶ�
for ver = (add_h+1):2:hei+1
    for hor = (add_w+1):2:wid+1
        Out_G(ver, hor) = bayerPad(ver, hor);    
    end
    for hor = (add_w+2):2:wid+2
        %����R�˹�Ƭȱʧ��G����
        H_Rg = abs(bayerPad(ver, hor-1)-bayerPad(ver, hor+1)) + abs(2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)); %ˮƽ�ݶ�
        V_Rg = abs(bayerPad(ver-1, hor)-bayerPad(ver+1, hor)) + abs(2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor)); %��ֱ�ݶ�
        
        if(H_Rg < V_Rg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2))/4;
        elseif(H_Rg > V_Rg)
            G = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/4 ;  
        elseif(H_Rg == V_Rg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1)+bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/4 + ...
               (4*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/8;    
        end
        Out_G(ver, hor) = G; 
        % raw����R������ȡ
        Out_R(ver, hor) = bayerPad(ver, hor);  
    end
end

figure;imshow(uint8(Out_G));imwrite(uint8(Out_G),'Out_G_111.png');

%% ����Bͨ������G��ˮƽ�ݶȡ���ֱ�ݶ�
for ver = (add_h+2):2:hei+2
    for hor = (add_w+1):2:wid+1
        
        H_Bg = abs(bayerPad(ver, hor-1)-bayerPad(ver, hor+1)) + abs(2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)); %ˮƽ�ݶ�
        V_Bg = abs(bayerPad(ver-1, hor)-bayerPad(ver+1, hor)) + abs(2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor)); %��ֱ�ݶ�
        
        if(H_Bg < V_Bg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1))/2 + (2*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2))/4;
        elseif(H_Bg > V_Bg)
            G = (bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/2 + (2*bayerPad(ver, hor)-bayerPad(ver-2, hor)-bayerPad(ver-2, hor))/4 ;   
        elseif(H_Bg == V_Bg)
            G = (bayerPad(ver, hor-1)+bayerPad(ver, hor+1)+bayerPad(ver-1, hor)+bayerPad(ver+1, hor))/4 + ...
               (4*bayerPad(ver, hor)-bayerPad(ver, hor-2)-bayerPad(ver, hor+2)-bayerPad(ver-2, hor)-bayerPad(ver+2, hor))/8;    
        end
        Out_G(ver, hor) = G;
        % raw����B������ȡ
        Out_B(ver, hor) = bayerPad(ver, hor); 
    end
    for hor = (add_w+2):2:wid+2
        Out_G(ver, hor) = bayerPad(ver, hor);
    end
end
%% G�����������
figure;imshow(uint8(Out_G));title('G��ֵ');imwrite(uint8(Out_G),'Out_G.png');


%% ������ɫͨ��ȱʧ��R\B����
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

%% ����죨����ͨ��ȱʧ��B��R������
%% GBRG
% G R G R G R
% B G B G B G
% G R G R G R
% B G B G B G
%�����ͨ������G����б�����ݶ�(N_Rg)����б�����ݶ�(P_Rg)
for ver = (add_h+1):2:hei+1
    for hor = (add_w+2):2:wid+2
        N_Rg = abs(bayerPad(ver-1, hor-1)-bayerPad(ver+1, hor+1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)); %ˮƽ�ݶ�
        P_Rg = abs(bayerPad(ver-1, hor+1)-bayerPad(ver+1, hor-1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1)); %��ֱ�ݶ�
        
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

%������ͨ������R����б�����ݶ�(N_Bg)����б�����ݶ�(P_Bg)
for ver = (add_h+2):2:hei+2
    for hor = (add_w+1):2:wid+1
        N_Bg = abs(bayerPad(ver-1, hor-1)-bayerPad(ver+1, hor+1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor-1)-Out_G(ver+1, hor+1)); %ˮƽ�ݶ�
        P_Bg = abs(bayerPad(ver-1, hor+1)-bayerPad(ver+1, hor-1)) + abs(2*Out_G(ver, hor)-Out_G(ver-1, hor+1)-Out_G(ver+1, hor-1)); %��ֱ�ݶ�
        
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

figure;imshow(uint8(Out_R));title('r��ֵ');imwrite(uint8(Out_R),'Out_R.png');
figure;imshow(uint8(Out_G));title('g��ֵ');imwrite(uint8(Out_G),'Out_G.png');
figure;imshow(uint8(Out_B));title('B��ֵ');imwrite(uint8(Out_B),'Out_B.png');

Output(:,:,1) = Out_R(add_h+1:hei+2,add_w+1:wid+2);
Output(:,:,2) = Out_G(add_h+1:hei+2,add_w+1:wid+2);
Output(:,:,3) = Out_B(add_h+1:hei+2,add_w+1:wid+2);
