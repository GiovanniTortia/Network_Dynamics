close all
clc

%               Simulation parameters:
T_FIN = 15;
N = 100;
n_agents = 934;
vaccines = [5, 9, 16, 24, 32, 40, 47, 54, 59, 60, 60, 60, 60, 60, 60];
ground_truth = [1, 3, 5, 9, 17, 32, 32, 17, 5, 2, 1, 0, 0, 0, 0]';
initial_infections = 1;

%               Gradient descente parameters:
% Stop condition: deltaRMS < threshold
threshold = 1;
step_size = 0.05;

beta = 0.564004;
rho = 0.265297;
k = 3;

tic
        avg_I = zeros(T_FIN, 1);
        for n = 1:N
            W = generate_random_graph(n_agents, k);
            [~, I, ~, ~, ~] = pandemic_sim(W, T_FIN, initial_infections, beta, rho, vaccines);
            avg_I = avg_I + I;
        end
        avg_I = avg_I/N;
toc
        RMSE = sqrt(1/T_FIN * sum((ground_truth - avg_I).^2))
