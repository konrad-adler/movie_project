function f = mktsh_v1(delta_jc, mu_ijc,data)
% This function computes the market share for each product
% Written by Aviv Nevo, May 1998.


% ind_sh_v0 returns a matrix of dimension
% n x nmovies x nmarkets

shat_jc = sum(ind_sh_v1(delta_jc,mu_ijc,data))/data.n;
shat_jc = squeeze(shat_jc); % remove singleton dim

f = shat_jc';