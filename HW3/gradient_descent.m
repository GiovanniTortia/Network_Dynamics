clear all
close all
clc

%% Parameters

%               Simulation parameters:
T_FIN = 15;
N = 8000;
n_agents = 934;
vaccines = [5, 9, 16, 24, 32, 40, 47, 54, 59, 60, 60, 60, 60, 60, 60];
ground_truth = [1, 3, 5, 9, 17, 32, 32, 17, 5, 2, 1, 0, 0, 0, 0];
initial_infections = 1;

%               Gradient descente parameters:
% Stop condition: threshold < min_threshold or step_size < min_step_size
threshold_0 = 1;
step_size_0 = 0.05;
min_threshold = 0.1;
min_step_size = 0.005;

max_steps = 20;

beta_0 = 0.5;
rho_0 = 0.5;
k_0 = 3;
k_f = 8;

dr = 0.01;
db = 0.01;
dx = [db; dr];

% Stores the result as res(k) = [rho*_k, beta*_k, RMSE_k]
results = zeros(k_f - k_0+1, 3);

%% Gradient descent
tic
for k = k_0:k_f
    %tic
    x = [beta_0; rho_0];
    previous_RMSE = [Inf, Inf, Inf];
    best_RMSE = Inf;
    best_params = zeros(2,1);
    threshold = threshold_0;
    step_size = step_size_0;
    done = false;
    n_steps = 0;
    W = generate_random_graph(n_agents, k);    

    while(~done)
        if n_steps > max_steps
            n_steps = 0;
            step_size = step_size/2;
            threshold = threshold/2;
           
            if step_size < min_step_size || threshold < min_threshold
                results(k-k_0+1,:) = [best_params, best_RMSE];
                toc
                fprintf("k = %d, x = (%f, %f), RMSE(x) = %f\n", ...
                    k, best_params(1), best_params(2), best_RMSE);
                fprintf("%d steps performed\n\n", n_steps);
                done = true;
                break;
            end
        end

        % Compute RMSE(x)
        RMSE = RMSE_p(x, N, W);
        fprintf("beta: %f, rho: %f, RMSE: %f\n", x(1), x(2), RMSE)

        if RMSE < best_RMSE
            best_RMSE = RMSE;
            best_params = [x(1), x(2)];
        end
        %fprintf("beta: %f, rho: %f, RMSE: %f\n", x(1), x(2), RMSE);
        
        % If threshold has been reached  half the step size and the threshold
        % if abs(RMSE - previous_RMSE(end)) < threshold
        %     thresold = threshold/2;
        %     step_size = step_size/2;
        %     reduced = true;
        %     fprintf("Reducing step size to %f\n", step_size);
        %     if threshold < min_threshold || step_size < min_step_size
        %         results(k-k_0+1,:) = [best_params, best_RMSE];
        %         toc
        %         fprintf("k = %d, x = (%f, %f), RMSE(x) = %f\n", ...
        %             k, best_params(1), best_params(2), best_RMSE);
        %         fprintf("%d steps performed\n\n", n_steps);
        %         done = true;
        %         continue;
        %     end
        % end

        % Reduces the step size when the RMSE value starts oscillating
        if abs(previous_RMSE(2)-RMSE) < threshold && abs(previous_RMSE(1)-previous_RMSE(3)) < threshold
            step_size = step_size/2;
            threshold = threshold/2;
           
            if step_size < min_step_size || threshold < min_threshold
                results(k-k_0+1,:) = [best_params, best_RMSE];
                toc
                fprintf("k = %d, x = (%f, %f), RMSE(x) = %f\n", ...
                    k, best_params(1), best_params(2), best_RMSE);
                fprintf("%d steps performed\n\n", n_steps);
                done = true;
                break
            end
            previous_RMSE = [Inf, Inf, Inf];
        end

        previous_RMSE(1) = previous_RMSE(2);
        previous_RMSE(2) = previous_RMSE(3);
        previous_RMSE(3) = RMSE;
        
        % Compute gradient
        grad = zeros(2, 1);
        for i=1:2
            if i==1
                beta = x(1)+dx(1);
                rho = x(2);
            else
                beta = x(1);
                rho = x(2)+dx(2);
            end
    
            dRMSE = RMSE_p(x, N, W) - RMSE;
            grad(i) = dRMSE/dx(i);
        end
        % Normalize gradient to obtain direction of max growth 
        grad = grad/norm(grad);
        
        % Update step
        x_next = x - step_size*grad;

        % If x would go out of bounds reduce step size and retry
        while x_next(1) <= 0 || x_next(2) <= 0 || x_next(1) > 1 || x_next(2) > 1
            step_size = step_size/2;
            threshold = threshold/2;
            if step_size < min_step_size || threshold < min_threshold
                results(k-k_0+1,:) = [best_params, best_RMSE];
                toc
                fprintf("k = %d, x = (%f, %f), RMSE(x) = %f\n", ...
                    k, best_params(1), best_params(2), best_RMSE);
                fprintf("%d steps performed\n\n", n_steps);
                done = true;
                break;
            end
            x_next = x - step_size*grad;
        end

        x = x_next;
        n_steps = n_steps+1;
    end
end
time = toc