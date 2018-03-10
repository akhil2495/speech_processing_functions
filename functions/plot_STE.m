function [e] = plot_STE(x,f,fsize,fshift,p)
% plot_STE: calculates the short term energy contour per each frame and
%           plots the contour with frame number.
%     e = plot_STE(x,f) calculates the short term energy per frame for
%         fsize=30ms and fshift=10ms and returns a vector with these values   
%         x - digital speech signal
%         f - sampling frequency
%     e = plot_STE(x,f,fsize,fshift) calculates the short term energy 
%         per frame and returns a vector with these values 
%         x - digital speech signal
%         f - sampling frequency
%         fsize - frame size in ms
%         fshift - frame shift in ms
%     e = plot_STE(x,f,fsize,fshift,p) calculates and plots the short term energy
%         per frame and returns a vector with these values
%         x - digital speech signal
%         f - sampling frequency
%         fsize - frame size in ms
%         fshift - frame shift in ms

%% initializing fsize and fshift for a particular case
if(nargin == 2)       
    fsize = 30;
    fshift = 10;
end

%% calculating parameters for frame wise analysis of speech
samples_per_frame = floor(fsize*f/1000);                 % no. of samples in a frame  
samples_per_shift = floor(fshift*f/1000);                % no. of samples in a shift of the frame 
no_of_frames = floor(length(x)/samples_per_shift);       % total number of samples in the speech signal

e = [];
%% calculating the short term energy per frame
for i = 1:no_of_frames
    if(length(x)<(i-1)*samples_per_shift+samples_per_frame)
        break;
    end
    e(i)=sum(x((i-1)*samples_per_shift+1:(i-1)*samples_per_shift+samples_per_frame).^2);
end

%% plotting the speech signal and the short term energy contour 
if(nargin == 5)
    figure;
    subplot(2,1,1);                                             
    plot([1:length(x)],x);                               % plotting the speech signal     
    title('\fontsize{16}\color{red}Speech Waveform');
    xlim([1 length(x)]);
    xlabel('Sample Number');
    ylabel('Speech Signal');

    subplot(2,1,2);
    plot([1:length(e)],e);                            % plotting the short term energy contour
    title('\fontsize{16}\color{red}Short Term Energy for frame');
    xlim([1 length(e)]);
    xlabel('Frame Number');
    ylabel('Short Term Energy Value');
end
end