function [A, b] = GAT(S, R)
% 运行效率低下，待优化
[m1, n1] = size(S);
[m2, n2] = size(R);
mD = zeros(n1, n2);
for i = 1:n1
    for j = 1:n2
        mD(i,j) = norm(S(:,i) - R(:,j));
    end
end
mins = min(mD,[],2);
minr = min(mD);
D = 0.5 * (mean(mins) + mean(minr));
t = 0;
M = zeros(2,2);
Q = zeros(2,2);
w = zeros(1,2);
k = zeros(2,1);
p = zeros(2,1);
for i = 1:n1
    for j = 1:n2
        mu = exp(-(mD(i,j)-mins(i))./D);
        v = exp(-(mD(i,j)-minr(j))./D);
        rho = mu/n1 + v/n2;
        t = t + rho;
        M = M + rho.*(S(:,i)*S(:,i)');
        Q = Q + rho.*(R(:,j)*S(:,i)');
        w = w + rho.*S(:,i)';
        k = k + rho.*S(:,i);
        p = p + rho.*R(:,j);
    end
end
A = (t*Q - p*w)/(t*M - k*w);
b = (p - A*k)/t;
end
