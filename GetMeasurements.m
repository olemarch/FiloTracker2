function [ROI,Line] = GetMeasurements(Movie, indFrame)
frame_1 = Movie{indFrame};
imshow(frame_1);
[x1,x2,y1,y2] = GetLine(frame_1);
Line = [x1,x2,y1,y2];
ROI = GetROI(frame_1);