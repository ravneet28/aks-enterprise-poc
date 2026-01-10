
# Networking – Hub & Spoke

## Hub VNET
- Azure Firewall
- Bastion
- Private DNS
- Log Analytics

## Spoke VNET (AKS)
- Private AKS
- Internal load balancers
- Private endpoints

## Traffic Flow
Inbound: App Gateway → AKS
Outbound: AKS → Firewall → Internet
