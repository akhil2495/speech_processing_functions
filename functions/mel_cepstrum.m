function [B,M] = mel_cepstrum(x,f,fsize,fshift,nb,p)
% mel_cepstrum: calculates the mel cepstrum matrix and plots this 
%        input: 
%               x - discrete time speech signal
%               f - sampling frequency in Hz
%               fsize - framesize in ms
%               fshift - frameshift in ms
%               nb - no. of banks should be between 25-40 else nb=25
%               p - specifies whether to plot or only calculate
%                   1 -> plot
%                   other -> calculate
%       output:
%               C - matrix containing cepstrum 256 cepstrum values for each
%                   frame
% Author : Akhil Babu Manam

%% initializing if fsize and fshift are not given
if (nargin<=2)
    fsize = 30;
    fshift = 10;
end

%% setting number of filterbanks if nb is not in limits(25,40)
if(nb<25)
    nb = 30;
end
if(nb>40)
    nb = 30;
end

%% calculating filter bank parameters
% mapping the limits of f(0-4000) into mel scale
fm0 = fmel(0);
fm4000 = fmel(4000);

% calculating fl,fu and fc
for i=1:nb
    fml(i) = fm4000*(i-1)/(nb+1);
    fmc(i) = fm4000*i/(nb+1);
    fmu(i) = fm4000*(i+1)/(nb+1);
end

% mapping the filterbank limits in Hz scale
for i=1:nb
    fhl(i) = fhz(fml(i));
    fhc(i) = fhz(fmc(i));
    fhu(i) = fhz(fmu(i));
end

%% calculating STFT of all frames
% calculating framewise parameters
spf = floor(fsize*f/1000);          % samples per each frame
sps = floor(fshift*f/1000);         % samples in one shift of frame
nof = floor((length(x)-spf)/sps);   % total no. of frames

% S = plot_STFT(x,f,fsize,fshift);
for i=1:nof
    T(:,i) = abs(fft([x((i-1)*sps+1:(i-1)*sps+spf);zeros(512-spf,1)]',512));
    S(:,i) = T(1:size(T,1)/2,i);
end

% calculating coefficients
for i=1:nof
    B(:,i) = calc_yi(S(:,i),f,fhl,fhc,fhu);
    M(:,i) = dct(B(:,i));
%     M(:,i) = B(1:size(B,1)/2,i));
end

%% plotting cepstrum of the signal
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

    a = [1000/f:1000/f:size(M,1)*1000/f];
    subplot(2,1,2)
    plot(a,M(:,j));
    title('\fontsize{14}\color{red}Cepstrum plot')
    xlim([1000/f size(M,1)*1000/f]);
    xlabel('quefrence');
    ylabel('cepstrum');
    pause(0.5);
end
end

end

function fm = fmel(f)
fm = 2595*(log10(1+(f/700)));
end


function f = fhz(fmel)
f = 700*(10^(fmel/2595)-1);
end

function yi = calc_yi(Si,f,fhl,fhc,fhu)
% conveting fhl,fhc,fhu into integers on Si
pl = floor(2*fhl*length(Si)/f)+1;
pc = floor(2*fhc*length(Si)/f)+1;
pu = floor(2*fhu*length(Si)/f)+1;
yi = zeros(length(Si),1);
for i=1:length(fhc)
    i;
    H = [];
    H = filt([pl(i):pu(i)]*(f/(2*length(Si))),fhl(i),fhc(i),fhu(i));
    for j=pl(i):pu(i)
        yi(pc(i)) = yi(pc(i))+(H(j-pl(i)+1)*(Si(j)));
    end
    yi(pc(i))=log10(yi(pc(i)));
end
% for i=1:length(Si)
%     if(yi(i)==0)
%         yi(i)=-100;
%     end
% end
end

function Hi = filt(f,fl,fc,fu)
Hi = zeros(length(f),1);
for i=1:length(f)
    if(f(i)<fl)
        Hi(i)=0;
    end
    if(f(i)>fl)
        if(f(i)<=fc)
            Hi(i) = (f(i)-fl)/(fc-fl);
        end
    end
    if(f(i)<fu)
        if(f(i)>fc)
            Hi(i) = (f(i)-fu)/(fc-fu);
        end
    end
    if(f(i)>fu)
        Hi(i)=0;
    end
end
end