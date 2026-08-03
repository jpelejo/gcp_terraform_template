# ADR-001: GKE + Vault Multi-Environment Terraform Architecture

## Status
Accepted

## Context
We need a repeatable, auditable way to provision GKE clusters with HashiCorp
Vault across five environments (dev, qa, uat, preprod, prod), with a clear
promotion path and consistent security posture, reviewable under TOGAF
governance practices.

## Decision
- Use a **parent/child Terraform layout**: environment-agnostic modules
  (`modules/network`, `modules/iam`, `modules/gke`, `modules/vault`) as the
  parent architecture building blocks, and one overlay per environment
  under `environments/` as the child solution building blocks.
- Deploy **Vault via its official Helm chart** in HA/Raft mode rather than a
  standalone/dev-mode server, auto-unsealed with **Cloud KMS**, so no human
  ever handles raw unseal keys.
- Use **GCP Workload Identity** exclusively for pod-to-GCP authentication
  (GKE nodes and Vault); disable service account key creation at the org
  policy level.
- Increase security posture progressively per environment (see the table in
  `README.md`): preemptible/relaxed in `dev`, fully locked down (private
  control-plane endpoint, Binary Authorization, deletion protection, audit
  logging) from `uat` onward.
- Store Terraform state remotely in per-environment prefixes within a single
  GCS bucket created by a one-time `global/bootstrap` stack.

## Consequences
- **Positive:** A reviewed change to a module is mechanically consistent
  across all five environments; only sizing/posture variables differ.
  Security guardrails are enforced both in code (modules) and out-of-band
  (org policies), giving defense in depth.
- **Positive:** Environment promotion is visible as a diff between overlay
  directories, making change management and audits straightforward.
- **Trade-off:** Modules must stay generic enough to serve all five
  environments; environment-specific one-offs need a variable/flag added to
  every overlay rather than a quick hack in one place. This is an
  intentional constraint to preserve architectural consistency.
- **Trade-off:** Vault via Helm inside the same Terraform run as the
  cluster that hosts it creates a two-phase apply in practice (cluster must
  exist before the Helm release can be scheduled) — mitigated with explicit
  `depends_on` between `module.gke` and `module.vault`.

## Alternatives considered
- **Vault on separate dedicated VMs (not Kubernetes):** rejected — loses
  the operational consistency of running everything through GKE and adds a
  second infrastructure pattern to maintain.
- **One Terraform workspace with `count`/`for_each` over environments
  instead of separate directories:** rejected — makes it too easy for a
  single `apply` to accidentally touch `prod`, and reduces the auditability
  of per-environment `plan` output required by Implementation Governance.
