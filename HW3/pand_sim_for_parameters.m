function new_inf = pand_sim_for_parameters(W, T_FIN, initial_infections, vax, beta, rho)
    n_agents = size(W, 1);
    x = zeros(n_agents, 1);
    new_inf = zeros(1, T_FIN);

    for i = 1:initial_infections
        j = randsample(find(x ~= 1), 1);
        x(j) = 1;
        new_inf(1) = initial_infections;
    end
    
    for week = 1:T_FIN
        
        if vax(week ~= 0)
            target = ceil(vax(week)*n_agents/100);
            unvaxxed = find(x ~= 3);
            vaxxed = sum(x == 3);
            to_be_vaxxed = target - vaxxed;

            doses = randsample(unvaxxed, to_be_vaxxed, false);
            x(doses) = 3;
        end

        for agent = 1:n_agents
            if x(agent) == 1
                if rand() <= rho
                    x(agent) = 2;
                end
            elseif x(agent) == 0
                neighbors = find(W(:,agent)==1);
                m = sum(x(neighbors)==1);
               
                prob = 1-(1-beta)^m;
                if rand() <= prob
                    x(agent) = 1;
                    new_inf(week) = new_inf(week)+1;
                end
            end

        end

    end


end

