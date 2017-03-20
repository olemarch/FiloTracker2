function Movie = GetMovie(moviename, startFrame, endFrame)
fileName = moviename;
tiffInfo = imfinfo(fileName);  %# Get the TIFF file information
no_frame = numel(tiffInfo) ;   %# Get the number of images in the file
numFrame =no_frame;
if nargin==1
    startFr = 1;
    end_frame = no_frame;
elseif( nargin==3)
        if(startFrame<endFrame)
            startFr =startFrame;
            end_frame = endFrame;
            numFrame = endFrame-startFrame+1;
      
        elseif(startFrame>endFrame)
            startFr = endFrame;
            end_frame = startFrame;
            numFrame = startFrame-endFrame+1;
            else
            startFr = 1;
            end_frame = no_frame;
            end;
end;
            
            

Movie = cell(numFrame,1);
%k=1;%# Preallocate the cell array
for iFrame = startFr:end_frame
    Movie{iFrame} = double(imread(fileName,'Index',iFrame,'Info',tiffInfo));
   % k=k+1;
end

% fileName = moviename;
% tiffInfo = imfinfo(fileName);  %# Get the TIFF file information
% no_frame = numel(tiffInfo) ;   %# Get the number of images in the file
% Movie = cell(265,1);
% %k=1;%# Preallocate the cell array
% for iFrame = 1:265
%     Movie{iFrame} = double(imread(fileName,'Index',iFrame,'Info',tiffInfo));
%    % k=k+1;
% end