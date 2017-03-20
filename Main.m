clear all

% Here we simulate filopodia dynamics

NumIterations = 2000;
doAnimation = 1;
Data = GenerateFiloDynamics(NumIterations, doAnimation);

% In this part we generate images by using pointspread function

PixelSizeX = 0.05;
PixelSizeY = 0.05;
Domain = {[-2.5 2.5], [-2.5 2.5]};
ExactCurve = cellfun(@(x) [(x(1,:)-Domain{1}(1))/PixelSizeX; (x(2,:)-Domain{2}(1))/PixelSizeY],...
    Data, 'UniformOutput', 0);
M = GenerateMovieFrames(Data, PixelSizeX, PixelSizeY, Domain);

% This is the main routine

MinX = 40;
MaxX = 60;
MinY = 25;
MaxY = 75;
ROI = [MinX MaxX MinY MaxY];
dL = 5;
dfi = 0.3;
k1 = 2;
k2 = 2;
k3 = 1;
NumSegments = 3;
mode = 2;

Parameters = [dL dfi k1 k2 k3 NumSegments];

L0 = 10;
R0 = [50 50];
Phi0 = 0;
Curve0 = [L0/NumSegments Phi0*ones(1, NumSegments)];

Curve = GetFiloNodes(M, ROI, Curve0, R0, Parameters, ExactCurve, mode);

% Plotting exact and found via CV lengths

L_approx = cellfun(@(x) NumSegments*x(1), Curve);
L_exact = cellfun(@(x) sum(sqrt((x(1,2:end) -x(1,1:end-1)).^2 + (x(2,2:end) - x(2,1:end-1)).^2)), ExactCurve);
plot(L_exact, 'r')
hold on
plot(L_approx)
hold off
title(['Error = ' num2str(mean(sqrt(L_exact-L_approx).^2))]);
