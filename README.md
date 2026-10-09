# Kubernetes, KubeVirt and Mayastor Lab on AWS

## Project Overview

This project explores how to run virtual machines inside Kubernetes
and how persistent storage can be used for VM data.

The lab is being built on AWS using EC2, Kubernetes, KubeVirt and,
in a later phase, OpenEBS Mayastor.

## Project Goals

- Set up an AWS EC2 environment.
- Install and understand Kubernetes.
- Run an Ubuntu virtual machine using KubeVirt.
- Understand QEMU, KVM and nested virtualization.
- Learn cloud-init for automatic VM configuration.
- Understand container disks, DataVolumes, PVs and PVCs.
- Explore persistent storage and Mayastor replication.
- Test VM recovery and live migration.
- Document commands, configurations and results.

## Planned Architecture

AWS ap-south-1 (Mumbai)
|
|-- EC2 Node 1
|-- EC2 Node 2
|-- EC2 Node 3
     |
     Kubernetes
     |
     |-- KubeVirt: runs virtual machines
     |
     |-- OpenEBS Mayastor: planned replicated storage

The three-node architecture is the target design.
The cluster currently began as a single-node setup.

## Technologies

- AWS EC2
- Ubuntu Linux
- Kubernetes
- kubeadm
- kubectl
- containerd
- Calico
- KubeVirt
- QEMU/KVM
- CDI and DataVolumes
- Persistent Volumes and Persistent Volume Claims
- OpenEBS Mayastor (planned)
- Git and GitHub

## Important Concepts

### EC2
Provides the cloud server where the Kubernetes node runs.

### Kubernetes
Manages containers, Pods, networking and workloads.

### KubeVirt
Allows virtual machines to run inside Kubernetes.

### QEMU/KVM
Provides the virtualization technology used to run the guest VM.

### Cloud-init
Automatically configures a VM during its first boot.

### Persistent Storage
Keeps VM data separately from the VM configuration so the data
can survive VM replacement, depending on the storage configuration.

### Mayastor
Planned storage layer for replicated block storage and recovery tests.

## Progress

See `docs/progress-days-1-17.md` for the learning log.

See `docs/day-17.md` for the Day 17 checklist and results.

## Cost and Security Notes

- Check AWS billing and resource usage regularly.
- Stop EC2 instances when the lab is not in use.
- EBS volumes and other resources may still incur charges when
  an EC2 instance is stopped.
- Never commit private SSH keys, AWS credentials or private keys.
- Review configuration files before pushing them to GitHub.

## Project Status

In progress. The planned three-node Mayastor architecture and
all recovery tests must be verified before they can be marked complete.
