function bayerPad = bayerPadding(bayer, hei, wid)

%% bayer图像扩展，扩展0元素
bayerPad = zeros(hei+4,wid+4);
bayerPad(3:hei+2,3:wid+2) = bayer;

% %% bayer图像扩展，扩展一圈元素
% 
% bayerPad = zeros(hei+4,wid+4);
% bayerPad(3:hei+2,3:wid+2) = bayer;
% %左右扩展
% bayerPad(1,:) = bayerPad(3,:);bayerPad(2,:) = bayerPad(3,:);
% bayerPad(hei+3,:) = bayerPad(hei+2,:);bayerPad(hei+4,:) = bayerPad(hei+2,:);
% 
% %上下扩展
% bayerPad(:,1) = bayerPad(:,3);bayerPad(:,2) = bayerPad(:,3);
% bayerPad(:,wid+3) = bayerPad(:,wid+2);bayerPad(:,wid+4) = bayerPad(:,wid+2);