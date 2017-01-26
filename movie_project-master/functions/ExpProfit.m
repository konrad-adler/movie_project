function expprofit = ExpProfit(Params, Model,sigma,mu)
% =============================================================================================
% Objective Function for Ancient city structural model
%
% INPUT: Params, vector, vector of estimated parameters
%        Model, structure
%        W, matrix, weighting matrix
% OUTPUT: J (objective)
% =============================================================================================

budget=Model.budget;
ntaste=Model.ntaste;
movie_replaced=Model.movie_replaced;
%mu = [.5 .5];
%sigma(1)=.01;
%sigma(2)=.01;
Sigma_mat = [sigma(1) 0; 0 sigma(2)];
stepsize=.2;
x1 = (mu(1)-.5):stepsize:(mu(1)+.5); x2 = (mu(2)-.5):stepsize:(mu(2)+.5);
gridsize=size(x1,2);
[long,lat] = meshgrid(x1,x2);
F = mvnpdf([long(:) lat(:)],mu,Sigma_mat);
F = reshape(F,length(long),length(lat));
%surf(x1,x2,F);
expprof=0;
for i1=1:gridsize,
    for i2=1:gridsize,
        pos=ntaste+1+(movie_replaced-1)*ntaste+1-1;
        Params(pos)=x1(i1);
        pos=ntaste+1+(movie_replaced-1)*ntaste+2-1;
        Params(pos)=x2(i2);
        expprof=expprof+F(i1,i2)/sum(sum(F))*Profit(Params,Model);
    end
end

expprofit=expprof-budget(movie_replaced);
end
