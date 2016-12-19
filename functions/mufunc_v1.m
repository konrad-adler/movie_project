function f = mufunc_v1(theta2,data)


% *********************************************************
% this function computes the non-linear part of the utility
%
% given a guess for: gammapar, c_j
% given draws for: ctilde_i
% *********************************************************

mu = theta2(:,1:data.nmarket)';
sigma = theta2(:,data.nmarket+1:2*data.nmarket)';
c_j = theta2(:,2*data.nmarket+1:2*data.nmarket+data.nmovies)';
gammapar = theta2(:,end);


mu_ijc = ones(data.n,data.nmovies,data.nmarket)*NaN;

for c = 1:data.nmarket
    c_i = data.ctilde_i(:,:,c).*repmat(sigma(c,:),data.n,1) + repmat(mu(c,:),data.n,1);
    for j = 1:data.nmovies
        mu_ijc(:,j,c) = (repmat(c_j(j,:),data.n,1)- c_i).^2*gammapar;      
    end
end

f = mu_ijc;