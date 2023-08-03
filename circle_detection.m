%just type in command window --> circle_detection(radius you want)

%Function definition
function circle_detection(Radius_of_Circle)
    Original_Image=imread('test2.jpg');
    figure;
    imshow(Original_Image);
    hold on;

%converting--> original image--> to grayscale
    Original_Image=rgb2gray(Original_Image);

%generating--> edge image
    Edge_Image=edge(Original_Image,'canny');
    figure;
    title('EDGED IMAGE');

%displaying--> edge image
    imshow(Edge_Image);
    
%theta counter
    THETA_FREQ= 0.01;

%parameterization
    theta=(0:THETA_FREQ:2*pi);
    N_THETA= numel(theta);
    
%image size
    [x,y]=size(Edge_Image);
    x0 =1:x;
    y0 =1:y;
    
%ACCUM(hough transform)
    ACCUM=zeros(x,y);
    r=Radius_of_Circle;

%Performing-->hough transform
for xi= 1:x
    for yj=1:y
        if Edge_Image(xi,yj)==1
            for theta_id=1:N_THETA
                th=theta(theta_id);
                ab=round(xi- r*cos(th));
                bc=round(yj- r*sin(th));
                if (ab>0)&&(bc>0)&&(ab<x)&&(bc<y)
                    ACCUM(ab,bc)= ACCUM(ab,bc)+1;
                end
            end
        end
    end
end

[~,Image]=max(ACCUM(:));

%center of circle
[ab,bc]=ind2sub(size(ACCUM),Image);

%plotting-->detected circles
figure;
subplot(1,2,1);

%on edged image
imagesc(Edge_Image);
colormap('gray');
hold on;
title('EDGED IMAGE');
plot(y0(bc)+r*sin(theta),x0(ab)+r*cos(theta),'g','Linewidth',2);
subplot(1,2,2);

%on grayscale image
imagesc(Original_Image);
colormap('gray');
hold on;
title('GRAYSCALE IMAGE');
plot(y0(bc)+r*sin(theta),x0(ab)+r*cos(theta),'Linewidth',2);
end
