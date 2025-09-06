#!/usr/bin/env bash
# fc_threads_host.sh - 统计每个 firecracker 进程（宿主机侧）的线程数

########################错误的####################
set -euo pipefail

total_threads=0

# 找出所有 firecracker 进程的 PID
pids=$(pgrep -x firecracker || true)
if [ -z "$pids" ]; then
  echo "No firecracker process found."
  exit 0
fi

for pid in $pids; do
  # 尝试从命令行里取 --id 作为名字；没有就用 pid
  cmdline=$(tr '\0' ' ' < /proc/$pid/cmdline)
  name=$(sed -n 's/.*--id \([^ ]*\).*/\1/p' <<<"$cmdline")
  [ -z "${name:-}" ] && name="pid-$pid"

  thread_count=$(ls "/proc/$pid/task" | wc -l | awk '{print $1}')
  echo "$name ($pid): $thread_count threads"
  total_threads=$((total_threads + thread_count))
done

echo "--------------------------------"
echo "Total threads across all firecracker processes: $total_threads"
