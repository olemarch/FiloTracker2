function [ROI,Line] = ImageProcessor(Movie)
frame_1 = Movie{1};
imshow(frame_1);
[x1,x2,y1,y2] = GetLine(frame_1);
Line = [x1,x2,y1,y2];
ROI = GetROI(frame_1);
