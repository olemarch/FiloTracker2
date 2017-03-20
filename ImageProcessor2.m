function [ROI,Line] = ImageProcessor2(Movie, numFrame)
frame_1 = Movie{numFrame};
colormap gray;
imagesc(frame_1);
[x1,x2,y1,y2] = GetLine(frame_1);
Line = [x1,x2,y1,y2];
ROI = GetROI(frame_1);
close(gcf);