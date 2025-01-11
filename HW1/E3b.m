clear all
close all
clc

B = load("traffic.mat").traffic;
c = load("capacities.mat").capacities;

% Same procedure as Exercise 1, generate all possible o-d cuts and find the
% min-cut

min_cut = -1;
min_cc = Inf;

for i=0:15
   cuts = nchoosek(2:16, i);
   for j = 1:size(cuts, 1)
        cut = [cuts(j,:), 17];
        [cc, edges] = cut_capacity(cut, B, c);
        
        if cc < min_cc
            min_cc = cc;
            min_cut = cut;
        end
   end
end

fprintf("Min cut: ");
disp(min_cut);
fprintf("Min cut capacity: %d\n", min_cc);