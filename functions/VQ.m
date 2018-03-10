clear;clc;
data=10*randn(2,10000);
%% Vector-Quantization
CB_f=8; % must be a power of 2
list=hsv(CB_f);
[dim,T]=size(data);
indices=cell(CB_f,1);
m=zeros(dim,CB_f);
CB_size=1;
m(:,1)=mean(data,2);
indices{1}=1:T;
while(CB_size <= CB_f)
    CB_size
    figure(1)
    hold on
    for i=1:CB_size
        plot(data(1,indices{i}),data(2,indices{i}),'*','col',list(i,:));
        plot(m(1,i),m(2,i),'o','col',list(i,:),'Linewidth',3);
    end
    pause(0.2);
    if(CB_size < CB_f)
        for j=1:CB_size
            [m(:,[j j+CB_size]),ind]=k_means_func(data(:,indices{j}),m(:,j),list([j,j+CB_size],:));
            indices{j+CB_size}=indices{j}(ind{2});
            indices{j}=indices{j}(ind{1});
        end
    end
    CB_size=2*CB_size;
    display('split-completed');
    pause
    if(CB_size < CB_f)
        clf
    end
end
    
    


