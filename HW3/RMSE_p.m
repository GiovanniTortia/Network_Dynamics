function RMSE = RMSE_p(x, N, W)

% Reuturns the RMSE on the new infections corresponding to the simulation ran 
% with parameters k, beta, rho
% the average is carried out over N iterations


    beta = x(1,:);
    rho = x(2,:);
    T_FIN = 15;
    vaccines = [5, 9, 16, 24, 32, 40, 47, 54, 59, 60, 60, 60, 60, 60, 60];
    ground_truth = [1, 3, 5, 9, 17, 32, 32, 17, 5, 2, 1, 0, 0, 0, 0];
    initial_infections = 1;
    avg_I = zeros(N, T_FIN);
    
    parfor n = 1:N
        [~, ~, ~, avg_I(n,:), ~] = pandemic_sim(W, T_FIN, initial_infections, beta, rho, vaccines);
    end
    avg_I = sum(avg_I, 1)/N;
    RMSE = sqrt(1/T_FIN * sum((ground_truth - avg_I).^2));
end

