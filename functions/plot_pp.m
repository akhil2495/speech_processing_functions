function [pp] = plot_pp(x,f,fsize,fshift,p_lot)
% plot_pp : plots "pitch frequency" for every frame
%    R = plot_pp(x,f) plots "pitch frequency" with frame size 30ms and frame
%        shift 10ms
%        x - discrete signal
%        f - sampling frequency
%    R = plot_STAC(x,f,fsize,fshift) plots "pitch frequency" for every
%        frame
%        x - discrete signal
%        f - sampling frequency
%        fsize - frame size in ms
%        fshift- frame shift in ms

if(nargin == 2)
    fsize = 30;
    fshift = 10;
end

samples_per_frame = floor(fsize*f/1000);                % no. of samples in a frame 
samples_per_shift = floor(fshift*f/1000);               % no. of samples shifted from frame to frame
no_of_frames = floor(length(x)/samples_per_shift);      % total no. of frames 

[r0,R] = plot_STAC(x,f,fsize,fshift);                      % calculating 2D matrix R(stac)

for m = 1:size(R,1)
    mxval = max(R(m,floor(2*f/1000):floor(10*f/1000)));
    mx = floor(2*f/1000);
    for k = floor(2*f/1000):floor(10*f/1000)
        if(R(m,k)==mxval)
            mx = k;                                     % frame index of max frame in 2-10ms
            break;
        end
    end
    pp(m) = f/mx;                                       % frame index*1/f = pitch time, pitch frequency = 1/ pitch time
end

if(p_lot==1)
subplot(2,1,1);
plot([1:length(x)],x);
title('\fontsize{16}\color{red}Speech Waveform');
xlim([1 length(x)]);
xlabel('sample no.');
ylabel('Speech signal');

subplot(2,1,2);
plot([1:no_of_frames],pp,'k.');
title('\fontsize{16}\color{red}pitch frequency vs frame');
xlim([1 no_of_frames]);
xlabel('frame number');
ylabel('pitch frequency in frame');
end
end