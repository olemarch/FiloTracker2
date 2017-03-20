function RunALL()
global MovieName
clear all; 
MovieName = input('Enter name of file: ', 's');
%MovieName = 'simple_binary_sensNoise.tif';
%M = GetMovie('simple_binary_sensNoise.tif');
M = GetMovie(MovieName);
%start looping until correction needed
L_approx = TrackLength(M,1);
%set(fh,'windowbuttondownfcn',{@correctLine,get(gca,'position')})
plot(L_approx)
saveppt2('Hren''.ptt','figure',h,'d','bitmap','t','FiloTrack')
L_turn = L_approx'
uisave('L_turn', strcat(MovieName,num2str(ceil(L_turn(1))),'.xls'));





