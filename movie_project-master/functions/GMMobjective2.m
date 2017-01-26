function [J,sigma,original_loc] = GMMobjective2(Params, Model)
% =============================================================================================
% Objective Function for Ancient city structural model
%
% INPUT: Params, vector, vector of estimated parameters
%        Model, structure
%        W, matrix, weighting matrix
% OUTPUT: J (objective)
% =============================================================================================

%% DATA INPUT/PROCESS
nmovies=Model.nmovies;
ntaste=Model.ntaste;
d = reshape(Params,[nmovies,ntaste]);
d1 = d(:,1);
d2 = d(:,2);
x=Model.x;
cj_result=Model.cj_result;
likeli=zeros(nmovies,1);
expprofit=zeros(nmovies,1);
original_loc=zeros(nmovies,2);

for i=1:nmovies,
    Model.movie_replaced=i;
    movie_replaced=i;
    mu = [cj_result(i,1)-d1(i) cj_result(i,2)-d2(i)];
    original_loc(i,:)=mu;
    sigma(1)=sqrt(mean(d1.^2));
    sigma(2)=sqrt(mean(d2.^2));
    Sigma_mat = [sigma(1) 0; 0 sigma(2)];
    likeli(i)=mvnpdf([cj_result(i,1) cj_result(i,2)],mu,Sigma_mat);
    %expprofit(i) = ExpProfit(x,Model,sigma,mu);
    pos=ntaste+1+(movie_replaced-1)*ntaste+1-1;
    x(pos)=mu(1);
    pos=ntaste+1+(movie_replaced-1)*ntaste+2-1;
    x(pos)=mu(2);
    expprofit(i) = Profit(x, Model)-Model.budget(i);
end
expprofit=-expprofit;
for i=1:nmovies,
    if expprofit(i)<0,
        expprofit(i)=0;
    end
end
J=sum(expprofit)/10000+sum(-likeli);