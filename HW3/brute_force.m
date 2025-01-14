close all
clear all
clc

%               Simulation parameters:
T_FIN = 15;
N = 10;
n_agents = 934;
vaccines = [5, 9, 16, 24, 32, 40, 47, 54, 59, 60, 60, 60, 60, 60, 60];
ground_truth = [1, 3, 5, 9, 17, 32, 32, 17, 5, 2, 1, 0, 0, 0, 0];
initial_infections = 1;

k_0 = 12;
k_f = 15;
beta_0 = 0.01;
beta_f = 0.5;
rho_0 = 0.3;
rho_f = 0.8;
db = 0.005;
dr = 0.005;

res = zeros(k_f-k_0+1, 3);



%%
tic
for k = k_0:k_f
    index = 1;
    min_RMSE = Inf;
    top_params = [0, 0];
    for beta=beta_0:db:beta_f
        for rho = rho_0:dr:rho_f
            W = generate_random_graph(n_agents, k);
            avg_I = zeros(N, T_FIN);
            parfor n = 1:N
                [~, ~, ~, avg_I(n,:), ~] = pandemic_sim(W, T_FIN, initial_infections, beta, rho, vaccines);
            end
            avg_I = sum(avg_I, 1)/N;
            RMSE = sqrt(1/T_FIN * sum((ground_truth - avg_I).^2));
            if RMSE < min_RMSE
                min_RMSE = RMSE;
                top_params = [beta, rho];
            end
        end
    end
    toc
    fprintf("k=%d done\n", k);
    fprintf("beta = %f, rho = %f, RMSE = %f\n\n", top_params(1), top_params(2), min_RMSE);
    res(k-k_0+1, index) = RMSE;
    index = index+1;
    save("brute_force_12-15");
end