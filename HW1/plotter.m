clc; clear;

load("all_results.mat");

figure_directory = fullfile(pwd, 'figures');

if ~exist(figure_directory, 'dir')
    mkdir(figure_directory);
end