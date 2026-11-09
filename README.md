# Kubernetes, KubeVirt and Mayastor Lab on AWS

## Project Overview

This project explores running virtual machines inside Kubernetes and providing persistent, replicated storage using OpenEBS Mayastor.

The lab is deployed on AWS EC2 using Kubernetes, KubeVirt, QEMU/KVM, CDI and OpenEBS Mayastor.

The project focuses on VM deployment, persistent block storage, storage replication, volume expansion, failure testing and live migration between Kubernetes worker nodes.

## Project Goals

- Set up a three-node AWS EC2 environment.
- Install and configure Kubernetes.
- Run Ubuntu virtual machines using KubeVirt.
- Understand QEMU, KVM and nested virtualization.
- Use CDI and DataVolumes to import VM images.
- Understand Persistent Volumes and Persistent Volume Claims.
- Configure replicated block storage using OpenEBS Mayastor.
- Test volume expansion and replica-loss scenarios.
- Configure experimental RWX Block storage for KubeVirt.
- Perform live migration between worker nodes.
- Document commands, configurations and results.

## Architecture

**AWS Region:** ap-south-1 (Mumbai)

**EC2 instances:** 3 × m7i.xlarge

| Node | Private IP | Role |
|---|---|---|
| Node 1 | 172.31.14.250 | Kubernetes control plane |
| Node 2 | 172.31.1.126 | Worker |
| Node 3 | 172.31.14.149 | Worker |

Kubernetes manages the cluster workloads.

KubeVirt runs virtual machines as Kubernetes workloads.

OpenEBS Mayastor provides replicated block storage across the cluster.

## Technologies

- AWS EC2
- Ubuntu Linux 24.04
- Kubernetes v1.33.13
- kubeadm
- kubectl
- containerd
- Calico
- KubeVirt v1.8.3
- QEMU/KVM
- CDI v1.65.0
- OpenEBS Mayastor 4.5.0
- Persistent Volumes and Persistent Volume Claims
- NVMe-oF
- Git and GitHub

## Important Concepts

### EC2
Provides the cloud servers where Kubernetes nodes run.

### Kubernetes
Manages containers, Pods, networking and workloads across the cluster.

### KubeVirt
Allows virtual machines to run and be managed inside Kubernetes.

### QEMU/KVM
Provides the virtualization technology used to run guest virtual machines.

### CDI and DataVolumes
CDI imports VM disk images and creates DataVolumes backed by persistent storage.

### Persistent Storage
Stores VM disk data independently of the VM configuration.

### OpenEBS Mayastor
Provides replicated block storage using storage pools and replicas distributed across nodes.

### RWX Block Storage
Allows a block volume to be accessed with ReadWriteMany semantics. In this lab, it is used for KubeVirt live migration.

## Completed Work

### Kubernetes and KubeVirt
- Configured a three-node Kubernetes cluster.
- Installed KubeVirt and CDI.
- Configured worker nodes for VM workloads.
- Successfully deployed virtual machines.

### Mayastor Storage
- Configured three Mayastor DiskPools.
- Created a three-replica Mayastor volume.
- Verified volume availability and replica distribution.
- Tested data movement between nodes.
- Tested online volume expansion.
- Performed a replica-loss test.

### KubeVirt Live Migration with RWX Block
- Created a separate `mayastor-rwx-block` StorageClass.
- Configured two replicas using NVMe-oF.
- Created an 8 GiB Ubuntu DataVolume.
- Verified the RWX PVC reached Bound status.
- Created a KubeVirt VM using the RWX Block volume.
- Verified the VM was live-migratable.
- Successfully migrated the VM from Node 2 to Node 3.
- Verified the VM remained Running after migration.
- Verified `migrationState.completed: true`.
- Verified the KubeVirt migration record reached Succeeded.

## Known Limitations

- The OpenEBS RWX Block live migration feature is experimental and should not be considered production-ready.
- OpenEBS documentation lists three worker nodes for its migration testing prerequisite. This lab has two VM worker nodes, and migration between those two workers succeeded.
- One OpenEBS etcd member remains Pending because of insufficient CPU and persistent-volume node affinity. The other two members are Running.
- Avoid stopping or restarting cluster nodes because the etcd cluster currently has no remaining failure tolerance.

## Evidence and Documentation

- `docs/` contains project documentation and progress records.
- `evidence/` contains test results and troubleshooting records.
- `evidence/day26-28/rwx-live-migration.txt` documents the successful RWX Block live migration test.

## Cost and Security Notes

- Monitor AWS billing and resource usage regularly.
- Stop EC2 instances only when it is safe for the cluster.
- Remember that EBS volumes and other resources may continue to incur charges when EC2 instances are stopped.
- Never commit SSH private keys, AWS credentials or other secrets.
- Review configuration files before pushing them to GitHub.

## Project Status

The three-node Kubernetes and Mayastor lab is operational.

Three-replica storage, volume expansion, replica-loss testing and KubeVirt live migration using experimental RWX Block storage have been demonstrated.

Further work includes improving etcd resource availability, documenting additional recovery scenarios and completing the final project report.
