# Fraud Detection & Transaction Monitoring

**A SQL fraud-monitoring system that turns transaction, customer, account, fraud-score, and credit data into a prioritized investigation queue.**

Fraud teams do not need another table of transactions. They need to know **which transactions deserve attention first, which customers show repeated suspicious activity, and where fraud is concentrated.**

This project builds that monitoring layer for Stratavax, a fictional retail bank, using synthetic banking data.

> **Note:** The dataset is also used in the Credit Risk & Loan Default project, but the two projects answer different business questions.

## The business problem

A transaction marked suspicious is only the starting point.

An investigation team needs to answer:

- Which transactions carry the highest risk?
- Which customers have repeated suspicious activity?
- Which transaction types and markets have higher fraud rates?
- How large is the fraud problem?
- Which alerts should investigators work first?

The workflow is:

```text
Customers + Accounts
        ↓
Transactions
        ↓
Fraud Signals + Credit Profile
        ↓
Fraud Master View
        ↓
Behavioral Analysis
        ↓
Risk Classification
        ↓
Investigation Watchlist
