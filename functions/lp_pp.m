function p = lp_pp(x,f,fsize,fshift,p)
% Computes the pitch period using lp residual signal

%% make sure fsize and fshift are not uninitialized
if(nargin<5)
    fsize = 30;
    fshift = 10;
end

%% initialize frame parameters
spf = floor(fsize*f/1000);                     % no. of samples in a frame 
sps = floor(fshift*f/1000);                    % no. of samples shifted from frame to frame
nof = floor(length(x)/sps);      % total no. of frames 

%% calculating residue
e = lp_residue(x,f,fsize,fshift,11,0);

%% autocorrelation of residue
[r0,R] = plot_STAC(e,f,fsize,fshift);

%% recognising pitch period
for m = 1:size(R,1)
    mxval = max(R(m,floor(2*f/1000):floor(10*f/1000)));
    mx = floor(2*f/1000);
    for k = floor(2*f/1000):floor(10*f/1000)
        if(R(m,k)==mxval)
            mx = k;                                     % frame index of max frame in 2-10ms
            break;
        end
    end
    p(m) = f/mx;                                       % frame index*1/f = pitch time, pitch frequency = 1/ pitch time
end

%% calling cepstral calculated and auto correlation pitch for comparison
c_p = ceps_pp(x,f,fsize,fshift,0);
a_p = plot_pp(x,f,fsize,fshift,0);

%% plotting pitch frequency
subplot(4,1,1);
plot([1:length(x)],x);
title('\fontsize{16}\color{red}Speech Waveform');
xlim([1 length(x)]);
xlabel('sample no.');
ylabel('Speech signal');

subplot(4,1,2);
plot([1:size(R,1)],p,'k.');
title('\fontsize{16}\color{red}lp analysis');
xlim([1 size(R,1)]);
xlabel('frame number');
ylabel('pitch frequency in frame');

subplot(4,1,3);
plot([1:length(c_p)],c_p,'k.');
title('\fontsize{16}\color{red}cepstrum');
xlim([1 length(c_p)]);
xlabel('frame number');
ylabel('pitch frequency in frame');

subplot(4,1,4);
plot([1:length(a_p)],a_p,'k.');
title('\fontsize{16}\color{red}Autocorr');
xlim([1 length(a_p)]);
xlabel('frame number');
ylabel('pitch frequency in frame');
end
