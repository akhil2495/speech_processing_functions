function W = Filtview_STFT(x,f,fsize,fshift,w)
% Filtview_STFT: plots the filtering view of STFT of signal x at freq w
%                x: digital speech signal
%                f: sampling frequency
%                fsize: frame size in ms
%                fshift: frame shift in ms
%                w: frequency at which the filtering view is obtained  
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
S = plot_STFT(x,f,fsize,fshift);    % calling the function without plotting the values
w = floor(w*spf/f);                 % converting it into the number at which col/row stored 
if (w==0)                           % eliminating index 0 with 1 approximately. 
    w = 1;
end
W = S(w,:);                         % storing the values for particlar w

%% plotting the signal for comparison
figure;
subplot(2,1,1)
plot([1000/f:1000/f:1000*length(x)/f],x);     % plotting the speech signal     
title('\fontsize{16}\color{red}Speech Waveform');
xlim(1000*[1/f length(x)/f]);                 % setting limits for better visulisation 
xlabel('time in ms');
ylabel('Speech Signal');

%% plotting the filterview of STFT
t = [1:nof]*fshift;
subplot(2,1,2);
title(sprintf('Window view for w = %d',w));
plot(t,W);
xlim([fshift fshift*nof]);
xlabel('time');
ylabel('STFT Magnitude Spectrum');