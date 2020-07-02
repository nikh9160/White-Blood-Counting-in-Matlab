import otsu_thre.*

%READING INPUT
input=imread('Source.jpg');
figure()
imshow(input)  %1

%CONVERTING INPUT INTO LAB
lab_input=rgb2lab(input);
figure()
imshow(lab_input) %2

%DIVIDING LAB INTO INDIVIDUAL L A AND B
input_l=lab_input(:,:,1);
input_a=lab_input(:,:,2);
input_b=lab_input(:,:,3);

%FINDING MEAN AND STANDARD DEVIATION FOR INDIVIDUAL COLOR SPACES
mean_input_l=mean2(input_l);
mean_input_a=mean2(input_a);
mean_input_b=mean2(input_b);

sd_input_l=std2(input_l);
sd_input_a=std2(input_a);
sd_input_b=std2(input_b);


%READING TEMPLATE IMAGE
tem=imread('Temp1.jpg');
figure()
imshow(tem) %3

%CONVERTING TEMPLATE IMAGE INTO LAB
lab_tem=rgb2lab(tem);
figure()
imshow(lab_tem) %4

%DIVIDING TEMPLATE IMAGE LAB INTO INDIVIDUA L A AND B
tem_l=lab_tem(:,:,1);
tem_a=lab_tem(:,:,2);
tem_b=lab_tem(:,:,3);


%FINDING MEAN AND STANDARD DEVIATION FOR INDIVIDUAL COLOR SPACES OF TEMPLATE IMAGE 
mean_tem_l=mean2(tem_l);
mean_tem_a=mean2(tem_a);
mean_tem_b=mean2(tem_b);

sd_tem_l=std2(tem_l);
sd_tem_a=std2(tem_a);
sd_tem_b=std2(tem_b);


%APPLYING COLOR SPACE CORRECTION FORMULA
output_l=(((input_l-mean_input_l)/sd_input_l)*sd_tem_l)+mean_tem_l;
output_a=(((input_a-mean_input_a)/sd_input_a)*sd_tem_a)+mean_tem_a;
output_b=(((input_b-mean_input_b)/sd_input_b)*sd_tem_b)+mean_tem_b;

%COMBINING INDIVIDUAL L A AND B COLOR SPACES INTO LAB IMAGE
output=cat(3,output_l,output_a,output_b);
figure()
imshow(output) %5

%CONVERTING LAB OUTPUT INTO RGB
output_rgb=lab2rgb(output);

figure()
imshow(output_rgb)%6
output_rgb1=uint8(output_rgb);

%DIVIDING RGB OUTPUT IMAGE INTO R G AND B INDIVIDUAL COLOR SPACES
r_cha=output_rgb1(:,:,1);
g_cha=output_rgb1(:,:,2);
b_cha=output_rgb1(:,:,3);

all_black=zeros(size(output_rgb1,1),size(output_rgb1,2),'uint8');

red=cat(3,r_cha,all_black,all_black);
green=cat(3,all_black,g_cha,all_black);
blue=cat(3,all_black,all_black,b_cha);



%CONVERTING THE COLOR SPACE CORRECTED INPUT IMAGE INTO HSV
hsv_image=rgb2hsv(output_rgb);

h=hsv_image(:,:,1);
s=hsv_image(:,:,2);
v=hsv_image(:,:,3);

%NORMAISING S COLOR SPACE INTO GRAYSCALE
[len bre]=size(s);

out=zeros(len,bre);
for i=1:len
    for j=1:bre
        if s(i,j)>1
            s(i,j)=1;
        end
        s(i,j)=floor(s(i,j)*255);
        out(i,j)=s(i,j)-green(i,j);
    end
end

otsu_thre(out,input)
otsu_thre(s,input)