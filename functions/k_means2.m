clear;clc;
data=10*rand(2,5000);
% data=10*randn(2,1000);
% data = random('chi2',2,2,10000);  
% data = random('chi2',2,2,10000)+rand(2,10000)+randn(2,10000);  

%% k-means
K=4;
list=hsv(K);
indices=cell(K,1);
[dim,T]=size(data);
temp=randperm(T);
max_iter=50;
D=Inf;
delta_prev=Inf;
D_n=0;
iter=1;
% initialization
m=data(:,temp(1:K));
for i=1:K
    indices{i}=[];
end
while(iter<=max_iter && D-D_n>0.0001 && D-D_n<=delta_prev)
    delta_prev=D-D_n;
    if(iter==1)
        D=Inf;
    else
        D=D_n;
    end
    D_n=0;
    for i=1:T
        i;
        temp=m-repmat(data(:,i),1,K);
        [d,ind]=min(sum(temp.*temp));
        indices{ind}=[indices{ind} i];
        D_n=D_n+d;
    end
    % mean update
    figure(1)
    hold on;
    for i=1:K
        m(:,i)=mean(data(:,indices{i}),2);
        plot(data(1,indices{i}),data(2,indices{i}),'*','col',list(i,:));
        plot(m(1,i),m(2,i),'o','col',list(i,:),'Linewidth',3);
        indices{i}=[];
    end
    hold off;
    iter=iter+1;
    delta=D-D_n
    
pause
if(iter<=max_iter && D-D_n>0.0001 && D-D_n<=delta_prev)
    clf;
end
% close

end
    
    


