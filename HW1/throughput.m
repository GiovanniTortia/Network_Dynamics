function tau = throughput(x, c)
% Returns the network's max throughput, taking as input:
% x: the additional capacity
% c: the capacity vector


    K = [[0 1 0 1 0 1 0];
     [1 0 0 1 0 1 0];
     [0 1 1 0 0 1 1];
     [0 1 0 1 1 0 0];
     [1 0 1 0 0 1 0];
     [1 0 0 1 1 0 0];
     [0 1 1 0 0 0 1];
     [1 0 1 0 0 0 0]];

    tau = min(K*(c+x)');
end

