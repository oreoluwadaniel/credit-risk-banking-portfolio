# Fraud Detection & Transaction Monitoring

**A SQL fraud-monitoring system that turns transaction activity into a prioritized investigation queue.**

Fraud teams cannot investigate every transaction equally. The useful question is not simply "how many transactions were fraudulent?" It is **which transactions and customers deserve attention first, and where is suspicious activity concentrating?**

This project builds that monitoring layer for Stratavax Bank, a fictional retail bank, using synthetic transaction, customer, account, fraud-score, and credit data.

## The business problem

The analysis is built around five operational questions:

- Which transactions need a second look?
- Which customers show repeated fraudulent activity?
- Which transaction types carry more fraud exposure?
- Which markets have unusually high fraud volume?
- How can investigators prioritize alerts instead of reviewing transactions in arrival order?

## How it works

```text
Transactions
     +
Accounts + Customers
     +
Fraud Signals + Credit Scores
            ↓
      Fraud Master View
            ↓
   Behavioral Profiling
            ↓
     Risk Classification
            ↓
    Investigation Queue
