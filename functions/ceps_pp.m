function [p,To] = ceps_pp(x,f,fsize,fshift,p_lot)
% ceps_pp: plots the pitch frequency contour wrt time below the actual
%          signal for comparison of pitch
%          Note: pitch perriod is calculated using fft cepstrum
%   input: 
%          x - discrete time speech signal
%          f - sampling frequency in Hz
%          fsize - framesize in ms
%          fshift - frameshift in ms
%  output:
%          p - vector containing pitch frequency for each frame
%          To - vector containing pitch period for each frame
% Author : Akhil Babu Manam

%% initializing fsize and fshift if not given
if(nargin==2)
    fsize = 30;
    fshift = 10;
end
p = [];

%% calculating parameters for frame wise analysis of speech
spf = floor(fsize*f/1000);                 % no. of samples in a frame  
sps = floor(fshift*f/1000);                % no. of samples in a shift of the frame 
nof = floor((length(x)-spf)/sps);          % total number of samples in the speech signal

%% log|STFT| calculation
S=[];
for i=1:nof
    S(:,i) = abs(fft([[x((i-1)*sps+1:(i-1)*sps+spf)];zeros(512-spf,1)]',512));
end
S = log10(S);

%% Cepstrum calculation
for i=1:nof
    D(:,i) = ifft(S(:,i));
    C(:,i) = D(1:size(D,1)/2,i);
end

%% pitch determination
for i=1:nof
    [maxi,j] = max(C(floor(600/fsize):end,i));
    for k=floor(600/fsize):256
        if(C(k,i)==maxi)
            j=k;
            break;
        end
    end
    To(i) = j*fsize/256;
    p(i) = 1000/To(i);
end

%% plotting pitch
if(p_lot == 1)
figure;
t = [1000/f:1000/f:1000*length(x)/f];
a = [1:nof]*fsize;

subplot(2,1,1)
plot(t,x);
title('\fontsize{14}\color{red}Speech Signal');
xlim([t(1) t(length(t))]);
xlabel('Time in ms');
ylabel('Signal magnitude');

subplot(2,1,2)
plot(a,p,'k.');
title('\fontsize{14}\color{red}Pitch frequency plot');
xlim([a(1) a(length(a))]);
xlabel('Time in ms');
ylabel('Frequency in Hz');
end
end