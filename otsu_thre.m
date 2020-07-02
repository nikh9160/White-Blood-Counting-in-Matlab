function otsu_thre(x,y)

%TAKING INPUT ARGUMENTS
input_image=x;
ori_image=y;


gray_image=x;
[len,bre]=size(gray_image);
z=zeros(1,256);
for i=1:len
    for j=1:bre
        h=gray_image(i,j);
        z(h+1)=z(h+1)+1;
    end
end

min=1000000000;
thre=0;
for i=1:256
    fore=0;
    back=0;
    for j=1:i
        back=back+z(j);
    end
    for j=i+1:256
        fore=fore+z(j);
    end
    back_wei=back/(len*bre);
    fore_wei=fore/(len*bre);
    sum=0;
    for j=1:i
        sum=sum+((j-1)*z(j));
    end
    back_mean=sum/back;
    sum=0;
    for j=i+1:256
        sum=sum+((j-1)*z(j));
    end
    fore_mean=sum/fore;
    sum=0;
    for j=1:i
        sum=sum+((j-1)-back_mean)*((j-1)-back_mean)*z(j);
    end
    back_var=sum/back;
    sum=0;
    for j=i+1:256
        sum=sum+(((j-1)-fore_mean)^2)*z(j);
    end
    fore_var=sum/fore;
    sum=(back_wei*back_var)+(fore_wei*fore_var);
    if sum<min
        min=sum;
        thre=i;
    end
end
output=zeros(len,bre);
for i=1:len
    for j=1:bre
        if input_image(i,j)<thre
            output(i,j)=0;
        else
            output(i,j)=255;
        end
    end
end
figure()
imshow(output)


%CIRCULAR HOUGH TRANSFORM


%[centre, radii, metric]=imfindcircles(output,[5,6])

%centreStrong=centre(1:2,:);
%radiiStrong=radii(1:2);
%metricStrong=metric(1:2);

%viscircles(centreStrong,radiiStrong,'EdgeColor','b');    


rim=15;
rmax=28;

[cen,rad]=imfindcircles(output,[rim,rmax],'ObjectPolarity','bright','Sensitivity',0.935)
figure()
imshow(ori_image)
viscircles(cen,rad,'Color','b')

end