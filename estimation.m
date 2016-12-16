clear all; clc;
addpath('functions')
% ************************
% BLP code
% ************************
global n nmovies nmarket ntaste ctilde_i s_jc X_j theta1...
    IV invA

load 'tempdata\simulatedData'


% star to save the "true" values
betaparStar = betapar;
gammaparStar = gammapar;
zeta_jStar = zeta_j;
muStar = mu;
sigmaStar = sigma;
c_jStar = c_j;

% question: should we use the same draws that have generated the data?

% initial guess
gammapar = ones(ntaste,1);
c_j = ones(nmovies,ntaste);
mu = zeros(nmarket,ntaste);
sigma = ones(nmarket,ntaste);

% change format of X_j matrix
X_j = repmat(X_j,nmarket,1); % could change this if we have market-level
                             % observables
% create weight matrix
ninstr = 300;
IV = normrnd(0,1,[nmovies*nmarket ninstr]); %[iv(:,2:21) x1(:,2:25)];
invA = inv([IV'*IV]);

% store all in one matrix
% - they are all of dimension 'something' x ntaste
theta2 = [mu' sigma' c_j' gammapar];
theta2Star = [muStar' sigmaStar' c_jStar' gammaparStar];

% initial guess for mean utility 
% (see Nevo code for a better one, once we have instruments!)
oldt2 = theta2;
mvalold = ones(nmarket,nmovies);
%mvalold = repmat( exp(X_j*betaparStar' + zeta_jStar),1,nmarket)'+0.5;
save('tempdata\mvalold','mvalold', 'oldt2')
clear mvalold oldt2


% the following line computes the estimates using a simplex search method
theta2 = fminsearch('gmmobj_v0',theta2) % previously "fmins"




%end of code 
bla 

% *******************************************************************
% test the delta function: meanval_v0
% *******************************************************************
logmval = meanval_v0(theta2);
% note: it did not/ only very slowly converge when the simulated data had a
% lot of zero market shares

% *******************************************************************
% just to test the following functions: ind_sh_v0,mktsh_v0,mufunc_v0
% this should give the same market shares
% as from the simulation
% *******************************************************************
eps_ij = mufunc_v0(theta2Star); 
expeps_ij = exp(eps_ij);
expmval = repmat( exp(X_j*betaparStar' + zeta_jStar),1,nmarket)'; % note: in Nevo mean utility is jc, but in our case it just j (the same across markets)
compareTo_s_jc = mktsh_v0(expmval, expeps_ij);
