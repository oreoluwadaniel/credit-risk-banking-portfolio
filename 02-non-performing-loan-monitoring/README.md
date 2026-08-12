# Credit Portfolio Health & NPL Intelligence

**A SQL credit-risk monitoring framework that shows where portfolio risk is building, how much exposure is affected, and where risk teams should intervene first.**

A headline NPL ratio can look stable while risk is quietly increasing underneath it. A weak lending vintage, a deteriorating market, or a concentration of large delinquent exposures can change the risk profile without moving the headline number very much.

This project is built to surface those changes early.

## The business problem

Instead of asking only:

> **"What is our NPL ratio?"**

the framework asks:

- Is portfolio risk getting better or worse?
- Which segments are driving the change?
- Are large exposures becoming riskier?
- Which lending vintages are underperforming?
- Which markets carry the most risk?
- Where should collections and underwriting teams act first?

## What the system monitors

The analysis combines:

**Portfolio health**  
Current, 30 DPD, 60 DPD and NPL exposure.

**NPL concentration**  
Exposure-weighted and count-weighted NPL ratios, so a small number of large problem loans cannot hide behind a low loan count.

**Early warning signals**  
30 and 60 DPD movements before loans become non-performing.

**Vintage performance**  
Loan performance by origination month to identify weaker lending periods.

**Credit segments**  
Risk differences across customer and credit tiers.

**Geographic concentration**  
Country-level differences in portfolio quality and NPL exposure.

**Trend monitoring**  
Month-over-month changes in portfolio condition.

## The data

Synthetic lending portfolio covering:

| Metric | Volume |
|---|---:|
| Customers | 1,000 |
| Loans | 1,000 |
| Monthly loan observations | 10,000 |
| Markets | 5 |
| Lending segments | Consumer, SME, Credit Card |
| Period | Jan 2023 – Jan 2025 |

Markets include Nigeria, United Kingdom, United States, United Arab Emirates and Singapore. :contentReference[oaicite:1]{index=1}

The core tables are:

```text
customers
    ↓
loans
    ↓
loan_panel
    ↓
v_portfolio_base
    ↓
Portfolio Risk Analysis
