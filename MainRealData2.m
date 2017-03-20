
% Here we load the image and get ROI, Line and DATA
%function Length = TrackLength(M)
% function [Mshow, M, Lines, ROIs]= MainRealData2(MakeDirectory,numF)

% if nargin==0
%    MakeDirectory=0;
%    numberF=1;
% elseif nargin==1
%    MakeDirectory=0;
%    numberF=1;
% else
%    MakeDirectory=MakeDirectory;
%    numberF=numF;
% end;
 MakeDirectory=0;
   numberF=1;
[FileName1, PathName1] =uigetfile('*.tif', 'Select the Greyscale Movie');
[FileName2, PathName2] =uigetfile('*.tif', 'Select the Binary Movie');
filenamepath1 = strcat(PathName1, FileName1);
filenamepath2 = strcat(PathName2, FileName2);
Mshow = GetMovie(filenamepath1)
M = GetMovie(filenamepath2)
%M{1}
%assumes your foldername matches your greyscale movie name
foldername = strtok(FileName1,'.');
if MakeDirectory ==1
    cd('C:\Users\omarchenko\Documents\FilopodiaTracking\')
    mkdir(foldername)
    cd(foldername);
    for n=1:numberF
        mkdir(strcat('movie', num2str(n)));
    end
end
numberF=1;
%savepath =strcat('Z:\FiloData04122013_multiroi\',foldername,'\movie');
savepath =strcat('C:\Users\omarchenko\Documents\FilopodiaTracking\',foldername,'\movie');
numFrame=1;
ROIs = cell(1,numberF);
Lines = cell(1,numberF);
%ROIs = cell(1,1);
%Lines = cell(1,1);
numFrames = ones(1,numberF);
%numFrames = ones(1,2);
%numFrames = [108,80,234,264,12]
cd('C:\Users\omarchenko\Documents\FilopodiaTracking\')
tic;
for i = 1:numberF
    [ROIs{i},Lines{i}] = ImageProcessor2(M, numFrames(i));
    
end;


%k3 - bending modulus, k1 - stiffness of string connecting nodes to
%the object, k2 -
dL = 3;
dfi = 0.1;
k1 = 2;
k2 = 3;
k3 = 1;
NumSegments = 5;
mode = 1;

Parameters = [dL dfi k1 k2 k3 NumSegments];
for i=1:numberF
    L0 = sqrt((Lines{i}(1) - Lines{i}(2))^2 + (Lines{i}(3) - Lines{i}(4))^2);
    R0 = [Lines{i}(2) Lines{i}(4)];
    Phi0 = atan2(Lines{i}(3)-Lines{i}(4), Lines{i}(1)-Lines{i}(2));
    Curve0 = [L0/NumSegments Phi0*ones(1, NumSegments)];
    path = strcat(savepath, num2str(i),'\');
    Curve = GetFiloNodes(M, Mshow, ROIs{i}, numFrame,Curve0, R0, Parameters, [], mode, path);
     toc;
    MovieFileName = strcat(foldername, num2str(i));
    matFileName = regexprep(MovieFileName, 'DUP18.tif', '.mat')
    StartFrame = 1;
    Length = cellfun(@(x) NumSegments*x(1), Curve);
    dlmwrite(strcat('C:\Users\omarchenko\Documents\FilopodiaTracking\',foldername,'\', MovieFileName, '.csv'),[(1:numel(Length))' Length']);
    if exist(matFileName,'file')
        load(matFileName);
        Length(StartFrame:numel(Curve)) = cellfun(@(x) NumSegments*x(1), Curve(StartFrame:end));
    else
        Length = cellfun(@(x) NumSegments*x(1), Curve);
    end
    save(matFileName,'Length');
    dlmwrite(regexprep(MovieFileName, 'DUP18.tif', '.csv'),[(1:numel(Length))' Length']);
    close all
    %clear all
   
end;




