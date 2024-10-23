#!/bin/bash

# Function to display CPU usage
cpu_usage() {
  echo "================== CPU USAGE =================="
  # Extract CPU statistics and calculate total CPU usage
  local idle=$(mpstat 1 1 | awk '/all/ {print $12}')
  local usage=$(echo "100 - $idle" | bc)
  echo "Total CPU usage: $usage%"
}

# Function to display memory usage
memory_usage() {
  echo "================ MEMORY USAGE =================="
  # Extract memory statistics using `free`
  free_output=$(free -m)
  total_memory=$(echo "$free_output" | awk '/Mem:/ {print $2}')
  used_memory=$(echo "$free_output" | awk '/Mem:/ {print $3}')
  free_memory=$(echo "$free_output" | awk '/Mem:/ {print $4}')
  
  # Calculate percentage used
  percentage_used=$(echo "scale=2; $used_memory/$total_memory*100" | bc)
  
  echo "Total memory: ${total_memory}MB"
  echo "Used memory: ${used_memory}MB (${percentage_used}%)"
  echo "Free memory: ${free_memory}MB"
}

# Function to display disk usage
disk_usage() {
  echo "================= DISK USAGE =================="
  # Extract disk usage statistics using `df`
  df -h --total | awk '/total/ {print "Total Disk Space: "$2"\nUsed: "$3" ("$5" used)\nAvailable: "$4}'
}

# Function to display top 5 processes by CPU usage
top_cpu_processes() {
  echo "======== TOP 5 PROCESSES BY CPU USAGE ========="
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

# Function to display top 5 processes by memory usage
top_mem_processes() {
  echo "======= TOP 5 PROCESSES BY MEMORY USAGE ======="
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
}

# Main function to call all the stats
main() {
  echo "===== SERVER PERFORMANCE STATISTICS ====="
  cpu_usage
  memory_usage
  disk_usage
  top_cpu_processes
  top_mem_processes
}

# Run the main function
main
