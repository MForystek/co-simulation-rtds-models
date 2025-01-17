clear all;
close all;
clc;

scenarios_names;

%% Static load
subplots = [2, 1];
xlimits = [0, 150];
ylimits = [59.9, 60.1];
figure;
plot_one(no_LFC_static, subplots, 1, xlimits, ylimits, "No LFC, static load");
plot_one(with_LFC_static, subplots, 2, xlimits, ylimits, "With LFC, static load");

%% Simple LAAs up (weaker)
subplots = [3, 2];
xlimits = [0, 300];
ylimits = [59.35, 60.05];
figure;
plot_one(no_LFC_5_up, subplots, 1, xlimits, ylimits, "No LFC, 5% up");
plot_one(with_LFC_5_up, subplots, 2, xlimits, ylimits, "With LFC, 5% up");
plot_one(no_LFC_10_up_single, subplots, 3, xlimits, ylimits, "No LFC, 10% up single");
plot_one(with_LFC_10_up_single, subplots, 4, xlimits, ylimits, "With LFC, 10% up single");
plot_one(no_LFC_10_up, subplots, 5, xlimits, ylimits, "No LFC, 10% up");
plot_one(with_LFC_10_up, subplots, 6, xlimits, ylimits, "With LFC, 10% up");

%% Simple LAAs up (stronger)
subplots = [2, 2];
xlimits = [0, 300];
ylimits = [20, 200];
figure;
plot_one(no_LFC_20_up, subplots, 1, xlimits, ylimits, "No LFC, 20% up");
plot_one(with_LFC_20_up, subplots, 2, xlimits, ylimits, "With LFC, 20% up");
plot_one(no_LFC_50_up, subplots, 3, xlimits, ylimits, "No LFC, 50% up");
plot_one(with_LFC_50_up, subplots, 4, xlimits, ylimits, "With LFC, 50% up");

%% Simple LAAs down
subplots = [5, 2];
xlimits = [0, 150];
ylimits = [59, 62.6];
figure;
plot_one(no_LFC_5_down, subplots, 1, xlimits, ylimits, "No LFC, 5% down");
plot_one(with_LFC_5_down, subplots, 2, xlimits, ylimits, "With LFC, 5% down");
plot_one(no_LFC_10_down_single, subplots, 3, xlimits, ylimits, "No LFC, 10% down single");
plot_one(with_LFC_10_down_single, subplots, 4, xlimits, ylimits, "With LFC, 10% down single");
plot_one(no_LFC_10_down, subplots, 5, xlimits, ylimits, "No LFC, 10% down");
plot_one(with_LFC_10_down, subplots, 6, xlimits, ylimits, "With LFC, 10% down");
plot_one(no_LFC_20_down, subplots, 7, xlimits, ylimits, "No LFC, 20% down");
plot_one(with_LFC_20_down, subplots, 8, xlimits, ylimits, "With LFC, 20% down");
plot_one(no_LFC_50_down, subplots, 9, xlimits, ylimits, "No LFC, 50% down");
plot_one(with_LFC_50_down, subplots, 10, xlimits, ylimits, "With LFC, 50% down");

%% Max LAA in each area
subplots = [2, 3];
xlimits = [0, 150];
ylimits = [59.4, 60.1];
figure;
plot_one(with_LFC_area_one_max, subplots, 1, xlimits, ylimits, "With LFC, 7% (area 1 max)");
plot_one(with_LFC_area_two_max, subplots, 2, xlimits, ylimits, "With LFC, 7% (area 2 max)");
plot_one(with_LFC_area_three_max, subplots, 3, xlimits, ylimits, "With LFC, 8% (area 3 max)");
plot_one(with_LFC_areas_1_2_max, subplots, 4, xlimits, ylimits, "With LFC, 13% (areas 1 and 2 max)");
plot_one(with_LFC_areas_1_3_max, subplots, 5, xlimits, ylimits, "With LFC, 11% (areas 1 and 3 max)");
plot_one(with_LFC_areas_2_3_max, subplots, 6, xlimits, ylimits, "With LFC, 10% (areas 2 and 3 max)");
subplots = [1, 1];
xlimits = [0, 300];
figure;
plot_one(with_LFC_areas_1_2_3_max, subplots, 1, xlimits, ylimits, "With LFC, 16% (areas 1, 2 and 3 max)");

%% Multistep LAAs
subplots = [3, 3];
xlimits = [0, 300];
ylimits = [59.6, 60.1];
figure;
plot_one(with_LFC_area_1_5_then_7, subplots, 1, xlimits, ylimits, "With LFC, 5%->7% (area 1)");
plot_one(with_LFC_area_2_5_then_7, subplots, 2, xlimits, ylimits, "With LFC, 5%->7% (area 2)");
plot_one(with_LFC_area_3_5_then_8, subplots, 3, xlimits, ylimits, "With LFC, 5%->8% (area 3)");
xlimits = [0, 450];
plot_one(with_LFC_areas_12_10_then_X, subplots, 4, xlimits, ylimits, "With LFC, 10%->11%->13% (areas 1,2)");
plot_one(with_LFC_areas_13_10_then_X, subplots, 5, xlimits, ylimits, "With LFC, 10%->13%->15% (areas 1,3)");
plot_one(with_LFC_areas_23_10_then_X, subplots, 6, xlimits, ylimits, "With LFC, 10%->13%->15% (areas 2,3)");
plot_one(with_LFC_areas_123_10_then_X, subplots, 8, xlimits, ylimits, "With LFC, 10%->15%->17% (areas 1,2,3)");

%% Plotting function
function plot_one(filename, subplots, position, xlimits, ylimits, title_text)
    numofelements = 10;
    timestep = 0.01; % sec

    area1_gens = [4, 5, 6, 7];
    area2_gens = [8, 9, 10];
    area3_gens = [1, 2, 3];
    
    % Open the file
    file_r = fopen(filename, 'r');
    freqscell = textscan(file_r, '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f,');
    fclose(file_r);
    freqsmatrix = cell2mat(freqscell);
    
    subplot(subplots(1), subplots(2), position);
    lege = strings(1, numofelements);
    for i=1:numofelements
        if     ismember(i, area1_gens); linetype = '-';
        elseif ismember(i, area2_gens); linetype = '--';
        elseif ismember(i, area3_gens); linetype = ':'; 
        end 
        times = (1/(timestep):length(freqsmatrix(:, i))) * timestep;
        plot(times, freqsmatrix(1/(timestep):end, i), linetype);
        hold on;
        lege(i) = (cellstr(strcat('freq', num2str(i))));
    end
    
    %legenda = legend(lege);
    %legenda.NumColumns = 1;
    %fontsize(legenda, 5, 'points');
    title(title_text);
    xlabel("Time (sec)");
    ylabel("Frequency (Hz)");
    xlim(xlimits);
    ylim(ylimits);
end