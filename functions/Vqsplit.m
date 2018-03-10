function [label,m] = Vqsplit(data,cb)
% VQsplit: performs the VQsplit algorithm on the data input
%  input : data -> Whole data on which K-means is to be done. data is of
%                  size dxN where d - dimension if data and N - total samples 
%          cb    -> no. of clusters, should be power of 2.
% output : label-> which sample belongs t which cluster
%          m    -> means

%% for data generation
color=hsv(cb);

[d,N] = size(data);
%% initialize vars
m=[];
label=[];
indices=cell(cb,1);

cbc=1;  %cb currently
m(:,1)=mean(data,2);
label=ones(1,N);
indices{1}=1:N;
figure(1)
while(cbc <= cb)
    hold on
    for i=1:cbc
        plot(data(1,indices{i}),data(2,indices{i}),'*','col',color(i,:));
        plot(m(1,i),m(2,i),'o','col',color(i,:),'Linewidth',3);
    end
    pause(0.2);
    if(cbc < cb)
        for j=1:cbc
            j+cbc
            [m(:,[j j+cbc]),ind]=k_means_func(data(:,indices{j}),m(:,j),color([j,j+cbc],:));
            indices{j+cbc}=indices{j}(ind{2});
            indices{j}=indices{j}(ind{1});
        end
    end
    cbc=2*cbc;
    display('split-completed');
    pause();
    if(cbc < cb)
        clf
    end
end
