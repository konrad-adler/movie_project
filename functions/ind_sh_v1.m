function f = ind_sh_v1(delta_jc,mu_ijc,data)
% This function computes the "individual" probabilities of choosing each brand
% Written by Aviv Nevo, May 1998.

% INPUT: 
% eps_ij:   n x nmovies x nmarket
% mval:     nmovies x nmarket

delta0_jc = repmat(delta_jc,[1 1 data.n]);  % replicate per individual
delta0_jc = permute(delta0_jc,[3 1 2]); % change order of dimensions

util_ij = exp(mu_ijc + delta0_jc);
util_i = sum(util_ij,2); % sum along the nmovies dimension
choiceProb = util_ij./(1+ repmat(util_i,[1 data.nmovies 1]));

f = choiceProb;