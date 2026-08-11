# Credit Risk & Banking Analytics Portfolio

Five SQL case studies on a synthetic multi-market lending portfolio. Same underlying loan dataset, five different angles a credit risk or portfolio management team actually needs: how loans are staged and provisioned, how many have gone bad, how they migrate between delinquency stages, what predicts default, and how fraud gets caught in the transaction stream.

Each case study is self-contained with its own SQL, data, and README. This top-level README is the map.

## Case studies

| # | Case study | Question it answers | Technique |
|---|---|---|---|
| 01 | [IFRS 9 staging and expected loss](01-ifrs9-staging-and-expected-loss/) | Which loans are deteriorating right now, before they default? | Window functions, CTEs, vintage cohort staging |
| 02 | [Non-performing loan monitoring](02-non-performing-loan-monitoring/) | What's the NPL ratio, and where is it concentrated by tier and country? | Segmentation, cohort performance |
| 03 | [Roll-rate delinquency migration](03-roll-rate-delinquency-migration/) | How do loans move between delinquency stages month to month? | Roll-rate KPIs by credit tier, country, loan size |
| 04 | [Loan default risk analysis](04-loan-default-risk-analysis/) | What separates a loan that defaults from one that doesn't? | SQL Server portfolio risk analysis |
| 05 | [Fraud detection and transaction monitoring](05-fraud-detection-transaction-monitoring/) | Which transactions look like fraud, and how fast can that be flagged? | Real-time-style transaction monitoring rules |

## Why these are grouped together

They share one dataset and one domain, so splitting them into five separate repositories didn't add anything. Grouping them here makes the range easier to see in one pass: staging and provisioning, portfolio monitoring, behavioral migration, predictive risk, and fraud, all built on the same lending data.

01 (IFRS 9 staging) is the most technically involved of the five: multi-step window functions, layered CTEs, and calendar-month vintage cohorting. Start there if you only have time for one.

## Tools

SQL Server (T-SQL) and PostgreSQL, depending on the case study. See each subfolder's README for the specific dialect and schema.

## Data

All datasets are synthetic, built to resemble real lending exports without containing any real customer or institutional data.

## Contact

Daniel Olatunji (Lagos, Nigeria)
Email: oluwafikayore@gmail.com
