function [imOut] = texture_transfer(target, sample, outSize, patchSize, overlap, tol, alpha)
    
    %%Read input and init output
    sample = im2double(sample);
    target = im2double(target);
    inSize = size(sample);
    imOut = zeros(outSize,outSize, 3);
    imOut = im2double(imOut);
    
    %%Random x, y value for the first patch
    maxX = inSize(1)-patchSize;
    maxY = inSize(2)-patchSize;
    ssX = int8(1 + rand * (maxX -1));
    ssY = int8(1 + rand * (maxY -1));
    endX = ssX+ patchSize-1;
    endY = ssY+ patchSize-1;
    lenX = endX - ssX +1;
    lenY = endY -ssY + 1;
    
    %%WANG: random number fails ?????
    %%For input image larger than 100 * 100, the random number fails
    %%The lenX and lenY are for degguging purpose. They are supposed to be
    %%always patchSize, but when I have 200 * 200 image input, they are
    %%not!!!!
    
    %%Put the first random patch on the output
    imOut(1: patchSize, 1:patchSize, :) = sample (ssX: endX, ssY:endY, :);
   
    
    %%I need three mask for Top, Left and Other cases of overlapping
    topMask = zeros(patchSize, patchSize, 3);
    topMask(1:patchSize, 1:overlap, :) = 1;
    leftMask = zeros(patchSize, patchSize, 3);
    leftMask(1:overlap, 1:patchSize, :) = 1;
    otherMask = zeros(patchSize, patchSize, 3);
    otherMask(1:overlap, 1:patchSize, :) = 1;
    otherMask (1:patchSize, 1:overlap, :) = 1;
    
   
    %%create imOut and put the first patch
    
    
    
    for y=1: (patchSize - overlap): (outSize - patchSize + 1),
        for x=1: (patchSize - overlap): (outSize - patchSize +  1),
            mask = zeros (patchSize, patchSize, 3);
            oneMask = ones (patchSize, patchSize, 3);
            
            %%Check which mask I should use
            if (y == 1 && x > 1)
                mask = topMask;
            end
            if (y > 1 && x ==1)
                mask = leftMask;
            end
            if (y > 1 && x > 1)
                mask = otherMask;
            end
            
            %%Except for the firt patch postion, Generate SSD image for
            %%every patch to be filled in the output
            if (x ~= 1 || y ~=1)
                patchToFill = imOut(y: y+patchSize -1, x: x+ patchSize-1, :);
                fil = mask .* patchToFill;
                
                %% I.SSD between the sample patch and the existing patch on
                %%   the output image:         
                %%(1) Sum of Square of sample
                ssSample = imfilter (sample .^2, mask);
                %%(2) Sum of Square of Fil (masked patch to fill)
                ssFil = sum(fil(:).^2);
                ssFilSamSize = zeros(size(sample));
                ssFilSamSize(:) = ssFil;
                %%(3) Product term in the SSD equation
                product = imfilter (sample, fil) * (-2);
                %%(4) Add them together to get SSD image
                ssdIm = ssSample + ssFilSamSize + product; 
                
                
                %% II.SSD between the sample patch and the patch on the target image:  
                %%(1) SS of target image;
                targetPatch = target(y: (y+patchSize -1), x: (x+ patchSize-1), :);
                ssTargetPatch = sum(targetPatch(:).^2);
                ssTargetPatchSamSize = zeros(size(sample));
                ssTargetPatchSamSize(:) = ssTargetPatch;
                %%(2) SS of sample patch
                ssSampleFull = imfilter (sample .^2, ones(size(targetPatch)));            
                %%(3) productTerm
                TargetProduct = imfilter (sample, targetPatch) * (-2);
                %%(4)Sum
                ssdTarget = ssTargetPatchSamSize + ssSampleFull + TargetProduct;                                              
                ssdIm = alpha * ssdIm + (1-alpha) * ssdTarget;
                %%end ssd from target
                
                %% III. Add SSDs together in alpha portion  
                ssdIm2D = ssdIm(:,:,1) + ssdIm(:,:,2) + ssdIm (:,:,3);
                
                %% IV. Crop the SSD image:
                halfPatch = int8(patchSize/2);
                endpos = inSize(1) - halfPatch;
                cropssdIm2D = ssdIm2D(halfPatch+1:endpos , halfPatch+1:endpos);
                ssdFinal = ssdIm2D;
                ssdFinal(:) = flintmax;
                ssdFinal(halfPatch+1:endpos , halfPatch+1:endpos) = cropssdIm2D;
                
                %% V. Randomly find sample patch center position in SSD image,
                %%    s.t SSD is less than certain tolerance.
                minc = min(min(ssdFinal));
                [minYs, minXs] = find(ssdFinal <= minc*(1+tol));
                len = length(minYs);
                ranIndex = int8(random('unif',1, len));
                cenY = minYs(ranIndex);
                cenX = minXs(ranIndex);
     
                %show ssd for debug
                ssd = ssdFinal (cenY, cenX);
                
                %% VI. I have the sample patch now, then I want to use the cutting edege
                %%     function to cut the patch and put it on the output image:
                startY = cenY - halfPatch;
                startX = cenX - halfPatch;
               
                chosenPatch = sample(startY: (startY + patchSize -1), startX: (startX + patchSize -1),:);
                outPatch = imOut(y: (y + patchSize -1), x: (x + patchSize -1),:);
                
                xChosenLap = chosenPatch( : , 1: overlap, :);                                
                yChosenLap = chosenPatch(1: overlap, :, :);                
                xOutLap = outPatch( : , 1: overlap, :);      
                yOutLap = outPatch(1: overlap, :, :);
                
                %% VI.I. Top mask case:               
                if (mask == topMask)
                    cost = ssdImage(xChosenLap, xOutLap);
                    
                    
                    chosenMask = transpose(cut(transpose(cost)));
             
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
                
                %% VI.II. Left mask case:
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
                
                %% VI.III. Other mask case:
                if (mask == otherMask)
                    yCost = ssdImage(yChosenLap, yOutLap);
                    xCost = ssdImage(xChosenLap, xOutLap);
                    yChosenMask = cut(yCost);
                    xChosenMask = transpose(cut(transpose(xCost)));
                    
                    xSampleMask2D = ones(patchSize, patchSize);
                    ySampleMask2D = ones(patchSize, patchSize);                  
                    
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
                
                %% VII. Show the outPut image growing process                    
                figure(3);
                imshow (imOut);              
            end
        end   
    end               
end           