clear
close all
clc

%% Base parameters

TRM = [[0, 3/4, 3/4, 0, 0];
    [0, 0, 1/4, 1/4, 2/4];
    [0, 0, 0, 1, 0];
    [0, 0, 0, 0, 1];
    [0, 0, 0, 0, 0]];

w = TRM*ones(5, 1);
w(5) = 2;
w_star = max(w);
D = diag(w);
P = inv(D)*TRM;
P_bar = P/w_star;
for i=1:5
    P_bar(i,i) = 1-sum(P_bar(i,:));
end

%% Proportional rate

in_rate = 100;
T_FIN = 60;
i = 1;
N_t = zeros(5, 1);
% Preallocate expected value of a poisson distributed variable
% columns for faster computation
record = zeros(5, round(T_FIN*in_rate));
% t stores the times of each change in N_t
t = zeros(1, round(T_FIN*in_rate));

% ticks stores the time of each tick for each agent (nodes (1-5), particles
% entering (6)),initially set all tick times of nodeds to inf to ignore 
% them as they don't have any particle yet
ticks = [Inf;Inf;Inf;Inf;Inf;-log(rand)/in_rate];
% At each iteration solve the first tick, compute next tick of the same
% agent and repeat until T_FIN is reached
tic
while max(t) < T_FIN
    % Find first tick
    agent = find(ticks==min(ticks), 1);
    t(i+1) = ticks(agent);
    % Update # particles
    if agent == 6   % Particle entering
        N_t(1) = N_t(1) + 1;
        % Compute interval between ticks
        ticks(6) = -log(rand)/in_rate + t(i+1);

        % If node o was empty assign tick time
        if ticks(1) == Inf
            ticks(1) = -log(rand)/(w(1)) + t(i+1);
        end


    elseif agent == 5   % Particle exiting
        N_t(5) = N_t(5) - 1;
        % Compute interval between ticks
        % If there are no more particles set ticking time to Inf
        if N_t(5) == 0
            ticks(5) = Inf;
        else
            ticks(5) = -log(rand)/(w(5)*N_t(5)) + t(i+1);
        end

    else    % Particle hopping
        % Choose node to jump to
        node = randsample(1:5, 1, true, P(agent,:));
        N_t(node) = N_t(node) + 1;
        N_t(agent) = N_t(agent) - 1;

        % If previously empty assign tick time to node which received the
        % particle
        if ticks(node) == Inf
            ticks(node) = -log(rand)/w(node) + t(i+1);
        end
        % Compute interval between ticks of agent
        if N_t(agent) == 0
            ticks(agent) = Inf;
        else
            ticks(agent) = -log(rand)/(w(agent)*N_t(agent)) + t(i+1);
        end
    end
    
    i = i+1;
    record(:,i) = N_t;
end
tot_time = toc

%% Constant rate

in_rate = 1;
T_FIN = 60;
i = 1;
N_t = zeros(5, 1);
% Preallocate expected value of a poisson distributed variable
% columns for faster computation
record = zeros(5, round(T_FIN*in_rate));
% t stores the times of each change in N_t
t = zeros(1, round(T_FIN*in_rate));

% ticks stores the time of each tick for each agent (nodes (1-5), particles
% entering (6)),initially set all tick times of nodeds to inf to ignore 
% them as they don't have any particle yet
ticks = [Inf;Inf;Inf;Inf;Inf;-log(rand)/in_rate];
rates = [w;in_rate];
% At each iteration solve the first tick, compute next tick of the same
% agent and repeat until T_FIN is reached
tic
while max(t) < T_FIN
    % Find first tick
    agent = find(ticks==min(ticks), 1);
    t(i+1) = ticks(agent);
    % Update # particles
    if agent == 6   % Particle entering
        N_t(1) = N_t(1) + 1;
        % Compute interval between ticks
        ticks(6) = -log(rand)/in_rate + t(i+1);

        % If node o was empty assign tick time
        if ticks(1) == Inf
            ticks(1) = -log(rand)/(w(1)) + t(i+1);
        end


    elseif agent == 5   % Particle exiting
        N_t(5) = N_t(5) - 1;
        % Compute interval between ticks
        % If there are no more particles set ticking time to Inf
        if N_t(5) == 0
            ticks(5) = Inf;
        else
            ticks(5) = -log(rand)/w(5) + t(i+1);
        end

    else    % Particle hopping
        % Choose node to jump to
        node = randsample(1:5, 1, true, P(agent,:));
        N_t(node) = N_t(node) + 1;
        N_t(agent) = N_t(agent) - 1;

        % If previously empty assign tick time to node which received the
        % particle
        if ticks(node) == Inf
            ticks(node) = -log(rand)/w(node) + t(i+1);
        end
        % Compute interval between ticks of agent
        if N_t(agent) == 0
            ticks(agent) = Inf;
        else
            ticks(agent) = -log(rand)/w(agent) + t(i+1);
        end
    end
    
    i = i+1;
    record(:,i) = N_t;
end
tot_time = toc

%% Particle plots
close all
avg = zeros(5, 1);
for i=1:5
    avg(i) = mean(record(i,:));
    figure;
    plot(t, record(i, :));
    hold on
    plot([0, T_FIN], ones(2, 1)*avg(i))
    legend('$N_o(t)$', "Average", 'Interpreter', 'latex', 'Location','best')
    xlim([0,60]);
    ylim([0, max(record(i,:)+1)])
    xlabel('t');
    ylabel('$N_o(t)$', 'Interpreter','latex');
end
avg = avg/sum(avg)

