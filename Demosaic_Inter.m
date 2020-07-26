
function Output = Demosaic_Inter (Input)

%% 优化插值
e=35;

raw=Input;

[row ,col]=size(raw);

Output=zeros(row,col,3);

demo_r=zeros(row+4,col+4);
demo_g=zeros(row+4,col+4);
demo_b=zeros(row+4,col+4);

temp_r=zeros(row+4,col+4);
temp_g=zeros(row+4,col+4);
temp_b=zeros(row+4,col+4);

temp_r(3:row+2,3:col+2)=raw;
temp_g(3:row+2,3:col+2)=raw;
temp_b(3:row+2,3:col+2)=raw;

for i=3:2:row+2
    for j=3:2:col+2
        %G,上下B，左右R
        demo_g(i,j)=temp_g(i,j);
    end
    for j=4:2:col+2
        %R
        dV=abs(temp_g(i-1,j)-temp_g(i+1,j))+abs((temp_r(i-2,j)+temp_r(i+2,j))/2-temp_r(i,j));
        dH=abs(temp_g(i,j-1)-temp_g(i,j+1))+abs((temp_r(i,j-2)+temp_r(i,j+2))/2-temp_r(i,j));
        if dH > dV
            demo_g(i,j)=(temp_g(i-1,j)+temp_g(i+1,j))/2+(2*temp_r(i,j)-temp_r(i-2,j)-temp_r(i+2,j))/4;
        elseif dH < dV
            demo_g(i,j)=(temp_g(i,j-1)+temp_g(i,j+1))/2+(2*temp_r(i,j)-temp_r(i,j-2)-temp_r(i,j+2))/4;
        else
            mres1=(temp_g(i-1,j)+temp_g(i+1,j)+temp_g(i,j-1)+temp_g(i,j+1))/4;
            mres2=(4*temp_r(i,j)-temp_r(i-2,j)-temp_r(i+2,j)-temp_r(i,j-2)-temp_r(i,j+2))/8;
            demo_g(i,j)=mres1+mres2;
        end
    end
end

for i=4:2:row+2
   for j=3:2:col+2
       %B
       dV=abs(temp_g(i-1,j)-temp_g(i+1,j))+abs((temp_b(i-2,j)+temp_b(i+2,j))/2-temp_b(i,j));
       dH=abs(temp_g(i,j-1)-temp_g(i,j+1))+abs((temp_b(i,j-2)+temp_b(i,j+2))/2-temp_b(i,j));
       if dH > dV
           demo_g(i,j)=(temp_g(i-1,j)+temp_g(i+1,j))/2+(2*temp_b(i,j)-temp_b(i-2,j)-temp_b(i+2,j))/4;
       elseif dH < dV
           demo_g(i,j)=(temp_g(i,j-1)+temp_g(i,j+1))/2+(2*temp_b(i,j)-temp_b(i,j-2)-temp_b(i,j+2))/4;
       else
           tres1=(temp_g(i-1,j)+temp_g(i+1,j)+temp_g(i,j-1)+temp_g(i,j+1))/4;
           tres2=(4*temp_b(i,j)-temp_b(i-2,j)-temp_b(i+2,j)-temp_b(i,j-2)-temp_b(i,j+2))/8;
           demo_g(i,j)=tres1+tres2;
       end
   end
   for j =4:2:col+2
       %G，上下R，左右B
       demo_g(i,j)=temp_g(i,j);
   end
end
%以上，做好了全部的G插值
%下面，我们坐R/B的插值
for i=3:2:row+2
    for j=3:2:col+2
        %G,上下B，左右R
        t1=abs(demo_g(i,j)-demo_g(i,j-1))+e;
        t2=abs(demo_g(i,j)-demo_g(i,j+1))+e;
        T1=t2/(t1+t2);
        T2=t1/(t1+t2);
        demo_r(i,j)=demo_g(i,j)+T1*(temp_r(i,j-1)-demo_g(i,j-1))+T2*(temp_r(i,j+1)-demo_g(i,j+1));
      
        t1=abs(demo_g(i,j)-demo_g(i-1,j))+e;
        t2=abs(demo_g(i,j)-demo_g(i+1,j))+e;
        T1=t2/(t1+t2);
        T2=t1/(t1+t2);
        demo_b(i,j)=demo_g(i,j)+T1*(temp_b(i-1,j)-demo_g(i-1,j))+T2*(temp_b(i+1,j)-demo_g(i+1,j));
    end
    for j=4:2:col+2
        %R
        demo_r(i,j)=temp_r(i,j);
        
       BGzs=temp_b(i-1,j-1)-demo_g(i-1,j-1);
       BGys=temp_b(i-1,j+1)-demo_g(i-1,j+1);
       BGzx=temp_b(i+1,j-1)-demo_g(i+1,j-1);
       BGyx=temp_b(i+1,j+1)-demo_g(i+1,j+1);
       BGA=(BGzs+BGzx+BGys+BGyx)/4;
       BG=BGA;
       V=[BGzs,BGys,BGzx,BGyx];
       if (V(1)<BGA &&V(2)<BGA&&V(3)>BGA&&V(4)>BGA) ||(V(1)>BGA &&V(2)<BGA&&V(3)<BGA&&V(4)>BGA)||(V(1)>BGA &&V(2)>BGA&&V(3)<BGA&&V(4)<BGA)||(V(1)<BGA &&V(2)>BGA&&V(3)>BGA&&V(4)<BGA)
           dN=abs(temp_b(i-1,j-1)-temp_b(i+1,j+1))+abs(2*demo_g(i,j)-demo_g(i-1,j-1)-demo_g(i+1,j+1));
           dP=abs(temp_b(i+1,j-1)-temp_b(i-1,j+1))+abs(2*demo_g(i,j)-demo_g(i+1,j-1)-demo_g(i-1,j+1));
           if dN<dP
               BG=(temp_b(i-1,j-1)+temp_b(i+1,j+1)-demo_g(i-1,j-1)-demo_g(i+1,j+1))/2;
           elseif dN>dP
               BG=(temp_b(i+1,j-1)+temp_b(i-1,j+1)-demo_g(i+1,j-1)-demo_g(i-1,j+1))/2;
           else
               BG=(temp_b(i-1,j-1)+temp_b(i+1,j+1)-demo_g(i-1,j-1)-demo_g(i+1,j+1)+temp_b(i+1,j-1)+temp_b(i-1,j+1)-demo_g(i+1,j-1)-demo_g(i-1,j+1))/4;
           end
       else
           BG=median(V);
       end
       demo_b(i,j)=demo_g(i,j)+BG;
    end
end

for i=4:2:row+2
   for j=3:2:col+2
       %B
       demo_b(i,j)=temp_b(i,j);
       
       RGzs=temp_r(i-1,j-1)-demo_g(i-1,j-1);
       RGys=temp_r(i-1,j+1)-demo_g(i-1,j+1);
       RGzx=temp_r(i+1,j-1)-demo_g(i+1,j-1);
       RGyx=temp_r(i+1,j+1)-demo_g(i+1,j+1);
       RGA=(RGzs+RGzx+RGys+RGyx)/4;
       RG=RGA;
       V=[RGzs,RGys,RGzx,RGyx];
       if (V(1)<RGA &&V(2)<RGA&&V(3)>RGA&&V(4)>RGA) ||(V(1)>RGA &&V(2)<RGA&&V(3)<RGA&&V(4)>RGA)||(V(1)>RGA &&V(2)>RGA&&V(3)<RGA&&V(4)<RGA)||(V(1)<RGA &&V(2)>RGA&&V(3)>RGA&&V(4)<RGA)
           dN=abs(temp_r(i-1,j-1)-temp_r(i+1,j+1))+abs(2*demo_g(i,j)-demo_g(i-1,j-1)-demo_g(i+1,j+1));
           dP=abs(temp_r(i+1,j-1)-temp_r(i-1,j+1))+abs(2*demo_g(i,j)-demo_g(i+1,j-1)-demo_g(i-1,j+1));
           if dN<dP
               RG=(temp_r(i-1,j-1)+temp_r(i+1,j+1)-demo_g(i-1,j-1)-demo_g(i+1,j+1))/2;
           elseif dN>dP
               RG=(temp_r(i+1,j-1)+temp_r(i-1,j+1)-demo_g(i+1,j-1)-demo_g(i-1,j+1))/2;
           else
               RG=(temp_r(i-1,j-1)+temp_r(i+1,j+1)-demo_g(i-1,j-1)-demo_g(i+1,j+1)+temp_r(i+1,j-1)+temp_r(i-1,j+1)-demo_g(i+1,j-1)-demo_g(i-1,j+1))/4;
           end
       else
           RG=median(V);
       end
       demo_r(i,j)=demo_g(i,j)+RG;
       
   end
   for j =4:2:col+2
       %G，上下R，左右B
        t1=abs(demo_g(i,j)-demo_g(i,j-1))+e;
        t2=abs(demo_g(i,j)-demo_g(i,j+1))+e;
        T1=t2/(t1+t2);
        T2=t1/(t1+t2);
        demo_b(i,j)=demo_g(i,j)+T1*(temp_b(i,j-1)-demo_g(i,j-1))+T2*(temp_b(i,j+1)-demo_g(i,j+1));
      
        t1=abs(demo_g(i,j)-demo_g(i-1,j))+e;
        t2=abs(demo_g(i,j)-demo_g(i+1,j))+e;
        T1=t2/(t1+t2);
        T2=t1/(t1+t2);
        demo_r(i,j)=demo_g(i,j)+T1*(temp_r(i-1,j)-demo_g(i-1,j))+T2*(temp_r(i+1,j)-demo_g(i+1,j));
   end
end

Output(:,:,1)=demo_r(3:row+2,3:col+2);
Output(:,:,2)=demo_g(3:row+2,3:col+2);
Output(:,:,3)=demo_b(3:row+2,3:col+2);
 


Output=uint8(Output);
end