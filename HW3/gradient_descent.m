clear all
close all
clc

%% Simulation Parameters

%               Simulation parameters:
T_FIN = 15;
N = 1000;
n_agents = 934;
vaccines = [5, 9, 16, 24, 32, 40, 47, 54, 59, 60, 60, 60, 60, 60, 60];
ground_truth = [1, 3, 5, 9, 17, 32, 32, 17, 5, 2, 1, 0, 0, 0, 0]';
initial_infections = 1;

%               Gradient descente parameters:
% Stop condition: deltaRMS < threshold
threshold = 1;
step_size = 0.075;

beta_0 = 0.3;
rho_0 = 0.6;
k_0 = 2;
k_f = 10;

dr = 0.03;
db = 0.03;
dx = [dr; db];

% Stores the result as res(k) = [rho*_k, beta*_k, RMSE_k]
results = zeros(k_f - k_0+1, 3);
tic
for k = k_0:k_f
    %tic
    x = [rho_0; beta_0];
    last_RMSE = Inf;
    
    while(true)
        % Compute RMSE(x)
        avg_I = zeros(T_FIN, 1);
        for n = 1:N
            W = generate_random_graph(n_agents, k);
            [~, I, ~, ~, ~] = pandemic_sim(W, T_FIN, initial_infections, x(1), x(2), vaccines);
            avg_I = avg_I + I;
        end
        avg_I = avg_I/N;
        RMSE = sqrt(1/T_FIN * sum((ground_truth - avg_I).^2));
        
        if abs(RMSE - last_RMSE) < threshold
            results(k-k_0+1,:) = [x(1), x(2), RMSE];
            toc
            fprintf("k = %d, x = (%f, %f), RMSE(x) = %f\n\n", k, x(1), x(2), RMSE);
            break
        end
        
        % Compute gradient
        grad = zeros(2, 1);
        for i=1:2
            avg_I = zeros(T_FIN, 1);
            if i==1
                rho = x(1)+dx(1);
                beta = x(2);
            else
                rho = x(1);
                beta = x(2)+dx(2);
            end
    
            for n = 1:N
                W = generate_random_graph(n_agents, k);
                [~, I, ~, ~, ~] = pandemic_sim(W, T_FIN, initial_infections, beta, rho, vaccines);
                avg_I = avg_I + I;
            end
            dRMSE = sqrt(1/T_FIN * sum((ground_truth - avg_I).^2));
            grad(i) = dRMSE/dx(i);
        end
        % Normalize gradient to obtain direction of max growth 
        grad = grad/norm(grad);
    
        % Update step
        x = x - grad*step_size;
        last_RMSE = RMSE;
    end
end
time = toc