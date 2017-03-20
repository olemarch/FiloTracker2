
% Here we load the image and get ROI, Line and DATA
function Length = TrackLength(M)
[ROI,Line] = GetMeasurements(M);

% This is the main routine

dL = 4;
dfi = 0.2;
k1 = 1;
k2 = 2;
k3 = 1;
NumSegments = 4;
mode = 1;

Parameters = [dL dfi k1 k2 k3 NumSegments];

L0 = sqrt((Line(1) - Line(2))^2 + (Line(3) - Line(4))^2);
R0 = [Line(2) Line(4)];
Phi0 = atan2(Line(3)-Line(4), Line(1)-Line(2));
Curve0 = [L0/NumSegments Phi0*ones(1, NumSegments)];

Curve = GetFiloNodes(M, ROI, Curve0, R0, Parameters, [], mode);
% Plotting exact and found via CV lengths

Length = cellfun(@(x) NumSegments*x(1), Curve);

