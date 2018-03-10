function[r0,R] = plot_STAC(x,f,fsize,fshift,p)
% plot_STAC : calculates/plots short term auto correlation of a signal
%    R = plot_STAC(x,f) calculates stac with frame size 30ms and frame
%        shift 10ms
%        x - discrete signal
%        f - sampling frequency
%    R = plot_STAC(x,f,fsize,fshift,p) calculates and plots stac 
%        x - discrete signal
%        f - sampling frequency
%        fsize - frame size in ms
%        fshift- frame shift in ms
%        p = 0 framewise 2D plots are displayed.
%        p = 1 3D plot is displayed.
%    R = plot_STAC(x,f,fsize,fshift) calculates stac
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

R = [];%zeros(no_of_frames,samples_per_frame);
r0 = zeros(no_of_frames,1);
%% calculating Rxx(m,k), m-frame no., k-lag in samples
% for m = 1:no_of_frames
%     for k = 1:samples_per_frame
%         for n = (m-1)*samples_per_shift+1:(m-1)*samples_per_shift+samples_per_frame
%             if(k+n>0)                                   
%                 if(k+n<length(x))                       % to limit x within its bounds
%                     R(m,k) = R(m,k) + x(n)*x(k+n);
%                     r0(m) = r0(m)+x(n)*x(n);
%                 end
%             end
%         end
%     end
% end
for m=1:no_of_frames
    if(samples_per_shift*(m-1)+samples_per_frame>length(x))
        break;
    end
    R(m,:) = xcorr(x(samples_per_shift*(m-1)+1:samples_per_shift*(m-1)+samples_per_frame));
end
r0=0;
%% Plotting all the columns of R vs sample no. in a frame
if(nargin == 5)                                         % framewise 2D plots
    if(p==0)
        for m = 1:no_of_frames
            figure;
            plot([1:samples_per_frame],R(m,:));
            title('\fontsize{16}\color{red}Short term auto correlation for frame ',num2str(m));
            xlim([1 samples_per_frame]);
            xlabel('sample number in the frame');
            ylabel('auto correlation value');
        end
    end
end

if(nargin == 5)                                         % 3D plot  
    if(p==1)
        m = [1:no_of_frames];
        k = [1:samples_per_frame];
        figure;
        surf(k,m,R);
        title('\fontsize{16}\color{red}Short term auto correlation plot');
        colorbar;
        xlim([1 samples_per_frame]);
        ylim([1 no_of_frames]);
        xlabel('lag (in sample no.)');
        ylabel('frame no.');
        zlabel('Auto correlation');
        shading interp;
    end
end
end