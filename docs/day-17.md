# Day 17 — KubeVirt Consolidation

## Goal
Rebuild the Ubuntu VM, check persistent storage, diagnose a
scheduling failure, and assess node capacity.

## Checklist

- [ ] Kubernetes node is Ready.
- [ ] KubeVirt Pods are healthy.
- [ ] Extra DataVolume is available.
- [ ] Existing VM configuration is backed up.
- [ ] VM is recreated from the clean YAML file.
- [ ] SSH connection works.
- [ ] Cloud-init completes successfully.
- [ ] QEMU guest agent is active.
- [ ] Extra disk is attached and existing data is verified.
- [ ] /dev/kvm exists in the launcher compute container.
- [ ] VM domain uses KVM.
- [ ] Scheduling failure is diagnosed and fixed.
- [ ] CPU and memory availability are recorded.
- [ ] AWS instance quota is checked.
- [ ] Project files are committed to Git.

## Useful Commands

Check the cluster:
```bash
kubectl get nodes
kubectl get pods -n kubevirt
