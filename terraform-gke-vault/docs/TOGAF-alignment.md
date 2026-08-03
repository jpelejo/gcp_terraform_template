# TOGAF ADM Alignment

This document maps the repository structure and workflow to the TOGAF
Architecture Development Method (ADM) so the codebase can be reviewed and
governed as an architecture deliverable, not just a script collection.

| ADM Phase | Applied in this repo |
|---|---|
| **Preliminary** | `global/bootstrap` establishes the foundational capability (governed, versioned Terraform remote state) that every subsequent phase depends on. Naming, tagging, and module conventions in `README.md` are the "architecture principles" for this repo. |
| **A — Architecture Vision** | The overall goal — a consistent, promotable GKE + Vault platform across five environments — is captured in the root `README.md` and `docs/architecture-decision-records/ADR-001-gke-vault-architecture.md`. |
| **B — Business Architecture** | The environment ladder (dev → qa → uat → preprod → prod) reflects the organization's release/promotion process and change-approval stages. |
| **C — Information Systems Architecture** | Vault's role as the central secrets/identity system, and its integration with GKE Workload Identity, is the "application/data architecture" concern captured in `modules/vault` and `modules/iam`. |
| **D — Technology Architecture** | `modules/network`, `modules/nat`, and `modules/gke` are the Technology Architecture building blocks: addressing, egress connectivity, compute, and platform standards - each expressed once, as a separately reasoned-about concern, and reused across environments. |
| **E — Opportunities & Solutions** | `environments/dev` and `environments/qa` are where new architecture building blocks are first realized and validated at low risk before wider rollout. |
| **F — Migration Planning** | The environment ladder itself *is* the migration plan: a change is proven in `dev`/`qa`, rehearsed in `uat`/`preprod`, and only then promoted to `prod`. The posture table in `README.md` documents what changes (and what stays constant) at each step. |
| **G — Implementation Governance** | `global/org-policies` encodes non-negotiable guardrails (no SA keys, no public node IPs, OS Login) enforced independent of any single environment. Module version pins (`versions.tf`) and required `terraform plan` review before `apply` are the implementation governance gate. |
| **H — Architecture Change Management** | Because environments only differ in `variables.tf` / `terraform.tfvars` / a handful of flags in `main.tf`, architecture changes are made once in `modules/*`, reviewed via pull request, and mechanically promoted — giving traceable, auditable change management. |

## Building block classification

- **Architecture Building Blocks (ABBs)** — `modules/network`, `modules/nat`,
  `modules/iam`, `modules/gke`, `modules/vault`. Environment-agnostic,
  reusable, versioned. Changes here go through architecture review (they
  affect every environment).
- **Solution Building Blocks (SBBs)** — `environments/*`. Concrete
  instantiations of the ABBs with environment-specific sizing and risk
  posture. Changes here are lower-risk and environment-scoped.

## Governance checkpoints suggested for CI/CD

1. `terraform validate` + `terraform fmt -check` on every PR (structural
   conformance).
2. `terraform plan` posted to the PR for the target environment only.
3. Manual approval gate before `apply` on `uat`, `preprod`, and `prod`
   (Implementation Governance / Change Management).
4. Policy-as-code scan (e.g. OPA/Conftest or `tfsec`) against the plan
   output, enforcing the same guardrails as `global/org-policies`.
