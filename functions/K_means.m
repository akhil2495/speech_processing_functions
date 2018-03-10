function [label,m] = K_means(data,k,miter)
% K_means: implements the K_means algorithm for a dataset.
%  input : data -> Whole data on which K-means is to be done. data is of
%                  size dxN where d - dimension if data and N - total samples 
%          k    -> no. of clusters
%          miter-> maximum iterations
%          list -> 
% output : label-> which sample belongs to which cluster
%          m    -> means
% Author : Akhil Babu Manam

%% for data visualisation
color=hsv(k);

[d,N] = size(data);  
% N=no.of samples, d=dimension of data points(features)

%% initialize random vectors from data as means
m = [];                 % k mean vectors
s = randperm(k);        
m = data(:,s);            % random means

%% initialize 
D=Inf;                  % sum of dist prev iter
d_p=Inf;                % change in D and D_n
D_n=0;                  % sum of dist current 
label = zeros(1,N);     % contains cluster number of sample

%%
iter = 1;
while(iter<miter)% && D-D_n>0.0001 && D-D_n<=d_p)
    d_p=D-D_n;
    if(iter==1)
        D=Inf;
    else
        D=D_n;
    end
    D_n=0;
    %% calculate distances and choose minimum
    for i=1:N
        temp=m-repmat(data(:,i),1,k); 
        [d,ind]=min(sum(temp.*temp));
        label(i)=ind;
        D_n=D_n+d;
    end 
    
    % mean update
    figure(1)
    hold on;
    for i=1:k
        m(:,i)=mean(data(:,label==i),2);
        plot(data(1,label==i),data(2,label==i),'*','col',color(i,:));
        plot(m(1,i),m(2,i),'o','col',color(i,:),'Linewidth',3);
    end
    hold off;
    iter=iter+1;
    delta=D-D_n
    
% pause
if(iter<=miter && D-D_n>0.0001 && D-D_n<=d_p)
    clf;    % clears image
end
end
end