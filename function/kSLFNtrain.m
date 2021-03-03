
function [OutputWeight,Y] = kSLFNtrain (Omega_train, T, C,alpha,K)
n = size(T,1);


OutputWeight=((Omega_train+alpha*K*Omega_train+speye(n)/C)\(T));

Y=(Omega_train * OutputWeight);


end

