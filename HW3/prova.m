close all
clear all
clc

%               Simulation parameters:

W = generate_random_graph(934, 10);
%%
tic
RMSE_p([0.1;0.4], 1000, W)
toc