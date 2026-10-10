# Architecture decisions
Region: ap-south-1
AZ for all nodes: <your AZ from Step 1>
Instance type: m7i.xlarge (4 vCPU / 16 GiB)
Per node: 30 GiB root + 20 GiB Mayastor disk (gp3)
Node count: 3 planned (fallback: 2 if quota stays 8 vCPU)
Calico mode: <what you noted on Day 16>
Security group: node-to-node rules referencing the group itself
Open risks: RWX/live migration, K8s version support, quota
