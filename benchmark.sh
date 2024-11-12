#!/bin/bash

# Array of congestion control algorithms to test
CONGESTION_ALGORITHMS=("reno" "cubic" "bbr")

# Packet loss rates, latency values, and test durations to try
LOSS_RATES=("0.01%" "1%")
LATENCIES=("5ms" "100ms")
DURATIONS=("5" "30")

# Network interface (e.g., eth0, replace it if different)
IFACE=""

# Server and client IP addresses (configure as needed)
SERVER_IP="x.x.x.x"
CLIENT_IP="x.x.x.x"

# Start iperf server
iperf3 -s -D

for algo in "${CONGESTION_ALGORITHMS[@]}"; do
  # Set the congestion control algorithm
  sysctl -w net.ipv4.tcp_congestion_control=$algo

  for loss in "${LOSS_RATES[@]}"; do
    for latency in "${LATENCIES[@]}"; do
      for duration in "${DURATIONS[@]}"; do
        echo "Testing $algo with loss $loss, latency $latency, duration $duration seconds"

        # Apply traffic control settings
        tc qdisc add dev $IFACE root netem delay $latency loss $loss

        # Run iperf3 test as client with specified duration
        iperf3 -c $SERVER_IP -t $duration > "results_${algo}_loss${loss}_latency${latency}_dur${duration}.txt"

        # Clear traffic control settings
        tc qdisc del dev $IFACE root

        echo "Completed test for $algo with loss $loss, latency $latency, duration $duration seconds"
      done
    done
  done
done

# Stop the iperf server
pkill iperf3

echo "All tests completed."
