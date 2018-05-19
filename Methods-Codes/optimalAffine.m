function [affined_mask] = optimalAffine(imask, iprobmap, mask)
fun = @(x)objectFun(x, imask, iprobmap);
options = optimoptions('particleswarm','SwarmSize',50, 'MaxIterations', 50, 'MinNeighborsFraction', 1);
lb = [0 0 0 0 -300 -300];
ub = [300 300 300 300 300];
[x, fval, exitflag] = particleswarm(fun, 6, lb, ub, options);
T = [x(1) x(2) 0; x(3) x(4) 0; x(5) x(6) 1];
tform = maketform('affine' ,T);
affined_mask = imtransform(tform, mask);
end

function O = objectFun(x, mask, probmap)
A = [x(1) x(2); x(3) x(4)];
b = [x(5); x(6)];
affined = A * mask + b;
[m1, n1] = size(affined);
[m2, n2] = size(probmap);
D = zeros(n1, n2);
for i = 1:n1
    for j = 1:n2
        D(i,j) = norm(affined(:,i) - probmap(:,j));
    end
end
mina = min(D,[],2);
minp = min(D);
O = mean(mina) + mean(minp);
end