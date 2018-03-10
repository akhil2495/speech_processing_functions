function Fe = formant_estimate(x,f,fsize,fshift,p)
% formant_estimate: plots the formant estimated contour of each frame with
%                   a pause of 0.5 seconds
%            input: 
%                   x - digital speech signal
%                   f - sampling frequency
%                   fsize - frame size in ms
%                   fshift - frame shift in ms
%                   p - for choosing 3D contour plot or the 2D framewise
%                       plot
%                       1 -> 2D framewise plot
%                       0 -> 3D contour
%           output:
%                   Fe - matrix containing Fe contour values of each frame
% Author : Akhil Babu Manam

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

%% calculating cepstrum values
F = fft_cepstrum(x,f,fsize,fshift,0);

%% low time liftering window
L = zeros(size(F,1),1);
L(1:30) = 1;
for i = 1:size(F,2)
    i
    A = F(:,i).*L;
    Ch(:,i) = A(1:30);
end

%% calculating magnitude spectrum
for i = 1:size(Ch,2)
    i
    K(:,i) = real(fft(Ch(:,i),8000));
    Fe(:,i) = K(1:size(K,1)/2,i); 
end
Fe = exp(Fe);

%% plotting magnitude spectrum
if(p==1)
    figure;
for j=1:nof
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
    
    subplot(2,1,2)
    plot(Fe(:,j));
    pause(0.5);
end
end
if(p==0)
    figure;
    t = [1:nof]*fshift;
    w = linspace(1/f,f/2,size(Fe,1));
    subplot(2,1,1);                                             
    plot([1000/f:1000/f:1000*length(x)/f],x);     % plotting the speech signal     
    title('\fontsize{16}\color{red}Speech Waveform');
    xlim(1000*[1/f length(x)/f]);                 % setting limits for better visulisation 
    xlabel('time in ms');
    ylabel('Speech Signal');
    subplot(2,1,2)
    surf(t,w,Fe);                               % plotting stft with time and frequency
    title('\fontsize{16}\color{red}Formant Contour');
    colorbar;
    xlim([fshift fshift*nof]);                    
    ylim([1/f f/2]);
    xlabel('time');
    ylabel('frequency');
    zlabel('Magnitude Spectrum');  
    shading interp;
end
end