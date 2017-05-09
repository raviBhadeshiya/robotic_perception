function [C R] = LinearPnP(X, x, K)

x = inv(K) * [x';ones(1,size(x,1))];
x = x';
A = [];
for i = 1 : size(x,1)
    A = [A; zeros(1,4) -[X(i,:) 1] x(i,2)*[X(i,:) 1];
            [X(i,:) 1] zeros(1,4) -x(i,1)*[X(i,:) 1]];
end

[u,d,v] = svd(A);
sol = v(:,end);
R = [sol(1) sol(2) sol(3);
     sol(5) sol(6) sol(7);
     sol(9) sol(10) sol(11)];
t = [sol(4);sol(8);sol(12)];
[u,d,v] = svd(R);
t = t/d(1,1);
R = u*v';
if det(R) < 0
    R = -R;
    t = -t;
end
C = -R'*t;