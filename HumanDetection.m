
%   This script applies a pre-trained HOG detector to a sample validation 
%   image, reports the detector accuracy, and displays the image with true 
%   positives drawn.
%This part of the code was done using Chris McCormick's code as reference
% reference : http://mccormickml.com/2013/05/09/hog-descriptor-in-matlab/
% date:26th November 2016

% Load the pre-configured and pre-trained HOG detector.
load('hogModel.mat');

hog.threshold = 0.4;
% The number of bins to use in the histograms.
hog.numBins = 9;

% The number of cells horizontally and vertically.
hog.numHorizCells = 8;
hog.numVertCells = 16;

% Cell size in pixels (the cells are square).
hog.cellSize = 8;

% Compute the expected window size (with 1 pixel border on all sides).
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
           
% Read in the test image to be searched.
img = imread('./Images/Validation/IMG_0104.jpg');

img1 = rgb2gray(img);

% Search the image for persons.
detectedWindows = findDetectedWindows(hog, img1);

% Load the annotations file.
annotations = load('./Images/Validation/IMG_0104_annotations.csv');

% Column 5 indicates whether the annotated rectangle is required 
%Person who are in full view are required
requiredIndeces = (annotations(:, 5) == 1);
			
% Re-arrange the rectangles so that the required rectangles are checked first.
annotations = annotations(requiredIndeces, :);
		
% Add a column of zeros to the results to store whether it was a true
% positive (1)
detectedWindows = [detectedWindows, zeros(size(detectedWindows, 1), 1)];

bboxes = []

% For each of the results, validate it.
for k = 1 : size(detectedWindows, 1)

     bboxes= plotDetectedHumans(detectedWindows(k, :), annotations, 0.7,bboxes);
   

end
bboxes;
I = insertObjectAnnotation(img,'rectangle',bboxes,1,'LineWidth',3,'Color','red','TextColor','black','TextBoxOpacity',0);
figure
imagesc(I);
