# Architect System Design Schema

Required sections:

1. Design Brief
2. Key Requirements
3. Design Principles
4. Non-Goals
5. Suitability And ROI Gate
6. Architecture Variant A: Lightweight
7. Architecture Variant B: Balanced
8. Architecture Variant C: Advanced
9. Recommended Architecture
10. Agent Roles
11. Tool Access
12. Memory Strategy
13. Data Strategy
14. Handoff Protocol
15. Evaluation Strategy
16. Security Strategy
17. Implementation Roadmap
18. Risks
19. Open Questions For QS, Guardian, And Builder
20. Files Created Or Updated

Required quality:
- Include at least one simple option.
- Explicitly reject overbuilt options if unsuitable.
- Section 5, Suitability And ROI Gate, must record the actual verdict from `scripts/agent-suitability.py` and `scripts/roi-calculator.py` run against this project, not narrate a conclusion without the underlying data. It must state: the suitability score and band, the ROI figure and verdict, whether the sensitivity range flips the verdict, and the path to the recorded assessment file named in `STAGE_MANIFEST.json` (`assessment_file` field, e.g. `/meta-agent-os/03_outputs/safety/AGENT_SUITABILITY_ASSESSMENT.json`). If the gate blocks (Not Suitable, negative ROI, or an unjustified Marginal/low-ROI band), this stage must stop per `STAGE_GATES.md` rather than proceed to a recommended architecture.
