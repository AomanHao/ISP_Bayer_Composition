function Output = Demosaic_Twointer(img,hei, wid)

%% 
%Ë«ÏßÐÔ²åÖµ demosaic
bayer = uint8(zeros(hei,wid));
%% BGGR
% B G B G B G
% G R G R G R
% B G B G B G
%% bayer
for ver = 1:hei
    for hor = 1:wid
        if((1 == mod(ver,2)) && (1 == mod(hor,2)))
            bayer(ver,hor) = img(ver,hor,3);
        elseif((0 == mod(ver,2)) && (0 == mod(hor,2)))
            bayer(ver,hor) = img(ver,hor,1);
        else
            bayer(ver,hor) = img(ver,hor,2);
        end
    end
end

figure,imshow(bayer);

bayerPadding = zeros(hei+2,wid+2);
bayerPadding(2:hei+1,2:wid+1) = bayer;
bayerPadding(1,:) = bayerPadding(3,:);
bayerPadding(hei+2,:) = bayerPadding(hei,:);
bayerPadding(:,1) = bayerPadding(:,3);
bayerPadding(:,wid+2) = bayerPadding(:,wid);

chan = 3;
imDst = zeros(hei+2, wid+2, chan);

for ver = 2:hei+1
    for hor = 2:wid+1
        if(1 == mod(ver-1,2))
            if(1 == mod(hor-1,2))
                imDst(ver,hor,3) = bayerPadding(ver,hor);
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
            else
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
                imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
            end
        else
            if(1 == mod(hor-1,2))
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
            else
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            end
        end
    end
end

imDst = uint8(imDst(2:hei+1,2:wid+1,:));
figure,imshow(imDst);
Output = imDst;

%% RGGB
% R G R G R G
% G B G B G B
% R G R G R G
% for ver = 1:hei;
%     for hor = 1:wid
%         if((1 == mod(ver,2)) && (1 == mod(hor,2)))
%             bayer(ver,hor) = img(ver,hor,1);
%         elseif((0 == mod(ver,2)) && (0 == mod(hor,2)))
%             bayer(ver,hor) = img(ver,hor,3);
%         else
%             bayer(ver,hor) = img(ver,hor,2);
%         end
%     end
% end
% 
% figure,imshow(bayer);
% 
% bayerPadding = zeros(hei+2,wid+2);
% bayerPadding(2:hei+1,2:wid+1) = bayer;
% bayerPadding(1,:) = bayerPadding(3,:);
% bayerPadding(hei+2,:) = bayerPadding(hei,:);
% bayerPadding(:,1) = bayerPadding(:,3);
% bayerPadding(:,wid+2) = bayerPadding(:,wid);
% imDst = zeros(hei+2, wid+2, chan);
% 
% for ver = 2:hei+1
%     for hor = 2:wid+1
%         if(1 == mod(ver-1,2))
%             if(1 == mod(hor-1,2))
%                 imDst(ver,hor,1) = bayerPadding(ver,hor);
%                 imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
%                 imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
%             else
%                 imDst(ver,hor,2) = bayerPadding(ver,hor);
%                 imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
%                 imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
%             end
%         else
%             if(1 == mod(hor-1,2))
%                 imDst(ver,hor,2) = bayerPadding(ver,hor);
%                 imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
%                 imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
%             else
%                 imDst(ver,hor,3) = bayerPadding(ver,hor);
%                 imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
%                 imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
%             end
%         end
%     end
% end
% 
% imDst = uint8(imDst(2:hei+1,2:wid+1,:));
% figure,imshow(imDst);

%% GBRG
% G B G B G B
% R G R G R G
% G B G B G B
% for ver = 1:hei;
%     for hor = 1:wid
%         if((1 == mod(ver,2)) && (0 == mod(hor,2)))
%             bayer(ver,hor) = img(ver,hor,3);
%         elseif((0 == mod(ver,2)) && (1 == mod(hor,2)))
%             bayer(ver,hor) = img(ver,hor,1);
%         else
%             bayer(ver,hor) = img(ver,hor,2);
%         end
%     end
% end
% 
% figure,imshow(bayer);
% 
% bayerPadding = zeros(hei+2,wid+2);
% bayerPadding(2:hei+1,2:wid+1) = bayer;
% bayerPadding(1,:) = bayerPadding(3,:);
% bayerPadding(hei+2,:) = bayerPadding(hei,:);
% bayerPadding(:,1) = bayerPadding(:,3);
% bayerPadding(:,wid+2) = bayerPadding(:,wid);
% imDst = zeros(hei+2, wid+2, chan);
% 
% for ver = 2:hei+1
%     for hor = 2:wid+1
%         if(1 == mod(ver-1,2))
%             if(1 == mod(hor-1,2))
%                 imDst(ver,hor,2) = bayerPadding(ver,hor);
%                 imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
%                 imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
%             else
%                 imDst(ver,hor,3) = bayerPadding(ver,hor);
%                 imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
%                 imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
%             end
%         else
%             if(1 == mod(hor-1,2))
%                 imDst(ver,hor,1) = bayerPadding(ver,hor);
%                 imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
%                 imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
%             else
%                 imDst(ver,hor,2) = bayerPadding(ver,hor);
%                 imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
%                 imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
%             end
%         end
%     end
% end
% 
% imDst = uint8(imDst(2:hei+1,2:wid+1,:));
% figure,imshow(imDst);