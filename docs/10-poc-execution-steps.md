
# PoC Execution Steps (Validated)

## Phase 1 – Landing Zone
Steps:
1. Management groups
2. Subscriptions
3. Policies
4. Logging

Validation:
- Policies enforced
- Logs centralized

---

## Phase 2 – Networking
Steps:
1. Hub VNET
2. Firewall
3. DNS
4. Peering

Validation:
- Firewall logs show egress
- Private DNS resolves

---

## Phase 3 – AKS
Steps:
1. Private AKS
2. Node pools
3. ACR integration
4. Workload identity

Validation:
- No public API
- Pods pull images without secrets
