clear all; clc;
addpath('functions')
% ************************
% BLP code
% ************************

load 'tempdata/simulatedData_v1'
data.k = size(data.X_j,2);

% Q: should we use the same draws that have generated the data?

% initial guess for parameters
gammapar = ones(data.ntaste,1);
c_j = ones(data.nmovies,data.ntaste);
mu = ones(data.nmarket,data.ntaste);
sigma = ones(data.nmarket,data.ntaste);
betapar = ones(data.k,1);
zeta_j = ones(data.nmovies,1);

% store parameters in two matrices
theta2 = [mu' sigma' c_j' gammapar]; % - they are all of dimension 'something' x ntaste
theta1 = [  betapar' zeta_j'];

%data.options = optimset('Display','iter','PlotFcns',@optimplotfval);
data.options = optimset('Display','none');

% *****************************************
% ESTIMATION
% *****************************************

[Params, ff, Exitflag,output] = fminsearch(@(theta2) outerObj(theta1,theta2,data),theta2,data.options);
% to do
% - fminsearch options / speed up
% - check continuity
% - change theta1/theta2 (now slightly different compared to doc)
% - contstrain var > 0

bla 
% *****************************************
% test the functions using the true values:
% *****************************************

theta2S = [unobsData.mu' unobsData.sigma' unobsData.c_j' unobsData.gammapar];
theta1S = zeros(data.nmovies,1);
theta1S(:,1) = unobsData.zeta_j;
theta1S(1:data.k,2) = unobsData.betapar;


mu_ijcS = mufunc_v1(theta2S,data);
delta_jc = deltaval_v0(theta1S,data);

a = ind_sh_v1(delta_jc,mu_ijcS,data);
b = mktsh_v1(delta_jc, mu_ijcS,data);

innerObj(theta1S,mu_ijcS,data); % should be zero!

% test the inner loop
mu_ijc = mufunc_v1(theta2,data);
f= fminsearch(@(theta1)innerObj(theta1,mu_ijc,data),theta1);

% test the outerloop
ff = fminsearch(@(theta2) outerObj(theta1,theta2,data),theta2);



