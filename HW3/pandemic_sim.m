% Simulates a discrete time SIR pandemic, where the unit of time is a week
%
% input: W (adjacency matrix of the graph), T_FIN (#weeks to be simulated),
% the number of initial infections, the percentage of the population being
% vaccinated at each week, the probability of infection beta and the
% probability of mutation rho
%
% output: the number of people in each state at each week (S, I, R), the
% new infections of each week and the number of vaccines administered each
% week
function [S, I, R, new_inf, new_vax] = pandemic_sim(W, T_FIN, initial_infections, beta, rho, vax_perc)

% Setup vectors
new_inf = zeros(T_FIN, 1);
S = zeros(T_FIN, 1);
I = zeros(T_FIN, 1);
R = zeros(T_FIN, 1);
new_vax = zeros(T_FIN, 1);

% Infect initial nodes
n_agents = size(W, 1);
x = zeros(n_agents, 1);
for i = 1:initial_infections
    j = randsample(find(x ~= 1), 1);
    x(j) = 1;
end

for week = 1:T_FIN
    
    if week ~= 1
        R(week) = R(week-1);
    end
    
    % Vaccinate to meet vaccinated_perc
    if vax_perc(week) ~= 0
        unvaxxed = find(x ~= 3);
        target = round(n_agents*vax_perc(week)/100);
        vaxxed = sum(x == 3);
        to_be_vaxxed = target - vaxxed;

        if to_be_vaxxed > 0
            vax = randsample(unvaxxed, to_be_vaxxed, false);
            x(vax) = 3;
            new_vax(week) = to_be_vaxxed;
        end
    end
    
    for agent = 1:n_agents
        % Check if agent recovers
        if x(agent) == 1
            if rand() <= rho
                x(agent) = 2;
                R(week) = R(week) + 1;
            end

        % Check if agent gets infected
        elseif x(agent) == 0
            % Compute probability of infection
            neighbors = find(W(:,agent) == 1);
            m = sum(x(neighbors)==1);
            p_contagion = 1 - (1-beta)^m;
            
            % Check if agent gets infected
            if rand() <= p_contagion
                x(agent) = 1;
                new_inf(week) = new_inf(week) + 1;
            end
        end
    end
    S(week) = S(week) + sum(x==0);
    I(week) = I(week) + sum(x==1);

end

end

