# azure-resource-locks-governance


![Azure](https://img.shields.io/badge/Azure-Governance-0089D6?style=flat&logo=microsoftazure)
![IaC](https://img.shields.io/badge/IaC-Bicep-0078D4?style=flat)
![Security](https://img.shields.io/badge/Control_Plane-Locked-critical)

## 📌 Project Overview


This project implements defense-in-depth governance using **Azure Resource Locks** (`CanNotDelete` and `ReadOnly`) across an Ubuntu compute workload and its underlying virtual network infrastructure. The architecture is defined and deployed declaratively using **Azure Bicep**.

---

## 🛠️ Architecture & Governance Policy Matrix

The deployment provisions a complete compute stack with governance locks enforced at two distinct scopes:

```text
Resource Group (rg-lock-demo)  <-- [ReadOnly Lock Applied]
│
├── Virtual Network (vnet-eastus-1 / 172.16.0.0/16)  (Inherits ReadOnly)
├── Subnet (snet-eastus-1 / 172.16.0.0/24)          (Inherits ReadOnly)
├── Network Security Group (vm1-nsg / SSH Port 22)  (Inherits ReadOnly)
├── Public IP (vm1-ip / Standard Regional)          (Inherits ReadOnly)
├── Network Interface (vm1338)                       (Inherits ReadOnly)
└── Virtual Machine (vm1 / Ubuntu 24.04 LTS)        <-- [CanNotDelete Lock + Inherited ReadOnly]
