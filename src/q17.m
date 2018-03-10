[x1,f] = wavread('C:\Users\AkhilBabu\Desktop\8th sem\EE628_speech_technology\assignment_work\Akhil_rec\recordings\rec2\vowels\k-a-k.wav');
x = resample(x1,8000,f);
x = x/max(x);
f = 8000;
fsize = 30;
fshift = 10;
spf = floor(f*fsize/1000);
sps = floor(f*fshift/1000);
fr = 60;
xfr = x((fr-1)*sps+1:(fr-1)*sps+spf);
y = zeros(1,length(x));
y((fr-1)*sps+1:(fr-1)*sps+spf) = 1;

diff_win(xfr,f);

%% plot fr for visualisation:
% subplot(212)
% plot(x);
% hold on;
% plot(y,'r');