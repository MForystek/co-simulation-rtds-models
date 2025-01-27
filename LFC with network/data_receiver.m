close all;
clear all;
clc;


% File configuration
filename = "delay_comparison.txt";

% Time configuration
numofelements = 6; 
time = 60; % sec
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
    GTNetIP='172.24.14.221'; % Address of GTNet Card used as a TCP Server in RTDS
    port = 7777; % Specify the opened port
    
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
    % Open the file
    file_r = fopen(filename, 'r');
    freqscell = textscan(file_r, '%f, %f, %f, %f, %f, %f,');
    fclose(file_r);
    freqsmatrix = cell2mat(freqscell);
    
    lege = strings(1, numofelements); 
    for i=1:numofelements
        if i <= 3
            linetype = "-";
        else
            linetype = "--";
        end 
        times = (1/(timestep):length(freqsmatrix(:, i))) * timestep;
        plot(times, freqsmatrix(1/(timestep):end, i), linetype);
        hold on;
        lege(i) = (cellstr(strcat('freq', num2str(i))));
    end
    legend(["ACE1_1", "ACE2_1", "ACE3_1", "ACE1_local", "ACE2_local", "ACE3_local"]);
end

% Callback function
function serverCallback(src, numofelements, file_w, timestep, steps, ~)
    global server callnum msglen;
    disp("ALE ALE");

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
    fprintf(file_w, '%f, %f, %f, %f, %f, %f,\n', ...
        data(1), data(2), data(3), data(4), data(5), data(6));

    callnum = callnum + 1;
end
