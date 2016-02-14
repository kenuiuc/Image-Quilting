function [imOut] = quilt(sample, outSize, patchSize, overlap, tol)
    sample = im2double(sample);
    
    figure(11);
    imshow(sample);
    inSize = size(sample);
    
    imOut = zeros(outSize,outSize, 3);
    imOut = im2double(imOut);
    %%imOut = zeros(outSize, outSize, 3);
    maxX = inSize(1)-patchSize;
    maxY = inSize(2)-patchSize;
    ssX = int8 (random('unif',1, maxX));
    ssY = int8 (random('unif',1, maxY));
    sX = ssX;
    sY = ssY;
    
    endX = ssX+ patchSize-1;
    endY = ssY+ patchSize-1;
    lenX = endX - ssX +1;
    lenY = endY -ssY + 1;
    imOut(1: patchSize, 1:patchSize, 1:3) = sample (ssY: endY, ssX: endX, 1:3);
    
   
    
    %%I need three mask
    topMask = zeros(patchSize, patchSize, 3);
    topMask(1:patchSize, 1:overlap, :) = 1;
    leftMask = zeros(patchSize, patchSize, 3);
    leftMask(1:overlap, 1:patchSize, :) = 1;
    otherMask = zeros(patchSize, patchSize, 3);
    otherMask(1:overlap, 1:patchSize, :) = 1;
    otherMask (1:patchSize, 1:overlap, :) = 1;
    
   
    %%create imOut and put the first patch
    
    
    
    for y=1: patchSize - overlap + 1: outSize - patchSize + 1,
        for x=1: patchSize - overlap + 1: outSize - patchSize +  1,
            mask = zeros (patchSize, patchSize, 3);
            if (y == 1 && x > 1)
                mask = topMask;
                %%use topMask
            end
            if (y > 1 && x ==1)
                mask = leftMask;
            end
            if (y > 1 && x > 1)
                mask = otherMask;
            end
            
            if (x ~= 1 || y ~=1)
                patchToFill = imOut(y: y+patchSize -1, x: x+ patchSize-1, :);
                fil = mask .* patchToFill;
                %%ssSample
                ssSample = imfilter (sample .^2, mask);
                %%ssFil
                ssFil = sum(fil(:).^2);
                ssFilSamSize = zeros(size(sample));
                ssFilSamSize(:) = ssFil;
                %%product
                product = imfilter (sample, fil) * (-2);
                imagesc(product);
                %%sam them together
                ssdIm = ssSample + ssFilSamSize + product; 
                ssdIm2D = ssdIm(:,:,1) + ssdIm(:,:,2) + ssdIm (:,:,3);
                halfPatch = int8(patchSize/2);
                endpos = inSize(1) - halfPatch;
                cropssdIm2D = ssdIm2D(halfPatch+1:endpos , halfPatch+1:endpos);
                ssdFinal = ssdIm2D;
                ssdFinal(:) = flintmax;
                ssdFinal(halfPatch+1:endpos , halfPatch+1:endpos) = cropssdIm2D;
                minc = min(min(ssdFinal));
                %%cost = ssdIm2D(y,x);
                [minYs, minXs] = find(ssdFinal <= minc*(1+tol));
                len = length(minYs);
                ranIndex = int8(random('unif',1, len));
                cenY = minYs(ranIndex);
                cenX = minXs(ranIndex);
                
                %show ssd
                ssd = ssdFinal (cenY, cenX);
                
                
                
                %copy pixel
                startY = cenY - halfPatch;
                startX = cenX - halfPatch;
                %%disp (startY);
                %%disp (startX);
                chosenPatch = sample(startY: startY + patchSize -1, startX: startX + patchSize -1,:);
                outPatch = imOut(y: y + patchSize -1, x: x + patchSize -1,:);
                
                xChosenLap = chosenPatch( : , 1: overlap, :);
                yChosenLap = chosenPatch(1: overlap, :, :);
                xOutLap = outPatch( : , 1: overlap, :);
                yOutLap = outPatch(1: overlap, :, :);
                
                %%Top mask
                if (mask == topMask)
                    cost = ssdImage(xChosenLap, xOutLap);
                    chosenMask = transpose(cut(transpose(cost)));
                    %%change here
                    chosenMask3D = zeros(size(xOutLap));
                    chosenMask3D (:,:,1) = chosenMask;
                    chosenMask3D (:,:,2) = chosenMask;
                    chosenMask3D (:,:,3) = chosenMask;
                    
                    samplePatchMask = ones(size(chosenPatch));
                    maskSize = size(chosenMask3D);
                    samplePatchMask(1:maskSize(1), 1:maskSize(2), :) = chosenMask3D;
                    outPatchMask = ~ samplePatchMask;
                    
                    maskedOutPatch = outPatchMask .* outPatch;
                    maskedChosenPatch = samplePatchMask .* chosenPatch;
                    plusPatch = maskedOutPatch + maskedChosenPatch;
                    
                    imOut(y: y + patchSize -1, x: x + patchSize -1,:) = plusPatch;
                end
                
                %%left mask
                if (mask == leftMask)
                    cost = ssdImage(yChosenLap, yOutLap);
                    chosenMask = cut(cost);
                    %%change here
                    chosenMask3D = zeros(size(yOutLap));
                    chosenMask3D (:,:,1) = chosenMask;
                    chosenMask3D (:,:,2) = chosenMask;
                    chosenMask3D (:,:,3) = chosenMask;
                    
                    samplePatchMask = ones(size(chosenPatch));
                    maskSize = size(chosenMask3D);
                    samplePatchMask(1:maskSize(1), 1:maskSize(2), :) = chosenMask3D;
                    outPatchMask = ~ samplePatchMask;
                    
                    maskedOutPatch = outPatchMask .* outPatch;
                    maskedChosenPatch = samplePatchMask .* chosenPatch;
                    plusPatch = maskedOutPatch + maskedChosenPatch;
                    
                    imOut(y: y + patchSize -1, x: x + patchSize -1,:) = plusPatch;
                end
                
                %%other mask
                if (mask == otherMask)
                    yCost = ssdImage(yChosenLap, yOutLap);
                    xCost = ssdImage(xChosenLap, xOutLap);
                    yChosenMask = cut(yCost);
                    xChosenMask = transpose(cut(transpose(xCost)));
                    
                    %%chosenMask = xChosenMask & yChosenMask;
                    xSampleMask2D = ones(patchSize, patchSize);
                    ySampleMask2D = ones(patchSize, patchSize);
                    
                    %%sizeYMask = size(yChosenMask);
                    %%sizeXMask = size(xChosenMask);
                    
                    xSampleMask2D (1:patchSize, 1: overlap) = xChosenMask;
                    ySampleMask2D (1:overlap, 1: patchSize) = yChosenMask;
                    
                    sampleMask2D = xSampleMask2D .* ySampleMask2D;
                    
                    sampleMask = zeros(patchSize, patchSize, 3);
                    sampleMask (:,:,1) = sampleMask2D;
                    sampleMask (:,:,2) = sampleMask2D;
                    sampleMask (:,:,3) = sampleMask2D;
                    
                    samplePatchMask = sampleMask;
                    
                    
                    
                    
                    
                    outPatchMask = ~ samplePatchMask;
                    
                    maskedOutPatch = outPatchMask .* outPatch;
                    maskedChosenPatch = samplePatchMask .* chosenPatch;
                    plusPatch = maskedOutPatch + maskedChosenPatch;
                    
                    imOut(y: y + patchSize -1, x: x + patchSize -1,:) = plusPatch;
                end
                
                
                    %{
                    figure(111);
                    imshow (maskedOutPatch);
                    
                    figure(112);
                    imshow (maskedChosenPatch);
                    
                    figure(113);
                    imshow (plusPatch);
                    %}
                    
                    %%imOut(y: y + patchSize -1, x: x + patchSize -1,:) = plusPatch; 
                    
                    figure(114);
                    imshow (imOut);
                    
                    
                    
                
                
                
                
               
            end
            
        end
    
    end

                
    end
        
                     
                        
                        
                        
                
            