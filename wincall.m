function wincall(varargin)
% WindowButtonDownFcn for figure.
P = varargin{3}; 
cp = get(varargin{1},'currentpoint');
if cp(1)>P(1) && cp(2)>P(2) && cp(1) < (P(1)+P(3)) && cp(2)<(P(2)+P(4))
    disp('In Axes')
else
    disp('Not in Axes')
end