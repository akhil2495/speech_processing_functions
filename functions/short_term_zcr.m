function [z]=short_term_zcr(x,Fs,tf_size,tf_shift)
y=signum(x);
t=0:1:length(x)-1;
t=t/Fs;
f_size=floor(tf_size*Fs/1000)
f_shift=floor(tf_shift*Fs/1000)
%y=zeros(length(x),1);
z=[];
for i=1:ceil(length(x)/f_shift)
    if(length(x)<(i-1)*f_shift+f_size)
        i;
        break;
    end
    z(i)=0;
    for j=(i-1)*f_shift+1:(i-1)*f_shift+f_size-1
        if(y(j)*y(j+1)==-1)
            z(i)=z(i)+1;
            i;
        end
    end
end
z=z/f_size;
ty=repmat(tf_shift/1000,1,length(z));
ty(1)=tf_size/2000;
ty=cumsum(ty);
size(ty);
size(z);
figure;
subplot(2,1,1)
plot(t,x)
xlim([0 ceil(length(x)/Fs)]);
subplot(2,1,2)
plot(ty,z)
xlim([0 ceil(length(x)/Fs)]);
end