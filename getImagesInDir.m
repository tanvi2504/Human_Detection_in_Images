%This part of the code was done using Chris McCormick's code as reference
% reference : http://mccormickml.com/2013/05/09/hog-descriptor-in-matlab/
% date:26th November 2016
%Author: Chris McCormick 

function imageFiles = getImagesInDir(imDirectory)
%get images from the directory

    dirData = dir(imDirectory);

    % Get the indices
    dirIndex = [dirData.isdir];  

    % Get the list of files.
    initList = {dirData(~dirIndex).name};

    imageFiles = {};
    
    indx = 1;
    
    % For each file in the Directory...
    for i = 1 : length(initList)
    
        imageFile = char(initList(i));

        %  filename's extension.
        if (length(imageFile) <= 3)
            continue;
        else
            extension = imageFile((length(imageFile) - 2) : length(imageFile));
        end
        
        % If this is an image file...
        if (strcmp(extension, 'png') == 1) || ...
           (strcmp(extension, 'PNG') == 1) || ...
           (strcmp(extension, 'jpg') == 1) || ...
           (strcmp(extension, 'JPG') == 1) || ...
           (strcmp(extension, 'bmp') == 1) || ...
           (strcmp(extension, 'BMP') == 1) 
           
        
            
			imageFile = strcat(imDirectory, imageFile);
            
            
            % Add the file to the output list.
			imageFiles{indx} = imageFile;
			
            indx = indx + 1;
        end
    end
end