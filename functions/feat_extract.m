function F = feat_extract(x,f,fsize,fshift,type)
% feat_extract: extracts the features of the speech signal whatever
%               specified
%        input: 
%               x - digital speech signal
%               f - sampling frequency
%               fsize - frame size in ms
%               fshift - frame shift in ms
%               type - 'mel' or 'fft'
%                      'mel' -> calculates Mel Frequency Cepstral Coefficients
%                      'fft' -> calculates normal Cepstral Coefficients
%       output:
%               F - matrix containing 39 cepstral coefficients of each
%                   frame
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

%% calling static cepstrum values from function
if(type == 'mel')
    C = mel_cepstrum(x,f,fsize,fshift,25,0);
end
if(type == 'fft')
    C = fft_cepstrum(x,f,fsize,fshift,0);
end

C1 = [zeros(13,2),C(1:13,:),zeros(13,2)];

%% calculating delta coefficients
D = zeros(size(C(1:13,:)));
for i = 3:size(C1,2)-2
    for k = -2:1:2
        D(:,i-2) = D(:,i-2)+k*C1(:,i+k)/4;
    end
end

D1 = [zeros(13,2),D,zeros(13,2)];

%% calculating delta-delta coefficients
DD = zeros(size(D));
for i = 3:size(C1,2)-2
    for k = -2:1:2
        DD(:,i-2) = DD(:,i-2)+k*C1(:,i+k)/4;
    end
end

%% augmenting all values
F = [C(1:13,:);D;DD];
end