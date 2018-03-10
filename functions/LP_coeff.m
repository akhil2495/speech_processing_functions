function [f4]=LP_coeff( R,Frame_size,p);
[row col]=size(R);
A=zeros(row,p);
Ep=[];
for f_no=1:row
    a=zeros(p,Frame_size);
    k=zeros(p,1);
    E=zeros(p,1);
    k(1,1)=R(1+1)/R(1);        % R(1)/R(0)
    a(1,1)=-k(1,1);
    temp_k=0;
    temp_E=R(f_no, 1);
    if p>=2
        E(1,1)=R(f_no, 1);
        for i=2:p
            
            
               % calculating previous E
%             for j=1:i-1
%                 E(i-1,1)=E(i-1,1)+a(i-1,j)*R( f_no, 1+j);
%             end
           
            k(i,1)=R( f_no, 1+i);  
            for j=1:i-1
                k(i,1)=k(i,1)+a(i-1,i-j)*R( f_no, 1+j);
                
            end
            
             E(i-1,1)=temp_E-(temp_k*k(i,1));
            
            k(i,1)=k(i,1)/ E(i-1,1);
            
            for j=1:i-1
                if j==1
                    a(i,j)=a(i-1,j)-k(i,1);  % a0=1 assumed
                end
                if j~=1
                    a(i,j)=a(i-1,j)-k(i,1)*a(i-1,j-1);
                end
            end
            
            a(i,i)=-k(i,1);
            temp_k=k(i,1);
            temp_E=E(i-1,1);
            Ep(f_no,i)=temp_E/R(f_no,1);
        end
        
    end
    
    for i=1:p
        A(f_no,i)=a(p,i);
    end
end
f4=A;
f=Ep;
end
