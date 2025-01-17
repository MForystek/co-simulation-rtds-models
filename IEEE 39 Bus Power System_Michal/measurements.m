clear all;
close all;
clc;

scenarios_names;

scenarios_names_list = [
    no_LFC_static;
    no_LFC_5_up;
    no_LFC_10_up_single;
    no_LFC_10_up;
    no_LFC_20_up;
    no_LFC_50_up;
    no_LFC_5_down;
    no_LFC_10_down_single;
    no_LFC_10_down;
    no_LFC_20_down;
    no_LFC_50_down;
    
    with_LFC_static;
    with_LFC_5_up;
    with_LFC_10_up_single;
    with_LFC_10_up;
    with_LFC_20_up;
    with_LFC_50_up;
    with_LFC_5_down;
    with_LFC_10_down_single;
    with_LFC_10_down;
    with_LFC_20_down;
    with_LFC_50_down;
    
    with_LFC_area_one_max;
    with_LFC_area_two_max;
    with_LFC_area_three_max;
    with_LFC_areas_1_2_max;
    with_LFC_areas_1_3_max;
    with_LFC_areas_2_3_max;
    with_LFC_areas_1_2_3_max;

    with_LFC_area_1_5_then_7;
    with_LFC_area_2_5_then_7;
    with_LFC_area_3_5_then_8;
    with_LFC_areas_12_10_then_X;
    with_LFC_areas_13_10_then_X;
    with_LFC_areas_23_10_then_X;
    with_LFC_areas_123_10_then_X;

    with_LFC_dynamic;
];

duration = 450 / 0.01;

scenarios = NaN(length(scenarios_names_list), 10, duration);

for i = 1:length(scenarios_names_list)
    filename = scenarios_names_list(i);
    file_r = fopen(filename, 'r');
    freqscell = textscan(file_r, '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f,');
    fclose(file_r);
    freqsmatrix = cell2mat(freqscell);
    freqsmatrix = freqsmatrix.';
    scenarios(i, :, 1:length(freqsmatrix(1,:))) = freqsmatrix;
end

attack_time_in_steps = 31 / 0.01;
nadirs = zeros(length(scenarios_names_list), 10);
RoCoFs = zeros(length(scenarios_names_list), 10, duration);
RoCoFs(:, :, 1) = 0;
drop_duration = zeros(length(scenarios_names_list), 10);
for i = 1:length(scenarios_names_list)
    for j = 1:10
        nadirs(i, j) = min(scenarios(i, j, :));
        RoCoFs(i, j, 2:end) = diff(scenarios(i, j, :));
        curr_drop_duration = find(scenarios(i, j, attack_time_in_steps:end) >= 59.99, 1);
        if isempty(curr_drop_duration)
            drop_duration = 0;
        else
            drop_duration(i, j) = curr_drop_duration;
        end
    end
end

figure;
subplot(3, 1, 1);
plot(nadirs);
subplot(3, 1, 2);
plot(RoCoFs(3,:));
subplot(3, 1, 3);
plot(drop_duration(:,1));

test = squeeze(scenarios(13, 1, :));
length(find(scenarios(13, 2, attack_time_in_steps:end) >= 59.99, 1))