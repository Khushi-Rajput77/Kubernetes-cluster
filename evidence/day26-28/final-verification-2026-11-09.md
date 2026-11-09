# Final Verification — KubeVirt + OpenEBS Mayastor
Date: 9 November 2026

## Environment
- AWS region: ap-south-1
- EC2 nodes: 3 × m7i.xlarge
- Kubernetes: v1.33.13
- Ubuntu: 24.04.5 LTS
- containerd: 2.2.1
- Calico: v3.31.3
- KubeVirt: v1.8.3
- CDI: v1.65.0
- OpenEBS Mayastor: 4.5.0

## Kubernetes nodes
All three Kubernetes nodes reported Ready:
- Control plane: ip-172-31-14-250 (172.31.14.250)
- Worker 1: ip-172-31-1-126 (172.31.1.126)
- Worker 2: ip-172-31-14-149 (172.31.14.149)

## KubeVirt RWX Block live migration
- StorageClass: mayastor-rwx-block
- Protocol: NVMe-oF (nvmf)
- Replicas: 2
- RWX Block enabled; thin provisioning enabled
- DataVolume: ubuntu-rwx-block
- PVC: ubuntu-rwx-block — Bound, 8 GiB, RWX, Block
- VM: vm-rwx — Running, Ready
- Initial VM worker: ip-172-31-1-126
- Destination worker: ip-172-31-14-149
- Migration command: virtctl migrate vm-rwx
- Migration object: kubevirt-migrate-vm-sc9cp
- Migration phase: Succeeded
- VMI migrationState.completed: true
- Final VMI: Running, Ready, Live-migratable True
- Final VMI IP: 192.168.57.139

The Kubernetes-level migration and VM Running/Ready state were verified. Guest OS login and guest-level disk/data-integrity after migration were not verified.

## Mayastor DiskPools
All three DiskPools reported Online and Healthy, with no reported error:
- pool-node-1 (control plane): 20 GiB total; approximately 3.6 GiB used; 16.4 GiB free
- pool-node-2 (worker 1): 20 GiB total; approximately 104 MiB used; 19.9 GiB free
- pool-node-3 (worker 2): 20 GiB total; approximately 3.6 GiB used; 16.4 GiB free

Total configured DiskPool capacity: 60 GiB. Approximate available capacity: 52.7 GiB.

## OpenEBS component status
The API, CSI controller (6/6), CSI node pods on all three nodes (2/2), all three IO engines (2/2), all three NATS pods (3/3), agents, LocalPV provisioner and DiskPool operator were Running.

## Known etcd limitation — do not ignore
- openebs-etcd-0: Running (1/1)
- openebs-etcd-1: Pending (0/1)
- openebs-etcd-2: Running (1/1)

The Pending member's scheduling events reported:
`0/3 nodes are available: 1 Insufficient cpu, 2 node(s) didn't match PersistentVolume's node affinity.`

Two etcd members retained quorum, but the cluster had no remaining etcd-member failure tolerance. Another unavailable healthy member could cause loss of quorum and affect Mayastor control-plane/management operations.

Do not hard-stop, restart or casually modify nodes, etcd PVCs/PVs, DiskPools or Mayastor volumes while this condition remains. Resolve resource and PV placement constraints deliberately before further failure testing.

## Scope and feature caveats
- Mayastor RWX Block for KubeVirt live migration is experimental; this lab result is not a production-readiness claim.
- OpenEBS migration test documentation lists three worker nodes as a prerequisite; this lab has two VM worker nodes. Migration between those two workers succeeded.
- A guest-level login and data-integrity check remain outstanding.
