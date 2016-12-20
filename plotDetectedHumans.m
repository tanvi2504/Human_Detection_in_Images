function [bboxes]= plotDetectedHumans(inRect, compRects, thresh,bboxes)

	% Get the coordinates of the top-left and bottom-right corners
	% of the rectangle.
	ax1 = inRect(1, 1);
    ay1 = inRect(1, 2);
    ax2 = ax1 + inRect(1, 3);
    ay2 = ay1 + inRect(1, 4);
	
	% Compute the area of the result rectangle A
	aArea = inRect(1, 3) * inRect(1, 4);
	
	% For each of the annotated results...
	for i = 1 : size(compRects, 1)
		% If the rectangles overlap sufficiently...

		% Get the coordinates of the top-left and bottom-right corners
		% of the rectangle.
		bx1 = compRects(i, 1);
		by1 = compRects(i, 2);
		bx2 = bx1 + compRects(i, 3);
		by2 = by1 + compRects(i, 4);
		
		% Copmute the area of the annotated rectangle B
		bArea = compRects(i, 3) * compRects(i, 4);
		
		% Calculate the amount of overlap in the x and y dimensions.
        x_overlap = max(0, min(ax2, bx2) - max(ax1, bx1));
        y_overlap = max(0, min(ay2, by2) - max(ay1, by1));

		% Compute the area of intersection (the area of overlap)
		intersectArea = x_overlap * y_overlap;
		
		% Compute the area of union (the areas of non-overlap plus the area of overlap).
		unionArea = aArea + bArea - intersectArea;
		
		% If the area of overlap exceeds 'thresh' (default is 0.8), it's a
        % match.
		if ((intersectArea / unionArea) > thresh)
		
             bboxes=[bboxes;ax1,ay1,inRect(1, 3),inRect(1, 4)];
       
		end
		
	end
	
% End function
end