# IFRS 9 Credit Risk Staging & Expected Loss

**A SQL credit-risk monitoring system built to answer a practical question: where is the loan book deteriorating before that deterioration becomes a default?**

Default is a late signal. By then, risk has already built up.

This project uses monthly loan-performance data to classify loans into simplified IFRS 9-style stages, track movement between stages, estimate expected loss, and identify the borrower segments and lending vintages driving deterioration.

## The business problem

A credit team should not have to wait for Stage 3 balances or defaults to rise before investigating risk.

The monitoring layer therefore focuses on:

- Which loans are moving into higher-risk stages?
- How quickly is that happening?
- How much exposure is affected?
- What expected loss sits behind the deterioration?
- Which credit bands and lending vintages are driving it?

The workflow is:

```text
Loan Performance
      ↓
Stage Classification
      ↓
Stage Migration
      ↓
Exposure
      ↓
Expected Loss
      ↓
Risk Segmentation
      ↓
Management Action
