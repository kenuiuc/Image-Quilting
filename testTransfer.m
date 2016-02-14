sample = imread('sketch.png');
target = imread('obama400.jpg');
temp = size(target);
outSize = temp(1);
output = texture_transfer(target, sample, outSize, 10, 5 , 0.1, 0.2);
imwrite(output, 'ObamaTransfer.jpg');

disp('hahhawanlewanle!!!!!');