function [s,rates, ratesProtrusion, ratesRetraction] = GetPeriod(moviename)
%[peakLocMin,peakMagMin, peakLocMax, peakMagMax] = GetPeriod(doPlot)
if nargin < 1
    doPlot = 0;
end

[FileName,PathName] = uigetfile('*.csv','Select the csv data file');
s = dlmread([PathName FileName]);
s = s';
NumSamples = size(s,2);
sel=(max(s)-min(s))/4
[peakLocMax, peakMagMax] = peakfinder(s,sel,mean(s),1);

[peakLocMin, peakMagMin] = peakfinder(s,sel,mean(s),-1);

extremaI = sort(horzcat(peakLocMax, peakLocMin));
extrema = s(extremaI)

dt = diff(extremaI)
ds = diff(extrema)


rates=ds./dt %scale from pixels to microns

ratesProtrusion = rates(rates>0)
ratesRetraction = rates(rates<0)
plot(s,'r.-')
hold on
plot(peaks,'bo','MarkerFaceColor','b')
hold off

dlmwrite(strcat('C:\Users\Olena\Documents\FiloDataProcessing2015\', moviename, 'rates', '.csv'),[ratesProtrusion,ratesRetraction]);
%
%meanT = zeros(NumSamples,1);
%steT = zeros(NumSamples,1);

%hold off
%title(['Mean period = ' num2str(meanT(i)) ';   Standard error = ' num2str(steT(i))])


% for i = 1:NumSamples
%     Idx = find(s(:,i) ~= 0, 1, 'last'); 
%     s_old = [s(1:Idx,i); s(Idx:(-1):1,i)];
%     sf = fft(s_old);
%     m = 50;
%     sf(2+m:end-m) = 0;
%     s_new = ifft(sf);
%     s_new = s_new(1:end/2);
%     peaks = peakfinder(s_new);
%     T_All = peaks(2:end) - peaks(1:end-1);
%     meanT(i) = mean(T_All);
%     steT(i) = std(T_All)/sqrt(numel(T_All)-1);
%     if doPlot
%         plot(s(1:Idx,i),'r.-')
%         hold on
%         plot(peaks, s(peaks,i),'bo','MarkerFaceColor','b')
%         hold off
%         title(['Mean period = ' num2str(meanT(i)) ';   Standard error = ' num2str(steT(i))])
%         waitforbuttonpress
%     end
end
