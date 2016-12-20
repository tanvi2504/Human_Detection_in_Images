
% Find the HOG descriptor for the test image

fprintf('Getting the HOG descriptor for an example image...\n');

img = imread('./Images/test/pos/crop_000002b.png');
img = rgb2gray(img);
img =imresize(img,[130 66]);

% Compute the HOG descriptor for this image.
[featureVector,visualization] = extractHOGFeatures(img, 'CellSize',[8 8]);
figure;
imagesc(img);
colormap gray;
hold on;
plot(visualization);

% Load the pre-trained HOG model.
load('hogModel.mat');

% Evaluate the linear SVM on the descriptor.
[q,score] = predict(hog.mdl,featureVector);

% Print whether we think it's a person or not 
if (q > 0)
    fprintf('  This image contains a person!\n');
else
    fprintf('  This image does not contain a person!\n');
end


