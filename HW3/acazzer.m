close all
clear all
clc

%%               Simulation parameters:
beta_0 = 0.3;
rho_0 = 0.6;
k_0 = 3;
k_f = 15;
N = 3500;
x_0 = [beta_0, rho_0]';
res = zeros(k_f-k_0+1, 3);
ind=1;

lb = [0, 0];
ub = [1, 1];

options = optimoptions('fmincon','Display','iter-detailed','PlotFcn','optimplotfval');

for k=k_0:k_f
    W = generate_random_graph(934, k);
    [best_params, best_RMSE] = fmincon(@(x)RMSE_p(x,N,W), x_0, [], [], [], [], lb, ub, [], options);
    res(ind,:)=[best_params', best_RMSE];
    ind = ind+1;
end

save("Actual_gradient_descent");