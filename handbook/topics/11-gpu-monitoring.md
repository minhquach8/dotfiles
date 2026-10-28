# NVIDIA GPU — Shared Server Monitoring
<!-- search: gpu nvidia-smi cuda rtx 5080 vram utilisation utilization memory temperature pytorch driver nvcc processes monitoring -->

Monitor GPU resources before starting demanding research
jobs. This guide uses read-only inspection commands.

## Verified server hardware

The inspected Linux workstation has:

- GPU: NVIDIA GeForce RTX 5080.
- Driver version: 580.142.
- Reported GPU memory: 16303 MiB.

These values describe the inspected workstation and
must not be assumed on other research machines.

## Basic GPU monitoring

| Command | Description |
| --- | --- |
| `nvidia-smi` | Show GPU status and active processes |
| `nvidia-smi -L` | List detected NVIDIA GPUs |
| `nvidia-smi -l 2` | Refresh the GPU status every two seconds |
| `nvidia-smi --help-query-gpu` | List supported GPU query fields |

Use Ctrl+C to stop the continuous monitoring display.
This stops the monitoring command, not other GPU jobs.

## Detailed utilisation and memory

~~bash
nvidia-smi --query-gpu=index,name,driver_version,memory.total,memory.used,memory.free,utilization.gpu,temperature.gpu --format=csv,noheader
~~

`memory.used` is occupied GPU memory, not a direct
measurement of how actively the GPU is computing.

A GPU can show low utilisation while still holding
substantial memory allocations.

Utilisation is sampled over an interval; it is not
a complete picture of every workload.

## Inspect GPU compute processes

~~bash
nvidia-smi --query-compute-apps=pid,process_name,used_gpu_memory --format=csv,noheader
~~

Some platforms and driver configurations may not
expose every process field.

Inspect a process only when authorised:

~~bash
ps -o user,pid,etime,cmd -p PID
~~

Replace `PID` with the relevant numeric process ID.

Do not kill other users' jobs, reset the GPU or reboot
a shared server simply because GPU memory is occupied.

## CUDA and Python

| Command | Description |
| --- | --- |
| `nvidia-smi` | Check the NVIDIA driver and GPU |
| `nvcc --version` | Check the CUDA compiler, if installed |

The CUDA version displayed by nvidia-smi describes
driver-supported CUDA compatibility. It does not
prove that a matching CUDA toolkit or nvcc is installed.

If PyTorch is installed in the active environment:

~~bash
python -c 'import torch; print(torch.cuda.is_available())'
~~

A False result requires further investigation of the
environment, PyTorch build and driver compatibility.

Do not assume that simply installing a CUDA toolkit
will resolve a PyTorch configuration problem.

## Research job etiquette

Before starting a long GPU experiment, check the
available GPU memory, existing processes and any
local scheduling or resource-allocation policy.

Avoid launching overlapping training runs without
understanding their combined resource requirements.

Record the GPU model, driver, framework version and
relevant environment configuration alongside results.

Use user-local tools and contact the system
administrator for system-wide driver or CUDA changes.

Official reference:
https://docs.nvidia.com/deploy/nvidia-smi/
