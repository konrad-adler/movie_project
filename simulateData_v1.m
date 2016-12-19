clear all; clc;
% **************************************************
% this code generates training data for our BLP code
% **************************************************
 
% hints to have fewer movies with zero market shares
%- decrease the variance of the movie characteristics
%- increase the variance of the consumer taste shocks

data.n = 1000;    % individuals per market
data.nmarket = 2;
data.nmovies = 15; 
data.ntaste = 1; % dimension of taste space


% generate movies observables data
data.X_j = [...
round(unifrnd(80,120,data.nmovies,1)) ...% some running length
binornd(1,0.55,data.nmovies,1) ...% some dummy
exprnd(10,data.nmovies,1)]; % budget

% generate movies unobservable data
unobsData.zeta_j = normrnd(2,0.25,data.nmovies,1);
unobsData.c_j = normrnd(0,1,data.nmovies,data.ntaste);

% fix coefficients
unobsData.betapar = [0.0005,0.0075, 0.0055];
unobsData.gammapar = normrnd(0,1,data.ntaste,1);
unobsData.mu = zeros(data.nmarket,data.ntaste);
unobsData.sigma = unifrnd(0,2,data.nmarket,data.ntaste);

% generate instruments
%???

% **************************************
% simulate utility for each country
% and compute market shares
% **************************************

s_jc = ones(data.nmarket,data.nmovies)*NaN;
% draw consumer taste shocks from standard normal    
ctilde_i = normrnd(0,1,data.n,data.ntaste,data.nmarket);

for c = 1:data.nmarket
    %c = 1;
    
    % make consumer taste shock market-specific
    c_i = ctilde_i(:,:,c).*repmat(unobsData.sigma(c,:),data.n,1) ...
        + repmat(unobsData.mu(c,:),data.n,1);
  
    
    % compute country-movie taste factor
    for j = 1:data.nmovies
        mu_ijc(:,j) = (repmat(unobsData.c_j(j,:),data.n,1)- c_i).^2*unobsData.gammapar; %normrnd(0,1,n,1); %
    end
    mu_ijc0{c} = mu_ijc;
    
    % compute utility
    delta_j = data.X_j*unobsData.betapar' + unobsData.zeta_j; % mean-utility part
    util_ij = repmat(delta_j',data.n,1) + mu_ijc;
    
    choiceProb = exp(util_ij)./repmat((1 + sum(exp(util_ij),2)),1,data.nmovies);
    choiceProb0{c} = choiceProb;
     
    % compute market shares (after integrating over extreme value errors)
    s_jc(c,:)= (1/data.n)*sum(choiceProb);
    
end

data.s_jc = s_jc;
data.ctilde_i = ctilde_i;
unobsData.delta_j = delta_j;
unobsData.mu_ijc = mu_ijc0;
unobsData.choiceProb = choiceProb0;

% save the data
save('tempdata/simulatedData_v1','data','unobsData') 








