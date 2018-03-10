function I = plot_spec(x,f,fsize,fshift,p)
% plot_spec: plots the spectrogram of the given signal x
%            x: digital speech signal
%            f: sampling frequency
%            fsize: frame size in ms
%            fshift: frame shift in ms
%            p: 1-> plots
%               others -> calculates

%% if fsize and fshift are not given they are initialized to 30 and 10 respectively
if(nargin==2)
    fsize = 30;
    fshift = 10;
end

%% framewise parameters
spf = floor(fsize*f/1000);          % samples per each frame
sps = floor(fshift*f/1000);         % samples in one shift of frame
nof = floor((length(x)-spf)/sps);   % total no. of frames

%% calculating the stft values into image format
I = plot_STFT(x,f,fsize,fshift);
% I = 20*log(I);
mi = min(min(I));
ma = max(max(I));
I = mat2gray(I,[ma/1.5 mi/1.5]);
% for i=1:size(I,1)
%     T(i,:) = I(size(I,1)-i+1,:);
% end
% I = T;

%% plotting the signal for comparison
if(p==1)
figure;
subplot(2,1,1)
plot([1000/f:1000/f:1000*length(x)/f],x);     % plotting the speech signal     
title('\fontsize{16}\color{red}Speech Waveform');
xlim(1000*[1/f length(x)/f]);                 % setting limits for better visulisation 
xlabel('time in ms');
ylabel('Speech Signal');

%% displaying the image spectrogram
subplot(2,1,2)
a = [1000/f:1000/f:1000*length(x)/f];
b = linspace(1/f,f/2,size(I,2));
imagesc(a,b,I);
colormap(gray);
set(gca,'YDir','normal')
% set(gca,'Yscale','log','Ydir','normal');
% hold on;
% mx1 = [1:nof]*fshift;
% my1 = zeros(length(mx1),1);
% plot(mx1,my1);
% my2 = linspace(1/f,f/2,size(I,1));
% mx2 = zeros(length(my2),1);
% plot(mx2,my2);
% xlim([fshift fshift*nof]);                    
% ylim([1/f f/2]);
xlabel('time');
ylabel('frequency');
end