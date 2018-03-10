function [ac,a] = mylpc(x,f,fsize,fshift,p)

%% make sure fsize and fshift are not uninitialized
if(nargin<5)
    fsize = 30;
    fshift = 10;
end

%% initialize frame parameters
spf = floor(fsize*f/1000);                     % no. of samples in a frame 
sps = floor(fshift*f/1000);                    % no. of samples shifted from frame to frame
nof = floor(length(x)/sps);      % total no. of frames 

%% calculating autocorrelation values
[r0,R] = plot_STAC(x,f,fsize,fshift);

%% calculating lpc coefficients
for fr = 1:nof
    if(sps*(fr-1)+spf>length(x))
        break;
    end
    m=autocorr(x(sps*(fr-1)+1:sps*(fr-1)+spf))
    ac(:,fr) = [1;LD_func(m(1),m(2:p+1))];%r0(fr),R(fr,1:p)
    a(:,fr) = lpc(x(sps*(fr-1)+1:sps*(fr-1)+spf),p);
end

end