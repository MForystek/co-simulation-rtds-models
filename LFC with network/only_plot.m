close all;
clear all;
clc;
fig1 = figure('Units', 'inches', 'Position', [0, 0, 6.4, 4.8]);
palette = [
    "#1f78b4" % no
    "#e31a1c" % LFC
    "#33a02c" % UFLS
    "#a6cee3" % delay
    "#fb9a99" % packet loss
    "#b2df8a" % jitter
    ];
%%
% File configuration
filename = "freqs/DLAA_big_LFC_UFLS.txt";
colour = palette(3, :);
xleft = 195;
plot_to = 0;
legend_location = "southwest";
graph_filename = "graphics/DLAA_big_LFC_UFLS.pdf";

plots_order = [2, 1];
leg = ["LFC on", "LFC and UFLS on"];

% Time configuration
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
if plot_to ~= 0
    freqsmatrix = freqsmatrix(1:plot_to/timestep, :);
end

lege = strings(1, numofelements); 
for i=1:numofelements
    times = (1/(timestep):length(freqsmatrix(:, i))) * timestep;
    if i == 1
        plot(times, freqsmatrix(1/(timestep):end, i), '-', 'Color', ...
            colour, 'LineWidth', 1, 'DisplayName', strcat('temp', num2str(i)));
    else 
            plot(times, freqsmatrix(1/(timestep):end, i), '-', ...
                'Color', colour, 'LineWidth', 1, 'HandleVisibility', 'off');
    end
    hold on;
    lege(i) = (cellstr(strcat('freq', num2str(i))));
end
set(gca, 'FontSize', 16);
set(gca,'FontName', 'Arial');

% Thresholds for Saudi grid
yline(58.8, "b--", 'HandleVisibility', 'off'); yline(60.5, "b--", 'HandleVisibility', 'off');
yline(57.5, "g-.", 'HandleVisibility', 'off'); yline(61.5, "g-.", 'HandleVisibility', 'off');
yline(57, "r:", 'HandleVisibility', 'off', 'LineWidth', 1.5);
yline(62.5, "r:", 'HandleVisibility', 'off', 'LineWidth', 1.5);

xlabel('Time [s]');
ylabel('Frequency [Hz]');
xlim([0, xleft]);
ylim([56.9, 62.6]);
grid on;

legHandles = findobj(gca, '-property', 'DisplayName');
labels = get(legHandles, 'DisplayName');
correctHandles = legHandles(plots_order);
legend(correctHandles, leg, 'FontSize', 16, 'Location', legend_location);

if false

    exportgraphics(fig1, strcat(graph_filename), 'Resolution', 600, 'ContentType', 'vector');

end