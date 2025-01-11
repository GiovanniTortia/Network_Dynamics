%   returns a vector of k elements at random from vector v, 
%   chosen with probabilities given by vector p

function out = rand_choice_no_repeat(v, k, p)
    out = zeros(k, 1);
    
    for i = 1:k
        out(i) = randsample(v,1,true,p);
        ind = find(v == out(i));
        v(ind) = [];
        p(ind) = [];
        p = p/sum(p);
    end

end

