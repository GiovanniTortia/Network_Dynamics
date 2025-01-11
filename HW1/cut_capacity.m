function [cc, boundary] = cut_capacity(cut_nodes, B, c)
% Returns the cut capacity (cc) and the boundary of the cut (edges), 
% taking as input:
% cut_nodes: the indices of the nodes that were cut, as a vector
% B: the node-link adjacency matrix
% c: the capacity of each edge, as a vector

    NU = 1:size(B, 1);
    NU = setdiff(NU, cut_nodes);
    cc = 0;
    boundary = [];
    for n = cut_nodes
        for i = 1:size(B, 2)
            % if edge i is in the boundary of the cut
            if B(n, i) == -1 && any(NU == find(B(:,i)>0))   
                cc = cc + c(i);
                boundary(end+1) = i;
            end
        end
    end

end

