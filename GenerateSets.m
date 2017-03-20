function CandidatesSet = GenerateSets(CurrentSet, dL, dfi)

NumSegments = length(CurrentSet)-1;
dx = dL/NumSegments;
m = 3;
a = -(m-1)/2:(m-1)/2;
SegmentLength = CurrentSet(1) + dx*a;
Ang = repmat(CurrentSet(2:NumSegments+1), m, 1) + dfi*repmat(a', 1, NumSegments);

CandidatesSet = allcomb(SegmentLength, Ang');

