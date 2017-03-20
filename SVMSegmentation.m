clear all
tic;
Mshow = GetMovie('ts7_eigen100.tif');
M = GetMovie('ts7_eigen100_binary.tif');
s = Mshow{1};
s_segmented = M{1};
clear Mshow M;
subplot(2,1,1)
imshow(s)
subplot(2,1,2)
imshow(s_segmented)

N = 2;
NeighborsIdx = sub2ind(size(s), repmat((1:2*N+1)', 2*N+1, 1), sort(repmat((1:2*N+1)', 2*N+1, 1))) - N - N*size(s,1) -1;
[i j] = ind2sub(size(s), (1:numel(s))');
ValidMask = i>N & i <= size(s,1)-N & j>N & j <= size(s,2)-N;
i = i(ValidMask);
j = j(ValidMask);
Idx = sub2ind(size(s), i, j);

AllIdx = repmat(Idx, 1, (2*N+1)^2) + repmat(NeighborsIdx', length(Idx), 1);
Feats = s(AllIdx);
Label = s_segmented(Idx);
clear AllIdx;

NormalizedFeats = zscore(Feats);
clear Feats;
NumCellPixels = sum(Label == 0);
NumNonCellPixels = sum(Label == 1);
ratio = round(NumNonCellPixels/NumCellPixels);
NormalizedFeats_Cell = NormalizedFeats(Label==0,:);
NormalizedFeats_NonCell = NormalizedFeats(Label==1,:);
clear NormalizedFeats;
NormalizedFeats_Cell = repmat(NormalizedFeats_Cell, ratio, 1);
model = svmtrain([zeros(NumCellPixels*ratio); ones(NumNonCellPixels, 1)], [NormalizedFeats_Cell; NormalizedFeats_NonCell], '-t 2');
tic;
% label_predict = svmpredict(label_guess, feats, model);
