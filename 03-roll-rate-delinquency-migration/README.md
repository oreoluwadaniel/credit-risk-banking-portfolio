# Roll Rate & Delinquency Migration Analysis (Early Warning System)

## Project Overview

Non-Performing Loan (NPL) ratios tell lenders where their portfolios stand today, but they do not explain where portfolio risk is heading tomorrow.

Two lending portfolios can report the same NPL ratio while exhibiting completely different behaviours. One portfolio may be steadily recovering, while another is rapidly deteriorating as borrowers move from current status directly into severe delinquency.

This project builds an early warning framework for monitoring how loans migrate between delinquency stages over time using roll rate analysis.

The objective is to help risk and collections teams answer critical business questions such as:

> - Which delinquent loans are most likely to deteriorate further?
> - Are borrowers recovering or accelerating toward default?
> - Which customer segments exhibit the highest delinquency migration rates?
> - Are loans skipping delinquency stages before becoming non-performing?
> - Which portfolios require immediate intervention?

> **Note:** This project shares its underlying dataset with the Portfolio Health & NPL Monitoring project in this portfolio. Both projects answer different business questions and should be evaluated independently.

---

## Business Problem

Traditional portfolio monitoring relies heavily on static metrics such as:

- Non-Performing Loan Ratios (NPL)
- Portfolio Default Rates
- Delinquency Counts

While valuable, these metrics only provide a snapshot of portfolio performance.

They cannot answer:

- How quickly is portfolio quality deteriorating?
- Which delinquency stages are accelerating?
- Which loans are likely to become non-performing next month?
- Are borrowers curing or worsening over time?

Roll rate analysis addresses these limitations by monitoring how loans transition between delinquency states month-over-month.

Rather than measuring where loans are today, this project measures where they are heading.

---

## Dataset

The project uses a synthetic lending portfolio consisting of three related tables.

| Table | Description |
|-------|------------|
| loans | Loan information including amount, tenure and origination dates |
| customers | Customer demographics, income and credit scores |
| loan_panel | Monthly loan-level delinquency snapshots |

### Portfolio Composition

- 1,000 Loans
- 1,000 Customers
- 10,000 Monthly Loan Observations
- Five Countries
- Consumer Lending Products
- SME Lending Products
- Credit Card Products

### Countries Included

- Nigeria
- United Kingdom
- United States
- United Arab Emirates
- Singapore

The loan panel spans monthly observations between January 2023 and January 2025.

---

## Project Architecture

```

                    CUSTOMERS
                         |
                         |
                         |
                       LOANS
                         |
                         |
                         |
                    LOAN PANEL
                   (Monthly Snapshots)
                         |
                         |
                         ↓
                 Data Validation Layer
                 (Deduplication Checks)
                         |
                         |
                         ↓
                  Delinquency States
                   (Current,30,60,90+)
                         |
                         |
                         ↓
                  Loan Transition Engine
                    (LAG Functions)
                         |
                         |
                         ↓
                   Transition Matrix
                         |
                         |
                         ↓
                 Transition Probabilities
                         |
                         |
                         ↓
                     Roll Rates
                         |
            -----------------------------------
            |                |                |
            ↓                ↓                ↓
       Credit Tier        Countries         Loan Size
        Analysis          Analysis          Analysis
            |                |                |
            -----------------------------------
                         |
                         ↓
                 Portfolio Early Warning
                      Indicators


```

---

## Technologies Used

- SQL Server (T-SQL)
- Window Functions
- Common Table Expressions (CTEs)
- Conditional Aggregation
- Roll Rate Analysis
- Portfolio Risk Monitoring
- Delinquency Migration Analysis
- Data Validation Techniques
- Financial Analytics

---

## Methodology

The analysis follows a layered portfolio monitoring framework.

### Data Validation

The loan panel was validated for:

- Duplicate records
- Missing observations
- Invalid transitions
- Delinquency bucket integrity
- Loan-level consistency across reporting periods

### Delinquency Classification

Loans are classified into four standardized states:

| Days Past Due | Classification |
|-------------|---------------|
| 0 | Current |
| 30 | 30 Days Past Due |
| 60 | 60 Days Past Due |
| 90+ | Non-Performing |

This standardized classification ensures that all portfolio metrics use consistent delinquency definitions.

### Loan Transition Analysis

Month-over-month loan transitions are calculated using:

```sql
LAG() OVER(
PARTITION BY loan_id
ORDER BY month_end
)
```

This allows every loan to be paired with its previous month's delinquency status without requiring self joins.

### Transition Probability Analysis

The project calculates:

- Transition Counts
- Transition Probabilities
- Roll Rates
- Stage-Skipping Behaviour
- Portfolio-Level Migration Trends

---

## KPIs Developed

The project includes:

- Delinquency Migration Analysis
- Roll Rate Analysis
- Transition Probability Matrix
- Stage-Skipping Detection
- Portfolio Deterioration Monitoring
- Country-Level Roll Rates
- Credit Tier Roll Rates
- Loan Size Segmentation
- Early Warning Indicators
- Cure Rate Analysis

---

## Data Quality Challenges Solved

### Duplicate Loan Records

The companion Portfolio Health project identified duplicate monthly observations within the loan panel.

Without validation checks, duplicated observations can create artificial month-over-month transitions.

#### Solution

The project implements:

- Validation checks
- Deduplication procedures
- Transition integrity testing

This guarantees that every loan generates only one valid monthly transition.

---

### Transition Logic Validation

Roll rate models are highly dependent upon correctly pairing loan observations across reporting periods.

#### Solution

The transition matrix was independently validated against reference calculations.

Validation confirmed:

- 10,000 monthly observations
- 9,000 valid transitions
- Correct loan-level pairing logic

---

## Key Insights

The analysis revealed several important delinquency patterns.

### Stage-Skipping Behaviour

Approximately:

> - 5.4% of loans moved directly from 30 Days Past Due to 90+ Days Past Due.
> - 6.0% of 60 Day delinquent loans became Non-Performing in the following month.
> - 66.4% of 30 Day delinquent loans cured back to Current status.

One of the most significant findings is that loans do not always deteriorate gradually.

A meaningful proportion of borrowers move directly into severe delinquency without first progressing through intermediate stages.

This highlights the limitations of relying solely on traditional portfolio metrics such as NPL ratios.

### Portfolio Monitoring Insight

The analysis demonstrates that:

- Portfolio deterioration is not always linear.
- Early intervention opportunities exist at 30 Days Past Due.
- Delinquency migration patterns vary across portfolio segments.
- Static portfolio snapshots often conceal emerging risks.

---

## Business Recommendations

- Treat 30 Day delinquency as an intervention point rather than a warning indicator.
- Monitor stage-skipping behaviour continuously.
- Implement segment-level roll rate monitoring across customer groups.
- Use transition probabilities as early warning indicators for collections teams.
- Combine roll rates with traditional NPL monitoring for improved portfolio management.

---

## Business Impact

This framework enables lenders to:

- Detect portfolio deterioration earlier.
- Prioritize collections efforts more effectively.
- Identify emerging delinquency trends.
- Monitor segment-level portfolio performance.
- Improve portfolio risk management strategies.

Most importantly, it shifts portfolio monitoring from:

> **"What happened?"**

to

> **"What is likely to happen next?"**

---

## Skills Demonstrated

This project demonstrates proficiency in:

- Advanced SQL
- Window Functions
- Portfolio Risk Analytics
- Roll Rate Analysis
- Financial Analytics
- Delinquency Migration Analysis
- Data Modeling
- Data Validation
- Business Intelligence Reporting
- Early Warning System Design
- Problem Solving

---

## Project Deliverables

- Roll Rate Analysis
- Delinquency Migration Framework
- Transition Probability Matrix
- Portfolio Early Warning Indicators
- Segment-Level Risk Analysis
- Data Quality Validation Checks
- Business Recommendations
- SQL Reporting Views

---

## Results

The final solution delivers a reusable delinquency migration framework capable of monitoring how portfolio risk evolves over time.

By combining roll rates, transition probabilities and segment-level analyses, the project provides:

- Early detection of portfolio deterioration.
- Reliable delinquency migration monitoring.
- Improved collections prioritization.
- Better visibility into emerging credit risks.
- A scalable foundation for portfolio risk forecasting and predictive analytics.

---

> **Disclaimer:** This project uses a synthetic lending dataset designed for analytical and educational purposes. The roll rates and transition probabilities presented here are intended to demonstrate portfolio monitoring techniques and should not be interpreted as real-world lending benchmarks.
