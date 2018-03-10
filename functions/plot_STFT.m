function [stft] = plot_STFT(x,f,fsize,fshift,p)
% plot_STFT: plots the STFT of the speech signal x with frequency and time
%            x: digital speech signal
%            f: sampling frequency
%            fsize: frame size in ms
%            fshift: frame shift in ms
%            p: variable for plotting 
%               If p=1, plot
%               Otherwise, only calculates the value

%% if fsize and fshift are not given they are initialized to 30 and 10 respectively
if(nargin == 2)
    fsize = 30;
    fshift = 10;
end

if(nargin == 3)
    fsize = 30;
    fshift = 10;
end

%% framewise parameters
spf = floor(fsize*f/1000);          % samples per each frame
sps = floor(fshift*f/1000);         % samples in one shift of frame
nof = floor((length(x)-spf)/sps);   % total no. of frames

%% STFT calculation
S = [];
M = [];
for i = 1:nof
    S(:,i) = abs(fft([x((i-1)*sps+1:(i-1)*sps+spf);zeros(512-spf,1)]',512));
    
%     S(:,i) = T(1:size(T,1)/2,i);
%     S(:,i) = abs(fft(x((i-1)*sps+1:(i-1)*sps+spf)));  % calculating the log magnitude spectrum for a frame 
end
stft=[];
stft(1:size(S,1)/2,:)=S(1:size(S)/2,:);               % Taking only half values as the spectrum is symmetric
% stft(1:size(S,1),:)=S(1:size(S),:);

%% plotting STFT obtained
if(nargin == 5)                                       % 3D plot  
    if(p==1)
        t = [1:nof]*fshift;                           % plotting in time frame per fshfit
        w = linspace(1/f,f/2,size(stft,1));           % plotting in frequency frame
        figure;
        subplot(2,1,1);                                             
        plot([1000/f:1000/f:1000*length(x)/f],x);     % plotting the speech signal     
        title('\fontsize{16}\color{red}Speech Waveform');
        xlim(1000*[1/f length(x)/f]);                 % setting limits for better visulisation 
        xlabel('time in ms');
        ylabel('Speech Signal');
        subplot(2,1,2)
        surf(t,w,stft);                               % plotting stft with time and frequency
        title('\fontsize{16}\color{red}STFT plot');
        colorbar;
        xlim([fshift fshift*nof]);                    
        ylim([1/f f/2]);
        xlabel('time');
        ylabel('frequency');
        zlabel('STFT Magnitude Spectrum');
        shading interp;                               % for smoothness of the plot 
    end
end