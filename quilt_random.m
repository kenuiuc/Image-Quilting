function [imOut] = quilt_random(sample, outSize, patchSize)
    sample = im2double(sample);
    inSize = size(sample);
    %%create imOut:
        imOut = zeros(outSize, outSize, 3);
    %%random sample start point:
        maxX = inSize(1)-patchSize;
        maxY = inSize(2)-patchSize;
        for x=1: patchSize: outSize - patchSize+1,
            for y=1: patchSize: outSize - patchSize+1,
                sX = int8 (random('unif',1, maxX));
                sY = int8 (random('unif',1, maxY));
                imOut(x: x+ patchSize-1, y: y+ patchSize-1, :) = sample (sX: sX+ patchSize-1, sY: sY+ patchSize-1, :);
                
                figure(1);
                imshow (imOut);
            end
        end
   