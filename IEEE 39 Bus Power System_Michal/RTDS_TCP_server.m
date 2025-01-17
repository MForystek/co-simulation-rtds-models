close all;
clear all;
clc;

scenarios_names;

% File configuration
filename = with_LFC_50_up;

% Time configuration
numofelements = 10; 
time = 300; % sec
timestep = 0.01; % sec
steps = time/timestep;

runTCPServer(filename, numofelements, timestep, steps);

%% Plotting
plotResults(filename, numofelements, timestep);

%% Functions
function runTCPServer(filename, numofelements, timestep, steps)
    global server callnum msglen;
    callnum = 0;
    msglen = 0;

    % Network configuration
    GTNetIP='172.24.14.204'; % Address of GTNet Card used as a TCP Server in RTDS
    port = 3721; % Specify the opened port
    
    % Create TCP server
    server = tcpserver('0.0.0.0', port);
    server.ByteOrder = "big-endian";
    
    % Open the output file
    file_w = fopen(filename, 'w');
    
    % Configure callback for incoming data
    configureCallback(server, "byte", 4*numofelements, ...
        @(src, ~) serverCallback(src, numofelements, file_w, timestep, steps));
    
    % Run the server
    disp("TCP Server is running. Waiting for the data...");
    disp(['Total measurement time: ', num2str(steps*timestep), ' seconds']);
    pause;
    
    % Close the server and the output file
    if exist("server", "var") == 1
        delete(server);
        clear server;
    end
    fclose(file_w);
    fprintf("\nTCP Server stopped.\n");
end

function plotResults(filename, numofelements, timestep)
    area1_gens = [4, 5, 6, 7];
    area2_gens = [8, 9, 10];
    area3_gens = [1, 2, 3];
    
    % Open the file
    file_r = fopen(filename, 'r');
    freqscell = textscan(file_r, '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f,');
    fclose(file_r);
    freqsmatrix = cell2mat(freqscell);
    
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
    legend(lege);
end

% Callback function
function serverCallback(src, numofelements, file_w, timestep, steps, ~)
    global server callnum msglen;

    if mod(callnum, 1/timestep) == 0
        if msglen ~= 0
            fprintf(repmat('\b', 1, msglen))
        end
        msg = append("There are ", num2str((steps - callnum)*timestep), " seconds left");
        msglen = fprintf(msg);
    end

    if callnum >= steps
        fprintf('\nMaximum number of calls reached. Stopping the server.');
        fprintf('\nPress any key to display results...');
        delete(server);
        clear server;
        beep;
        return;
    end

    % Read available data as float
    data = read(src, numofelements, "single");

    % Save data to the output file
    fprintf(file_w, '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f,\n', ...
        data(1), data(2), data(3), data(4), data(5), ...
        data(6), data(7), data(8), data(9), data(10));

    callnum = callnum + 1;
end