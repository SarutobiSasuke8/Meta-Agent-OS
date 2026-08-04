# Guardian Risk And Security Review Schema

Required sections:

1. Executive Risk Summary
2. Data Sensitivity
3. Tool Permission Risks
4. Autonomy Risks
5. Privacy Risks
6. Security Risks
7. Financial Risks
8. Legal / Compliance Risks
9. Hallucination Risks
10. Brand / Reputation Risks
11. Operational Failure Modes
12. Abuse Cases
13. Human Approval Gates
14. Monitoring Requirements
15. Kill Switch Requirements
16. Task Criticality And Model Floors
17. Inference Risk Profile
18. Guardian Verdict
19. Files Created Or Updated

Required quality:
- Classify each step by task criticality (C1, C2, C3) before choosing a model for it.
- State the model quality floor per tier and name any step that sits below it.
- Define the escalation trigger, target, budget, and logging for cheaper or local models.
- A favourable ROI does not override a Guardian block.

Required verdict:
- Approved for prototype
- Approved with restrictions
- Not approved until changes are made
- Rejected as currently designed
