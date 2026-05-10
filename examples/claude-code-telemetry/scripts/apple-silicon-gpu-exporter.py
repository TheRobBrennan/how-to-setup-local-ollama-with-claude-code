#!/usr/bin/env python3
"""
Apple Silicon GPU/ANE/CPU metrics exporter for Prometheus textfile collector.

Samples `sudo powermetrics` every SAMPLE_INTERVAL_S seconds and writes
Prometheus-format metrics to a .prom file that node_exporter reads via
--collector.textfile.directory.

Usage:
    python3 apple-silicon-gpu-exporter.py [textfile_dir]

Requirements:
    - macOS with Apple Silicon (M1/M2/M3/M4)
    - Passwordless sudo rule for /usr/bin/powermetrics
      Run: npm run telemetry:gpu:setup
"""

import os
import plistlib
import signal
import subprocess
import sys
import time

TEXTFILE_DIR = sys.argv[1] if len(sys.argv) > 1 else "/tmp/node-exporter-textfile"
PROM_FILE = os.path.join(TEXTFILE_DIR, "apple_silicon.prom")
SAMPLE_INTERVAL_S = 15
POWERMETRICS_INTERVAL_MS = 1000


def handle_signal(sig, frame):
    if os.path.exists(PROM_FILE):
        os.remove(PROM_FILE)
    sys.exit(0)


signal.signal(signal.SIGTERM, handle_signal)
signal.signal(signal.SIGINT, handle_signal)


def sample_powermetrics():
    try:
        result = subprocess.run(
            [
                "sudo", "powermetrics",
                "--samplers", "gpu_power,cpu_power",
                "-f", "plist",
                "-n", "1",
                "-i", str(POWERMETRICS_INTERVAL_MS),
            ],
            capture_output=True,
            timeout=15,
        )
        if result.returncode != 0:
            print(f"powermetrics error: {result.stderr.decode().strip()}", file=sys.stderr, flush=True)
            return None
        raw = result.stdout.split(b"\x00")[0]
        return plistlib.loads(raw)
    except subprocess.TimeoutExpired:
        print("powermetrics timed out", file=sys.stderr, flush=True)
        return None
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr, flush=True)
        return None


def write_prom(data):
    lines = []
    gpu = data.get("gpu", {})
    proc = data.get("processor", {})

    idle_ratio = gpu.get("idle_ratio")
    if idle_ratio is not None:
        utilization = max(0.0, min(1.0, 1.0 - idle_ratio))
        lines += [
            "# HELP apple_silicon_gpu_utilization_ratio GPU utilization (0=idle, 1=fully busy)",
            "# TYPE apple_silicon_gpu_utilization_ratio gauge",
            f"apple_silicon_gpu_utilization_ratio {utilization:.4f}",
        ]

    dvfm = gpu.get("dvfm_states", [])
    if dvfm:
        total_ratio = sum(s.get("used_ratio", 0) for s in dvfm)
        if total_ratio > 0:
            weighted_mhz = sum(s.get("freq", 0) * s.get("used_ratio", 0) for s in dvfm) / total_ratio
        else:
            weighted_mhz = dvfm[0].get("freq", 0)
        lines += [
            "# HELP apple_silicon_gpu_frequency_hz Effective GPU frequency in Hz (weighted avg across P-states)",
            "# TYPE apple_silicon_gpu_frequency_hz gauge",
            f"apple_silicon_gpu_frequency_hz {int(weighted_mhz * 1_000_000)}",
        ]

    for key, help_text in [
        ("gpu_power",      "GPU power consumption in milliwatts"),
        ("ane_power",      "Neural Engine (ANE) power consumption in milliwatts"),
        ("cpu_power",      "CPU power consumption in milliwatts"),
        ("combined_power", "Total SoC power consumption in milliwatts"),
    ]:
        val = proc.get(key)
        if val is not None:
            metric = f"apple_silicon_{key}_mw"
            lines += [
                f"# HELP {metric} {help_text}",
                f"# TYPE {metric} gauge",
                f"{metric} {val:.2f}",
            ]

    tmp = PROM_FILE + ".tmp"
    with open(tmp, "w") as f:
        f.write("\n".join(lines) + "\n")
    os.replace(tmp, PROM_FILE)


def main():
    os.makedirs(TEXTFILE_DIR, exist_ok=True)
    print(f"Apple Silicon GPU exporter started. Writing to: {PROM_FILE}", flush=True)
    while True:
        data = sample_powermetrics()
        if data:
            write_prom(data)
        else:
            print("No data from powermetrics, retrying...", file=sys.stderr, flush=True)
        time.sleep(SAMPLE_INTERVAL_S)


if __name__ == "__main__":
    main()
