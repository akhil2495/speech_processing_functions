function val=gaussian(x,m,C)

val = exp(-((x-m)' *inv(C+0.25*eye(size(C)))*(x-m))/2)/(sqrt(det(C)));

% x=x';
% x=bsxfun(@minus,x,m);
% %x=x-repmat(m,1,size(x,2));
% % size(x)
% % size(C)
% val=exp(-sum(x'.*(C\(x))',2)/2)/(sqrt(det(C)));
% % val=val*10000000;
% %t=[];
% end 
% val = exp(-(x' .* (C\(x))')/2)/(sqrt(det(C)));