# Technical Report — G1-360M V18.2 Production F16

**Team ID:** gss-llp-g1
**Domain:** corporate_enterprise
**Model:** G1-360M_V18.2_PRODUCTION_F16

---

## Problem

African enterprises — from SMEs in Kampala to government institutions across East Africa — operate under significant infrastructure constraints: intermittent internet connectivity, limited cloud budgets, data-sovereignty requirements, and a shortage of AI-enabled tooling built for practical business operations rather than general-purpose chat.

Existing large language models are too large, cloud-dependent, or too general to be deployed directly inside enterprise software, internal tools, or offline business workflows in this environment.

G1-360M was built to solve this gap: a compact, enterprise-focused AI model that runs fully offline on a standard laptop or workstation, reasons practically about business systems, and can be embedded directly into enterprise applications, APIs, and workflows without requiring a cloud connection or specialized GPU hardware.

The target user is an enterprise developer, business-process team, or system integrator in Africa who needs a local AI model they can integrate into internal software — not a general-purpose chatbot, but a model that reasons about business rules, validates data, explains API errors, analyzes workflows, and provides structured enterprise reasoning on any machine with 8 GB of RAM. When deployed via Ollama desktop, the model runs comfortably with as little as 4 GB of available RAM.

---

## Design Decisions

- **Base model:** G1-360M — a 360M-parameter transformer language model developed from scratch by Gaston Software Solutions LLP (GSS-LLP), Kampala, Uganda. Not a fine-tune of an existing public model.
- **Training data:** Derived from GSS Connect Product 002, a structured proprietary dataset of enterprise business and API knowledge, converted into supervised fine-tuning (SFT) instruction-response pairs.
- **Training pipeline:** Initial SFT on Product-002-derived data (V14), followed by behavioral-repair training on 1,200 targeted records addressing arithmetic correctness, constraint following, offline resilience, security reasoning, decision reasoning, enterprise architecture reasoning, data validation, self-correction, and instruction following (V15). Continued SFT using LoRA adaptation on Tesla T4 / FP16 hardware through V15 → V18 → V18.2.
- **Format:** GGUF F16 — full precision retained for maximum output quality. At 360M parameters, F16 fits within the 8 GB evaluation profile. When run via Ollama desktop, memory usage drops to approximately 4 GB.
- **Alternatives considered:** Q4_K_M quantization was evaluated but produced measurable degradation in structured enterprise reasoning outputs. F16 was selected as the production format because the model is compact enough that full precision is affordable within the memory budget.
- **Runtime:** llama.cpp — selected for its portability, CPU inference performance, GGUF native support, and zero external dependencies.

---

## Constraints

- **Target hardware:** 4 vCPU, 8 GB RAM, integrated GPU only (standard ADTC evaluation profile). G1-360M F16 loads in approximately 4 GB RAM, leaving headroom for the OS and application layer.
- **Connectivity:** Zero external network calls during inference. Model runs entirely from local weights. Designed explicitly for offline enterprise environments.
- **Data:** Training data is proprietary (GSS Connect Product 002). The model is not derived from any publicly released base model weights.
- **License:** G1-360M is distributed under the G1-360M Commercial License. The license permits corporate and enterprise use, fine-tuning, and customization. Full license: https://www.g1-license.gss-tec.com/

---

## Benchmarks

| Metric | Value |
|---|---|
| Machine | Intel Core i5-8350U @ 1.70GHz / 7.9 GB RAM / Kali Linux (WSL2) |
| llama.cpp build | b4770 (58d07a80) |
| Model size on disk | ~690 MB (GGUF F16) |
| RAM at peak load | ~782 MB RSS (standard); ~4 GB via Ollama desktop |
| Prompt processing | **85.10 tokens/s** (pp=512, CPU only, 5-sample avg) |
| Token generation | **15.53 tokens/s** (tg=128, CPU only, 5-sample avg) |
| Thermal throttling | None observed during standard inference runs |
| Offline capable | Yes — zero network calls during inference |

Measured with the official `llama-bench` binary (b4770) on the participant laptop via WSL2. Official scores are measured by the ADTC profiler on the standard evaluation machine.

---

## Enterprise Capabilities

G1-360M V18.2 is designed to assist with:

- **Business workflow reasoning** — transaction flows, operational rules, process validation
- **Enterprise architecture** — component analysis, lifecycle states, system dependencies
- **API and integration reasoning** — inputs, outputs, authorization, failure handling
- **Security reasoning** — input validation, access boundaries, authorization controls
- **Data validation** — required fields, identifier validation, acceptance rules
- **Decision reasoning** — trade-off analysis, priority selection, constraint-based decisions
- **Offline resilience** — business continuity when external systems are unavailable

---

## Developer

**Gaston Software Solutions LLP (GSS-LLP)**
Registration No. 80041130611335
Kampala, Uganda
Website: https://www.gss-tec.com
Email: info@gss-tec.com
Telephone: +256 755 274955

---

## Model Card

Full model card and documentation: https://huggingface.co/gsstec/G1-360M_V18.2_PRODUCTION_F16
