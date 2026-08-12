# Credit Risk & Banking Analytics Portfolio

**Five SQL case studies showing how a lending portfolio can be monitored from early credit deterioration through default, migration, and fraud.**

The projects use a shared synthetic loan portfolio and answer five questions a credit risk or portfolio management team needs to understand:

- Which loans are deteriorating before they default?
- Where are non-performing loans concentrated?
- How quickly are loans moving between delinquency stages?
- What characteristics are associated with default?
- Which transactions should be flagged for possible fraud?

Each case study is self-contained, with its own SQL, data, analysis, and README.

## Case Studies

| # | Case study | Business question | Main analysis |
|---|---|---|---|
| 01 | [IFRS 9 Staging & Expected Loss](01-ifrs9-staging-and-expected-loss/) | Which loans are moving into higher-risk stages, and what does that mean for expected loss? | Stage classification, vintage analysis, window functions |
| 02 | [Non-Performing Loan Monitoring](02-non-performing-loan-monitoring/) | Where is portfolio credit quality deteriorating? | NPL ratios, country and credit-tier segmentation |
| 03 | [Roll-Rate Delinquency Migration](03-roll-rate-delinquency-migration/) | How are loans moving between delinquency stages month to month? | Roll rates, transition analysis, portfolio segmentation |
| 04 | [Loan Default Risk Analysis](04-loan-default-risk-analysis/) | What characteristics separate defaulted loans from performing loans? | Default analysis, risk segmentation, SQL Server |
| 05 | [Fraud Detection & Transaction Monitoring](05-fraud-detection-transaction-monitoring/) | Which transactions should be investigated for possible fraud? | Rule-based transaction monitoring and anomaly flags |

---

## How the portfolio fits together

The five projects cover different points in the credit risk lifecycle:

```text
Early Deterioration
        ↓
IFRS 9 Staging
        ↓
Delinquency Migration
        ↓
NPL Monitoring
        ↓
Default Risk
        ↓
Fraud & Transaction Monitoring
