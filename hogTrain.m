%get the images from the directory
%these images are 130 by 66 sized
posImages = getImagesInDir('./Images/train/pos/');
negImages = getImagesInDir('./Images/train/neg/');

% The labels for negative and positive images
Y = [ones(length(posImages), 1); zeros(length(negImages), 1)];

% Combine the file lists to get a list of all training images.
fileList = [posImages, negImages];

% Build a matrix for all the 3780 features
X = zeros(length(fileList), 3780);

fprintf('Total number of files to train the svm: %d', length(fileList));
		
% For all the training images
for i = 1 : length(fileList)

    imgFile = char(fileList(i));
    img = imread(imgFile);
    
    %grayscale images gave better results
    img = rgb2gray(img);
    
    %if the images size if greater than the expected size
    img =imresize(img,[130 66]);
    
    % find the HOG descriptor 
    %using the vision toolbox to get the HOG decriptors
    [featureVector,visualization] = extractHOGFeatures(img, 'CellSize',[8 8]);
    
    %add the hog descriptor for that particular image to the train dataset
    X(i, :) = featureVector';
end
fprintf('\n');

% Train the SVM.
fprintf('\nTraining linear SVM classifier...\n');
%Using the inbuilt svn training function
hog.mdl = fitcsvm(X, Y);

%save the model for testing purpose
save('hogModel.mat', 'hog');

% Check the classification
q = predict(hog.mdl,featureVector);

numRight = sum((q == 0) == Y)+ sum((q == 1) == Y);

fprintf('\nTraining accuracy: (%d / %d) %.2f%%\n', numRight, length(Y), numRight / length(Y) * 100.0);

