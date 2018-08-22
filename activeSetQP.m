function [x,p,lambda,w]=activeSetQP(G,c,A,b,x0)
n=size(G,1);
m=size(A,1);
w=setdiff(1:m,find(b-A*x0));
x=x0;
for q=1:10
    r=length(w);
    B=zeros(r,n);
for i=1:r
    B(i,:)=A(w(i),:);
end
g=G*x+c;
k=[G -B';B zeros(r,r)]\[(-g);zeros(r,1)];
p=k(1:n,1);
lambda=k((n+1):size(k),1);
if p==0
    if lambda>=0
        break;
    else
        [nm,idx]=min(lambda);
        w(idx)=[];
    end
else
    s=zeros(1,m);
    f=m;
    while f>=1
        t=0;
       for j=1:length(w)
           if f==w(j)
               t=t+1; 
           end
       end
       if (t==0) && (p'*A(f,:)'<0) 
           s(f)=(b(f)-x'*A(f,:)')/(p'*A(f,:)');
           alfa=min(1,s(f));
       else
           s(f)=[];
       end
       f=f-1;
    end
    x=x+alfa*p;
    [nm,idx]=min(s);
    if nm<=1
     w(length(w)+1)=idx;
      for i=1:length(w)-1
         for j=1:i
           if w(j)>w(i+1)
             cts=w(i+1);
             w(i+1)=w(j);
             w(j)=cts;
           end
         end
      end
    end
  end
end
end