clear all; clc;
% **************************************************
% this code generates training data for our BLP code
% **************************************************
 
% hints to have fewer movies with zero market shares
%- decrease the variance of the movie characteristics
%- increase the variance of the consumer taste shocks

n = 100;    % individuals per market
nmarket = 10;
nmovies = 20; 
ntaste = 5; % dimension of taste space


% generate movies observables data
X_j = [...
round(unifrnd(80,120,nmovies,1)) ...% some running length
binornd(1,0.55,nmovies,1) ...% some dummy
exprnd(10,nmovies,1)]; % budget

% generate movies unobservable data
zeta_j = normrnd(2,0.25,nmovies,1);
c_j = normrnd(0,1,nmovies,ntaste);

% fix coefficients
betapar = [0.0005,0.0075, 0.0055];
gammapar = normrnd(0,1,ntaste,1);
mu = zeros(nmarket,ntaste);
sigma = unifrnd(0,2,nmarket,ntaste);

% generate instruments
%???

% **************************************
% simulate utility for each country
% and compute market shares
% **************************************

s_jc = ones(nmarket,nmovies)*NaN;
% draw consumer taste shocks from standard normal    
ctilde_i = normrnd(0,1,n,ntaste,nmarket);

for c = 1:nmarket
    %c = 1;
    
    % make consumer taste shock market-specific
    c_i = ctilde_i(:,:,c).*repmat(sigma(c,:),n,1) + repmat(mu(c,:),n,1);
  
    
    % compute country-movie taste factor
    for j = 1:nmovies
        eps_ij(:,j) = (repmat(c_j(j,:),n,1)- c_i).^2*gammapar; %normrnd(0,1,n,1); %
    end
    % TO DO: check if eps_ij part is mean zero
    
    % compute utility
    delta_j = X_j*betapar' + zeta_j; % mean-utility part
    util_ij = repmat(delta_j',n,1) + eps_ij;
    
    choiceProb = exp(util_ij)./repmat((1 + sum(exp(util_ij),2)),1,nmovies);
    
    % compute market shares (after integrating over extreme value errors)
    s_jc(c,:)= (1/n)*sum(choiceProb);
    
end


% save the data
save('tempdata/simulatedData','X_j','zeta_j','c_j','betapar','gammapar','mu',...
'sigma','s_jc','ctilde_i','n','nmarket','nmovies','ntaste') 








