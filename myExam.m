texture = imread('sam.png');
s = size(texture);

%{
random = quilt_random(texture, 400, 25);
disp('finish random');
imwrite(random, 'random2.jpg');

simple = quilt_simple(texture, 400, 51 , 25, 0.1);
disp('finish simple');
imwrite(simple, 'simple2.jpg');
%}

quilt = quilt(texture, 400, 51 , 25, 0.1);
disp('Finish quilt');
imwrite(quilt, 'quilt2.jpg');

disp('Done!!!!!');


