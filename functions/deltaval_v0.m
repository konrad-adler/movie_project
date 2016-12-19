function f = deltaval_v0(theta1,data)

tempdelta = data.X_j*theta1(1:data.k)' + theta1(data.k+1:end)';
% bring data into format: nmovies x nmarket
f = repmat(tempdelta,1,data.nmarket);
