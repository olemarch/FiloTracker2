function MeanDist2 = FindDistance(ROI, R0, curves, M)

NumCurves = size(curves,1);
n = size(curves,2);
NodesX = R0(1) + [zeros(NumCurves,1) repmat(curves(:,1), 1, n-1).*cumsum(cos(curves(:,2:n)),2)];
NodesY = R0(2) + [zeros(NumCurves,1) repmat(curves(:,1), 1, n-1).*cumsum(sin(curves(:,2:n)),2)];

[row, col] = find(M<1/2);
ROIMask = row >= ROI(2) & row <= ROI(2)+ROI(4) & col >= ROI(1) & col <= ROI(1)+ROI(3);
row = row(ROIMask);
col = col(ROIMask);
m = length(col);
MeanDist2 = zeros(NumCurves,1);

for i = 1:NumCurves
    MeanDist2(i) = mean(min((repmat(NodesX(i,:), m, 1) - repmat(col, 1, n)).^2 +...
        (repmat(NodesY(i,:), m, 1) - repmat(row, 1, n)).^2));
end



