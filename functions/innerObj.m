function f = innerObj(theta1,mu_ijc,data)


f = sum(sum((data.s_jc - mktsh_v1(deltaval_v0(theta1,data),mu_ijc,data)).^2));

