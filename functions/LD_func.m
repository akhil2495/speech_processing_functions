function l = LD_func(r0,R)
% Implementation of Levinson-Durbin method

p = length(R);
a = zeros(p);

a(1,1) = -R(1)/r0;
for i=2:p
    summ=0;
    sumn=0;
    for j=1:i-1
        summ = summ+a(i-j,i-1)*R(j);
        sumn = sumn+a(j,i-1)*R(j);
    end
    E = R(1)+sumn;
    k(i) = (R(i)+summ)/E;
    for j=1:i-1
        a(j,i) = a(j,i-1) - k(i)*a(i-j,i-1);
    end
    a(i,i) = -k(i);
end
l = a(:,p);
end