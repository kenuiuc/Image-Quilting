cost = imread('ssdExample.jpg');
mask = transpose(cut(transpose(cost)));
nonMask = ~mask;
cost1 = mask .* cost;
cost2 = nonMask .* cost;
size = size(cost)
output = zeros(size(1), size(2)+1, 3);
output(:, :, 1) = 225;
output(1:size(1), 1:size(2), :) = cost1;
output(1:size(1)+1, 2:size(2)+1, :) = cost2;
figure(101),imagesc(output), axis image;
saveas(figure(100),'ssdPath.jpg');