function a = brute_force(X, c, a_k, a_best, i)
% Recursively computes the maximum throughput of the network taking as input: 
% X, the additional capacity that can be added to the network 
% c, the capacity vector
% the function should be initialized with a_k = a_best = zeros(1, #edges)
% and i = 0


% Base case
if i == X
    if(throughput(a_k, c) > throughput(a_best, c))
        a = a_k;
    else
        a = a_best;
    end
    return
end

for j = 1:size(a_k, 2)
    a_k(j) = a_k(j) + 1;
    a_best = brute_force(X, c, a_k, a_best, i+1);
    a_k(j) = a_k(j) - 1;
end
    a = a_best;
end

