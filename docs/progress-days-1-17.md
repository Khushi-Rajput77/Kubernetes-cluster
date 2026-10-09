# Learning Log: Days 1–17

Project: Kubernetes, KubeVirt and Mayastor on AWS

Note: This log records the work discussed during the lab.
Verify each day's actual results before marking every task complete.

---

## Day 1 — AWS and EC2

### Work
- Launched an EC2 instance in AWS Mumbai (`ap-south-1`).
- Selected an instance with 4 vCPUs and 16 GiB RAM.
- Enabled nested virtualization.
- Checked CPU, memory and disk information.

### Commands
```bash
nproc
free -h
lsblk
ls -l /dev/kvm
