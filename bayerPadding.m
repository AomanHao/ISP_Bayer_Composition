function bayerPad = bayerPadding(bayer, hei, wid)

%% bayerͼ����չ����չ0Ԫ��
bayerPad = zeros(hei+4,wid+4);
bayerPad(3:hei+2,3:wid+2) = bayer;

% %% bayerͼ����չ����չһȦԪ��
% 
% bayerPad = zeros(hei+4,wid+4);
% bayerPad(3:hei+2,3:wid+2) = bayer;
% %������չ
% bayerPad(1,:) = bayerPad(3,:);bayerPad(2,:) = bayerPad(3,:);
% bayerPad(hei+3,:) = bayerPad(hei+2,:);bayerPad(hei+4,:) = bayerPad(hei+2,:);
% 
% %������չ
% bayerPad(:,1) = bayerPad(:,3);bayerPad(:,2) = bayerPad(:,3);
% bayerPad(:,wid+3) = bayerPad(:,wid+2);bayerPad(:,wid+4) = bayerPad(:,wid+2);