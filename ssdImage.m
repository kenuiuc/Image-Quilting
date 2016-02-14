function[output] = ssdImage(im1, im2)
im1 = im2double(im1);
im2 = im2double(im2);

%{
figure(11);
imshow (im1);
figure(12);
imshow (im2);
imwrite(im1, 'im1Lap.jpg');
imwrite(im2, 'im2Lap.jpg');
%}

output = zeros(size(im1));
im1S = im1 .^2;
im2S = im2 .^2;
product = (im1 .* im2) * (-2);
ssd = im1S + im2S + product;
output = ssd(:,:,1) + ssd(:,:,2) + ssd (:,:,3);

%%figure(100),hold on plot, imagesc(output), axis image;
%%saveas(figure(100),'ssdExample.jpg');
%%output = (output/3) .^ 0.5;
end
        
    