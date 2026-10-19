# Architecture decisions
Region: ap-south-1
AZ for all nodes: <your AZ from Step 1>
Instance type: m7i.xlarge (4 vCPU / 16 GiB)
Per node: 30 GiB root + 20 GiB Mayastor disk (gp3)
Node count: 3 planned (fallback: 2 if quota stays 8 vCPU)
Calico mode: <what you noted on Day 16>
Security group: node-to-node rules referencing the group itself
Open risks: RWX/live migration, K8s version support, quota
## Day 21: Infrastructure Decisions

### Budget and node count
- Maximum AWS credits: $200
- Maximum EC2 nodes: 3
- Planned instance type: m7i.xlarge
- Planned total CPU: 12 vCPUs
- No fourth node will be launched.

### Node topology
- Node 1: Kubernetes control plane and worker-capable node
- Node 2: Kubernetes worker
- Node 3: Kubernetes worker
- Mayastor storage engines planned across all three nodes,
  subject to scheduling and resource requirements.

### Current software
- Kubernetes: v1.37.1
- KubeVirt: v1.9.0
- Container runtime: containerd
- Existing storage: local-path

### Storage plan
- Keep existing VM data disks intact.
- Use dedicated storage devices for Mayastor.
- Reserve the required HugePages on storage nodes.
- Load nvme_tcp on every storage node at boot.

### Migration plan
- Primary goal: test KubeVirt live migration using
  Mayastor experimental RWX block volumes.
- Fallback: cold migration using replicated storage.
- Verify compatibility before installation.

### Known risks
- Kubernetes v1.37.1 is outside KubeVirt v1.9's
  documented supported Kubernetes range.
- Mayastor RWX block support for live migration is experimental.
- Three nodes require careful CPU, RAM, and storage planning.
- AWS spending must remain within the $200 credit limit.

## Day 21 decisions
- Rebuilt on Kubernetes v1.33.13 to match the OpenEBS KubeVirt migration example (validated on v1.33.12)
- OS: Ubuntu 24.04.5 LTS, kernel 7.0.0-1013-aws (newer than Mayastor's tested 5.15, unverified)
- containerd 2.2.1 with SystemdCgroup=true and device_ownership_from_security_context=true
- Hugepages: 1024 x 2 MiB, persistent via sysctl; nvme_tcp persistent via modules-load.d
- CNI: Calico v3.31.3, pod CIDR 192.168.0.0/16
- Nodes: 3 x m7i.xlarge in ap-south-1b, quota 16 vCPU
- Node 1: control plane + Mayastor; VMs planned on Nodes 2 and 3
