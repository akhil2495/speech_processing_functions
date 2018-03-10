[x,f] = wavread('C:\Users\AkhilBabu\Desktop\8th sem\EE628_speech_technology\assignment_work\Akhil_rec\recordings\rec2\vowels\k-a-k.wav');
y = resample(x,8000,44100);

fsize = 30;
fshift = 10;
%% initialize frame parameters
spf = floor(fsize*f/1000);                     % no. of samples in a frame 
sps = floor(fshift*f/1000);                    % no. of samples shifted from frame to frame
nof = floor(length(x)/sps);      % total no. of frames 

fr = 50;
fr1 = 43;
xframe = (sps*(fr-1)+1:sps*(fr-1)+spf);
ac = cell(15,1);
a = cell(15,1);

R = autocorr(xframe,length(xframe)-1);

for p=1:15
    p
    [lc,l] = mylpc(x,f,fsize,fshift,p);
    ac{p} = lc(:,fr);
    a{p} = l(:,fr);
    %%
    a{p} = lpc(xframe,p);
    summ=0;
    for j=1:p
        summ=summ+a{p}(j)*(R(j+1)/R(1));
    end
    e(p) = 1+summ;
end

figure;
plot(e);

% %% plot
% figure;
% % t = [1:length(r)]/f;
% t1 = [1:length(x)]/f;
% s1 = zeros(length(x),1);
% % s2 = zeros(length(r),1);
% s1(sps*(fr-1)+1:sps*(fr-1)+spf) = 0.1;
% % s2(sps*(fr-1)+1:sps*(fr-1)+spf) = 0.2;
% subplot(2,1,1)
% plot(t1,x);
% hold on;
% plot(t1,s1,'r');
% title('signal');

 
