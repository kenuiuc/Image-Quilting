im1 = imread('simpleSam.jpg');
im2 = imread('randomSam.jpg');
ssd = ssdImage(im1, im2);
imwrite(ssd, 'ssd.jpg');

disp('hahha');
