# Roll Rate & Delinquency Migration Analysis

**A SQL early-warning system that tracks how loans move between delinquency stages, helping collections teams identify deterioration before it becomes NPL.**

A portfolio can have a stable NPL ratio while risk is getting worse underneath it. Borrowers may be moving from Current to 30 DPD, skipping stages, or failing to cure. A static NPL report will not show that movement.

This project tracks those month-to-month transitions and turns them into roll rates, transition probabilities, and segment-level risk signals.

## The business problem

Instead of asking only:

> **"How many loans are already non-performing?"**

the analysis asks:

- Which delinquent loans are getting worse?
- Which borrowers are curing?
- How quickly are loans moving toward 90+ DPD?
- Are some segments deteriorating faster than others?
- Are borrowers skipping delinquency stages?
- Where should collections intervene first?

## How it works

```text
Monthly Loan Panel
        ↓
Data Validation
        ↓
Delinquency Classification
(Current → 30 → 60 → 90+)
        ↓
Previous-Month Status
        ↓
Transition Matrix
        ↓
Roll Rates & Probabilities
        ↓
Segment Analysis
        ↓
Early Warning Indicators
