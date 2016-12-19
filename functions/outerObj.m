function f = outerObj(theta1,theta2,data)

disp('New guess for theta2 - outer loop parameters')
sprintf('%.3f %.3f %.3f\n',theta2)

mu_ijc = mufunc_v1(theta2,data);

[Params, f, Exitflag,output] = fminsearch(@(theta1)innerObj(theta1,mu_ijc,data),theta1,data.options);

disp(['Completed new run of inner loop after ',num2str(output.iterations),' iterations , the value is ',num2str(f)])
sprintf('%.3f %.3f %.3f\n',Params)







