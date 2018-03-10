function [m,indices_temp]=k_means_func(data,m,list)
[dim,T]=size(data);
m=m*[(1-0.02) (1+0.02)];

max_iter=10;
D=Inf;
delta_prev=Inf;
D_n=0;
iter=1;
indices=cell(1,2);
for i=1:2
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
        temp=m-repmat(data(:,i),1,2);
        [d,ind]=min(sum(temp.*temp));
        indices{ind}=[indices{ind} i];
        D_n=D_n+d;
    end
    indices_temp=indices;
    % mean update
    for i=1:2
        m(:,i)=mean(data(:,indices{i}),2);
        plot(data(1,indices{i}),data(2,indices{i}),'*','col',list(i,:));
        plot(m(1,i),m(2,i),'o','col',list(i,:),'Linewidth',3);
        indices{i}=[];
    end
    iter=iter+1;
%     delta=D-D_n
    
pause(0.5)
% close

end


end