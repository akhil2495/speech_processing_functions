function p = posterior(x,w,m,C,nc)

sumw=0;
for i=1:nc
    sumw=sumw+gaussian(x,m,C)*w(i);
end
p=(w(i)*gaussian(x,m,C))/sumw;

end