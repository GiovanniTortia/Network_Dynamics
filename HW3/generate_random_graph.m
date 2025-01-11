function W = generate_random_graph(n_nodes, k)

c = floor(k/2);
if mod(k, 2) == 0
    increment = 0;
    odd = false;
else
    increment = 1;
    odd = true;
end

% Initial connected graph with k+1 agents
W = zeros(n_nodes);
for i=1:k+1
    for j=1:k+1
        if i ~= j
            W(i, j) = 1;
        end
    end
end

w = sum(W);
for node = k+2:n_nodes
    % compute probability of connecting to each node and choose neighbors
    prob = w(1:node-1)/sum(w);
    neighbors = rand_choice_no_repeat(1:node-1, c+increment, prob);
    % write edge in adjacency matrix
    for n = neighbors
        W(node, n) = 1;
        W(n, node) = 1;
    end

    w = sum(W);
    if odd
        increment = 1-increment;
    end
end

