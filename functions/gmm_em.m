function [w,m,C] = gmm_em(data,nc,miter,list)
%gmm_em : performs the em algorithm for Gaussian mixture model generation
%  input : data -> Whole data on which K-means is to be done. data is of
%                  size dxN where d - dimension if data and N - total samples 
%          nc   -> no. of clusters
%          miter-> maximum iterations
%          list -> 
% output : label-> which sample belongs t which cluster
%          m    -> means

[d,N]=size(data);
%% initialization of var
C=zeros(d,d,nc);
[label,m]=K_means(data,nc,10);
for i=1:nc
    w(i)=sum(label==i)/length(label);
    C(:,:,i)=diag(diag(cov(data(:,label==i)')));
end

% w=rand(1,nc);
% w=w/norm(w);
% m=rand(d,nc);
% C=rand(d,d,nc);

%% initialization of GMM parameters
pXp=0;
pX=1;
diff=pX-pXp;
iter=0;
while((iter<miter) && (diff>0.001))
    iter=iter+1;
for i=1:nc
    i
    % w update
    sumw=0;
    for j=1:N
        post(j)=posterior(data(:,j),w,m(:,i),C(:,:,i),nc);
        sumw=sumw+post(j);
    end
    w(i)=sumw/N;
    
    % m update
    summ=zeros(d,1);
    for j=1:N
        summ=summ+post(j)*data(:,j);
    end
    m(:,i)=summ/sumw;
    
    % sigma update
    for k=1:d
        sumsig=0;
        for j=1:N
            sumsig=sumsig+post(j)*data(:,j)'*data(:,j);
        end
        sigma(k,i)=(sumsig/sumw)-m(:,i)'*m(:,i);
    end
    C=zeros(d,d,nc);
    for k=1:d
        C(k,k,i)=sigma(k,i);
    end
end

%% checking factor for convergence test
pXp=pX;
for j=1:N
    sump=0;
    for i=1:nc
        sump=sump+post(j)*w(i);
    end
    pxt=sump;
    pX=pX+pxt;
end
pX=pX/N;
if(pX-pXp<0.001)
    break;
end
end

figure;
hold on;
for i=1:nc
    plot(data(1,label==i),data(2,label==i),'*','col',list(i,:));
    plot(m(1,i),m(2,i),'o','col',list(i,:),'Linewidth',3);
end            
    