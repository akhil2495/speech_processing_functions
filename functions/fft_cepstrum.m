function C = fft_cepstrum(x,f,fsize,fshift,p)
% fft_cepstrum: calculates and plots the fft_cepstrum of each frame with
%               N=256 samples with a pause of 0.5 seconds in between
%        input: 
%               x - discrete time speech signal
%               f - sampling frequency in Hz
%               fsize - framesize in ms
%               fshift - frameshift in ms
%               p - specifies whether to plot or only calculate
%                   1 -> plot
%                   other -> calculate
%       output:
%               C - matrix containing cepstrum 256 cepstrum values for each
%                   frame
% Author : Akhil Babu Manam

%% initializing fsize and fshift if not given
if(nargin==2)
    fsize = 30;
    fshift = 10;
end

%% calculating parameters for frame wise analysis of speech
spf = floor(fsize*f/1000);                 % no. of samples in a frame  
sps = floor(fshift*f/1000);                % no. of samples in a shift of the frame 
nof = floor((length(x)-spf)/sps);          % total number of samples in the speech signal

%% log|STFT| calculation
% S = plot_STFT(x,f,fsize,fshift);
% S = abs(S);
for i=1:nof
    S(:,i) = abs(fft([x((i-1)*sps+1:(i-1)*sps+spf);zeros(512-spf,1)]',512));
%     S(:,i) = abs(fft(x((i-1)*sps+1:(i-1)*sps+spf)));
%     S(:,i) = T(1:size(T,1)/2,i);
end
S = log10(S);

%% Cepstrum calculation
for i=1:nof
    D(:,i) = ifft(S(:,i));
    C(:,i) = D(1:size(D,1)/2,i);
end

%% Use this code for plotting cepstrum
if(p==1)
    figure;
for j=1:nof
    %% plotting Speech signal
    
    t = [1000/f:1000/f:1000*length(x)/f];    
    subplot(2,1,1)
    plot(t,x);
    title('\fontsize{14}\color{red}Speech Signal');
    xlim([t(1) t(length(t))]);
    xlabel('Time in ms');
    ylabel('Signal magnitude');

    b = [1000/f:1000/f:1000*length(x)/f];
    a = zeros(length(b),1);
    for i=(j-1)*sps+1:(j-1)*sps+spf
        a(i) = 1;
    end
    hold on;
    h(j) = plot(b,a,'r');
    for k = 1:j-1
        set(h(k),'Visible','off');
    end

    a = [1000/f:1000/f:size(C,1)*1000/f];
    subplot(2,1,2)
    plot(a,C(:,j));
    xlim([1000/f size(C,1)*1000/f]);
    xlabel('quefrence');
    ylabel('cepstrum');
    pause(0.5);
end
end
end