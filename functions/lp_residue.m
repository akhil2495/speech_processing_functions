function r = lp_residue(x,f,fsize,fshift,p,p_lot)

%% make sure fsize and fshift are not uninitialized
if(nargin<5)
    fsize = 30;
    fshift = 10;
end

%% initialize frame parameters
spf = floor(fsize*f/1000);                    % no. of samples in a frame 
sps = floor(fshift*f/1000);                    % no. of samples shifted from frame to frame
nof = floor(length(x)/sps);      % total no. of frames 

%% calculating the coefficients
[ac,a] = mylpc(x,f,fsize,fshift,p);

%% calculating residue signal
% for i = 1:nof
%     for j = 1:spf
%         n = sps*(i-1)+j+1;        
%         summ = 0;
%         for k = 2:p
%             summ = summ + a(k)*x(n-k);
%         end
%         e(n) = x(n) + summ;
%     end
% end

for i = p+1:length(x)
    i
    fr = floor(i/sps)+1
    if(fr>size(a,2))
        break;
    end
    summ = 0;
    for k = 2:p
        summ = summ + a(k,fr)*x(i-k);
    end
    e(i) = x(i) + summ;
end
r = e;

%% plotting residual signal
if(p_lot==1)
figure;
t = [1:length(r)]/f;
t1 = [1:length(x)]/f;
s1 = zeros(length(x),1);
s2 = zeros(length(r),1);
fr = 50;
s1(sps*(fr-1)+1:sps*(fr-1)+spf) = 0.1;
s2(sps*(fr-1)+1:sps*(fr-1)+spf) = 0.2;
subplot(2,1,1)
plot(t1,x);
xlim([1 length(x)]/f)
hold on;
plot(t1,s1,'r');
title('signal');
subplot(2,1,2)
plot(t,r);
hold on;
plot(t,s2,'r');
title('residual signal');
xlim([1/f length(r)/f]);
end