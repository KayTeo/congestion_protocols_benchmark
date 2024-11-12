% Parameters
cwnd_init = 1;         % Initial congestion window size (MSS units)
cwnd_max = 100;        % Maximum congestion window before packet loss
cwnd_min = cwnd_init;  % Minimum congestion window (reset after loss)
alpha = 1;             % Additive increase factor (for each RTT)
beta = 0.5;            % Multiplicative decrease factor (on packet loss)
num_cycles = 5;        % Number of sawtooth cycles to simulate

% Initialize variables
cwnd = cwnd_init;      % Current congestion window size
time = 0;              % Current time
RTT = 1;               % Round-trip time (RTT, in arbitrary time units)
time_array = [];
cwnd_array = [];

% Simulate TCP Reno's sawtooth pattern
for cycle = 1:num_cycles
    % Additive Increase phase (until cwnd reaches cwnd_max)
    while cwnd < cwnd_max
        time_array = [time_array, time];
        cwnd_array = [cwnd_array, cwnd];
        
        % Increment congestion window
        cwnd = cwnd + alpha;
        time = time + RTT;
    end
    
    % Multiplicative Decrease phase (packet loss event)
    time_array = [time_array, time];
    cwnd_array = [cwnd_array, cwnd];
    
    % Apply multiplicative decrease
    cwnd = max(cwnd * beta, cwnd_min);
    time = time + RTT;
end

% Plot the results
figure;
plot(time_array, cwnd_array, '-b', 'LineWidth', 2);
title('TCP Reno Steady-State Sawtooth');
xlabel('Time (RTT units)');
ylabel('Congestion Window (cwnd, in MSS units)');
grid on;
