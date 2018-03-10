function F = FTview_STFT(x,f,fsize,fshift,t)
% FTview_STFT: plots the Fourier Transform view of the speech signal
%              x: digital speech signal
%              f: sampling frequency
%              fsize: frame size in ms
%              fshift: frame shift in ms
%              t: time in ms at which the FT view is to be observed
% Author : Akhil Babu Manam

%% if fsize and fshift are not given they are initialized to 30 and 10 respectively
if (nargin==2)
    fsize = 30;
    fshift = 10;
end

%% framewise parameters
spf = floor(fsize*f/1000);          % samples per each frame
sps = floor(fshift*f/1000);         % samples in one shift of frame
nof = floor((length(x)-spf)/sps);   % total no. of frames

%% calculating the STFT for a particular frame
fr = floor(t/fshift);
S = plot_STFT(x,f,fsize,fshift);
F = S(:,fr);

%% plotting the signal for comparison
figure;
subplot(2,1,1)
b = [1000/f:1000/f:1000*length(x)/f];
plot(b,x);     % plotting the speech signal     
a = zeros(length(b),1);
for i=(fr-1)*sps+1:(fr-1)*sps+spf
    a(i) = 1;
end
hold on;
plot(b,a,'r');
title('\fontsize{16}\color{red}Speech Waveform');
xlim(1000*[1/f length(x)/f]);                 % setting limits for better visulisation 
xlabel('time in ms');
ylabel('Speech Signal');

%% plotting the filterview of STFT
w = linspace(1/f,f/2,size(S,1));
subplot(2,1,2);
title(sprintf('FT view for frame %d',fr));
plot(w,F);
xlim([1/f f/2]);
xlabel('Frequency');
ylabel('STFT Magnitude Spectrum');