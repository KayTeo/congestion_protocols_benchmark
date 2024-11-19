
initial_cwnd = 1;  
ssthresh = 4500;  
mss = 1500;        
max_cwnd = 65535;  
simulation_time = 100;  


cwnd = initial_cwnd;
time = 0:simulation_time-1;
cwnd_values = zeros(1, simulation_time);


for i = 1:simulation_time
    if cwnd < ssthresh
        
        cwnd = cwnd * 2;
    else
        
        cwnd = cwnd + 1;
    end
    
    
    if cwnd * mss > max_cwnd
        cwnd = floor(max_cwnd / mss);
    end
    
    
    if mod(i, 20) == 0
        ssthresh = max(floor(cwnd / 2), 2);
        cwnd = cwnd / 2;
    end
    
    cwnd_values(i) = cwnd * mss;
end


figure;
plot(time, cwnd_values, 'b-', 'LineWidth', 2);
xlabel('Time (RTTs)');
ylabel('Congestion Window Size (bytes)');
title('TCP Reno Sawtooth Congestion Window');
grid on;


