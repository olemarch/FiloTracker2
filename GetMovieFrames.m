function Movie = GetMovieFrames(moviename, startFrame, endFrame)
fileName = moviename;
tiffInfo = imfinfo(fileName);  %# Get the TIFF file information
no_frame = numel(tiffInfo);    %# Get the number of images in the file
Movie = cell((endFrame-startFrame+1),1);      %# Preallocate the cell array
for iFrame = startFrame:endFrame
    Movie{iFrame} = double(imread(fileName,'Index',iFrame,'Info',tiffInfo));
end