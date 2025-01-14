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
w = zeros(n_nodes, 1);
edges = zeros(k*n_nodes, 2);
ind = 1;
for i=1:k+1
    for j=1:k+1
        if i ~= j
            edges(ind,:) = [i, j];
            w(i) = w(i)+1;
            w(j) = w(j)+1;
            ind = ind+1;
        end
    end
end

for node = k+2:n_nodes
    % compute probability of connecting to each node and choose neighbors
    prob = w(1:node-1)/sum(w);
    neighbors = rand_choice_no_repeat(1:node-1, c+increment, prob);
    % write edge in adjacency matrix
    for n = 1:c+increment
        w(node) = w(node)+1;
        w(neighbors(n)) = w(neighbors(n))+1;
        edges(ind,:) = [neighbors(n), node];
        edges(ind+1,:) = [node, neighbors(n)];
        ind = ind+2;
    end

    if odd
        increment = 1-increment;
    end
end

v = ones(size(edges, 1), 1);
W = sparse(edges(:,1), edges(:,2), v);



