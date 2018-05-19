function u = exp4_RSF(u0, Img, Ksigma, KI, KONE, P1, P2, timestep, epsilon, lambda1, lambda2, rho1, rho2, pi1, pi2, mask1, mask2, nu, mu, numIter)
u = u0;
for j = 1:numIter
    u = NeumannBoundCond(u);
    K = curvature_central(u);
    
    DrcU = (epsilon/pi)./(epsilon^2. + u.^2);
    [f1, f2] = localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon);
    
    s1 = lambda1.*rho1.*(P1) .* f1 .^2 - lambda2.*rho2.*(P2) .* f2 .^ 2;
    s2 = lambda1.*rho1.*(P1) .* f1 - lambda2.*rho2.*(P2) .* f2;
%     dataForce = (lambda1 - lambda2) * KONE .* Img .* Img + conv2(s1, Ksigma, 'same') - 2.* Img .* conv2(s2, Ksigma, 'same');
    dataForce = (lambda1.*rho1.*(P1) - lambda2.*rho2.*(P2)) .* KONE .* Img .* Img + conv2(s1, Ksigma, 'same') - 2.* Img .* conv2(s2, Ksigma, 'same');
    
    D = -DrcU .* (pi1 .* (mask1) - pi2 .* (mask2));
    
    A = -DrcU .* dataForce;
    P = mu * (4 * del2(u) - K);
    L = nu .* DrcU .* K;
    u = u + timestep * (L + P + A + D);
    
end


function [f1, f2]= localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon)
% compute f1 and f2
Hu=0.5*(1+(2/pi)*atan(u./epsilon));                     % eq.(8)
I=Img.*Hu;
c1=conv2(Hu,Ksigma,'same');                             
c2=conv2(I,Ksigma,'same');                              % the numerator of eq.(14) for i = 1
f1=c2./(c1);                                            % compute f1 according to eq.(14) for i = 1
f2=(KI-c2)./(KONE-c1);  

function g = NeumannBoundCond(f)
% Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);  

function k = curvature_central(u)                       
% compute curvature
[ux,uy] = gradient(u);                                  
normDu = sqrt(ux.^2+uy.^2+1e-10);                       % the norm of the gradient plus a small possitive number 
                                                        % to avoid division by zero in the following computation.
Nx = ux./normDu;                                       
Ny = uy./normDu;
[nxx,junk] = gradient(Nx);                              
[junk,nyy] = gradient(Ny);                              
k = nxx+nyy;                                            % compute divergence