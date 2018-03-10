function [y] = signum(x)
% signum : calculates the signum of the vector x and returns the value in y

%% calculating the value of signum(x)
y = [];
for i =1:length(x)
    if(x(i)>=0)
        y(i) = 1;
    else
        y(i) = -1;
    end
end
end