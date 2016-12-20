%This part of the code was done using Chris McCormick's code as reference
% reference : http://mccormickml.com/2013/05/09/hog-descriptor-in-matlab/
% date:26th November 2016

function [detectedWindows] = findDetectedWindows(hog, originalImg)

	% Save all of the windows where presence of human was found
	detectedWindows = [];
    winHorSize = 64;
    
	%multipleScales will have all the multiple scales with 5% of reduction
	multipleScales = zeros(winHorSize);
	scale = 1.0;
	for i = 1 : winHorSize
		multipleScales(i) = scale;
		scale = scale / 1.05;
    end
 
	
	% Initialize the noOfWindows array. Used for stopping condition
	noOfWindows = zeros(1, length(multipleScales));

	% For each of the image scales...
	for i = 1 : length(multipleScales)
        
		% Get the next scale value.
		scale = multipleScales(i); 
        
        %dimensions after scaling
        if (scale == 1)
			img = originalImg;
		else
			img = imresize(originalImg, scale);
        end
        
        [imgHeight, imgWidth] = size(img);

    
        % Compute the number of cells horizontally and vertically for the image.
        numHorizCells = floor((imgWidth - 2) / hog.cellSize);
        numVertCells = floor((imgHeight - 2) / hog.cellSize);
        
        % Break the loop when the image is too small to fit a window.
         %  when the edge of the detector window hits the edge of
        % the image.
        if ((numHorizCells < hog.numHorizCells) || ...
            (numVertCells < hog.numVertCells))
            break;
        end
        
   
        numHorizWindows = numHorizCells - hog.numHorizCells + 1;
        numVertWindows = numVertCells - hog.numVertCells + 1;
        
        % Compute the total number of windows for the given scale
        noOfWindows(1, i) = numHorizWindows * numVertWindows;     

        % Stop the search if this scale is too small to fit even a single 
        % window.
        if (noOfWindows(i) == 0)
           fprintf('  Image scale %.2f is small, stopping search.\n', scale);
           break;
        end
        
		fprintf('  Image Scale %.2f, %d windows ', scale, noOfWindows(i));
	
    
         % Compute the new image dimensions.
        newWidth = (numHorizCells * hog.cellSize) + 2;
        newHeight = (numVertCells * hog.cellSize) + 2;

        % Divide the left-over pixels in half to center the crop region.
        xAdjust = round((imgWidth - newWidth) / 2) + 1;
        yAdjust = round((imgHeight - newHeight) / 2) + 1;

        % Crop the image.
        img = img(yAdjust : (yAdjust + newHeight - 1), xAdjust : (xAdjust + newWidth - 1));

		rowCell = 1;
        i=1;
		
		
        while((i+129) <= size(img, 1))
            
            colCell = 1;
            j=1;
					
            while ((j+65) <= size(img, 2))
			
				
                im_h = img(i:i+129,j:j+65 );
				% Compute the HOG descriptor.
				
				H = extractHOGFeatures(im_h);			
				
				p = predict(hog.mdl,H);
                
				% If we recognize the histogram as a person...
				if (p > hog.threshold)
			
					xstart = xAdjust + ((colCell - 1) * hog.cellSize);
					ystart = yAdjust + ((rowCell - 1) * hog.cellSize);


					% Compute the detection window coorindate and size 
                    % relative to the original image scale.
					topLeftX = round(xstart / scale);
					topLeftY = round(ystart / scale);
					origWidth = round(hog.winSize(2) / scale);
					origHeight = round(hog.winSize(1) / scale);
					
					% Add the rectangle to the results.
					detectedWindows = [detectedWindows; 
                                   topLeftX, topLeftY, origWidth, origHeight, p];
				end               

				
               colCell = colCell + 1;
                j=j+8;
			end
			rowCell = rowCell + 1;
            i=i+8;
        end
        
        fprintf('%d matches total \n', size(detectedWindows, 1));
    
	end

% End function
end