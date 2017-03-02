function [spectra, offsetppm] = ref_spectra(spectra, thresh, offsetppm)
% ************
% Reference spectra.
% Required arguments
%     spectra - Structure array containing fields: real, ppm
% Optional arguments:
%     thresh - 0.01 (default)
%     offsetppm - If set, don't manually pick the reference from the first spectra.
%     Instead, pick the peak in each spectra closest to offsetppm.
% *******************
%% Deal arguments
if ~exist('thresh','var')
    thresh = 0.01;
end
%% Manually pick reference peak
if ~exist('offsetppm','var') || isempty('offsetppm')
    i=1;
    peaks=peakpick(spectra(i).real,30,thresh*max(spectra(i).real));
    plot(spectra(i).ppm,spectra(i).real,'k'), hold,
    plot(spectra(i).ppm(peaks),spectra(i).real(peaks),'ro')
    set(gca,'xlim',[-.7,.7])
    set(gca,'xdir','rev')
    [x,y]=ginput(1);
    close
    [~,idx]=min(abs(x-spectra(i).ppm(peaks)));
    TSP_ppm(i)=spectra(i).ppm(peaks(idx));
    spectra(i).ppm=spectra(i).ppm-TSP_ppm(i);
    offsetppm = TSP_ppm(i);
else
    peaks=peakpick(spectra(1).real,30,thresh*max(spectra(1).real));
    [~,idx]=min(abs(offsetppm-spectra(1).ppm(peaks)));
    TSP_ppm(1)=spectra(1).ppm(peaks(idx));
    spectra(1).ppm=spectra(1).ppm-TSP_ppm(1);
end
%% Pick all peaks

for i=2:length(spectra)
    spectra(i).ppm=spectra(i).ppm-TSP_ppm(1);
    peaks=peakpick(spectra(i).real,30,thresh*max(spectra(i).real));
    [~, idx] = min(abs(spectra(i).ppm(peaks)));
    TSP_ppm(i)=spectra(i).ppm(peaks(idx));
    spectra(i).ppm=spectra(i).ppm-TSP_ppm(i);
end

figure;
hold on
cmap=colormap(lines(length(spectra)));


for i=1:length(spectra)
    plot(spectra(i).ppm,spectra(i).real,'Color',cmap(i,:))
end
set(gca,'XDir','reverse')
