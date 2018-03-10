function [z] = plot_STZCR(x,f,fsize,fshift,p)
% plot_STZCR: calculates the short term zero crossing rate per each frame
%             and plots it wrt with frame number.
%     z = plot_STZCR(x,f) calculates the short term zero crossing rate
%         per frame for fsize=30ms and fshift=10ms and returns a vector 
%         with these values   
%         x - digital speech signal
%         f - sampling frequency
%     z = plot_STZCR(x,f,fsize,fshift) calculates the short term zero  
%         crossing rate per frame and returns a vector with these values 
%         x - digital speech signal
%         f - sampling frequency
%         fsize - frame size in ms
%         fshift - frame shift in ms
%     z = plot_STZCR(x,f,fsize,fshift,p) calculates and plots the short term 
%         zero crossing rate per frame and returns a vector with these values
%         x - digital speech signal
%         f - sampling frequency
%         fsize - frame size in ms
%         fshift - frame shift in ms

y = signum(x); 
%% initializing fsize and fshift for a particular case
if(nargin == 2)       
    fsize = 30;
    fshift = 10;
end

%% calculating parameters for frame wise analysis of speech
samples_per_frame = floor(fsize*f/1000);                 % no. of samples in a frame  
samples_per_shift = floor(fshift*f/1000);                % no. of samples in a shift of the frame 
no_of_frames = floor(length(x)/samples_per_shift);       % total number of samples in the speech signal

z = zeros(no_of_frames);

%% calculating the short term zero crossing rate per each frame
for i=1:no_of_frames
    if(length(x)<(i-1)*samples_per_shift+samples_per_frame)
        break;
    end
    for j=(i-1)*samples_per_shift+1:(i-1)*samples_per_shift+samples_per_frame-1
        z(i) = z(i)+abs(y(j+1)-y(j));
    end
    z(i) = z(i)/(2*fsize);
end

%% plotting the speech signal and the short term energy contour 
if(nargin == 5)
    figure;
    subplot 211;                                             
    plot([1:length(x)],x);                               % plotting the speech signal     
    title('\fontsize{16}\color{red}Speech Waveform');
    xlim([1 length(x)]);
    xlabel('Sample Number');
    ylabel('Speech Signal');

    subplot 212;
    plot([1:length(z)],z);                            % plotting the short term energy contour
    title('\fontsize{16}\color{red}Short Term Zero Crossing Rate for frame');
    xlim([1 length(z)]);
    xlabel('Frame Number');
    ylabel('Short Term Zero Crossing Rate');
end