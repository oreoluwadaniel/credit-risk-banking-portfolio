# Credit Decisioning & Portfolio Risk Intelligence

**A SQL credit-risk analysis that turns loan, payment, customer, and credit-score data into a single portfolio view for default monitoring and lending decisions.**

The core problem is simple: a portfolio-wide default rate tells you what happened, but it does not tell you **who is driving the risk or how an underwriting team should respond**.

This project builds a loan-level risk view, segments borrowers by meaningful risk factors, and applies a rule-based decision framework to support **Approve, Review, or Reject** recommendations.

> **Note:** The data and results are synthetic and are used to demonstrate the analysis approach.

## The business questions

- Which borrower segments have the highest default rates?
- How does credit quality relate to default?
- Does risk vary by loan product, income band, country, or interest-rate range?
- Which loans should receive additional underwriting review?
- How much can poor data modeling distort portfolio risk metrics?

## How it works

```text
Customers + Credit Scores
          ↓
        Loans
          ↓
     Loan Payments
          ↓
Payment Aggregation
          ↓
   Credit Master View
          ↓
Portfolio Risk Analysis
          ↓
Risk Segmentation
          ↓
Approve | Review | Reject
