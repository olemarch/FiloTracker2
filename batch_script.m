
matlabpool open CAM 3
pwd
c = parcluster();
j = batch(c,@multiroiScript,0,'bb5_setUP.mat');
wait(j);
diary(j)  % Display the diary
matlabpool close