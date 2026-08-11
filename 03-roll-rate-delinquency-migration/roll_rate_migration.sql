/*===========================================================
ROLL RATE & DELINQUENCY MIGRATION
INTELLIGENCE MONITORING SYSTEM

Business Objective
------------------------------------------------------------
This analysis evaluates how loans migrate across delinquency
states over time to identify deteriorating portfolio quality,
emerging credit risks, and future Non-Performing Loan (NPL)
exposure.

By monitoring borrower movements across delinquency buckets,
leadership can identify whether portfolio risk is accelerating
and implement proactive risk mitigation strategies before
defaults materialize.

Business Context
------------------------------------------------------------
Stratavax operates a multi-market lending portfolio spanning
Consumer Loans, SME Lending, and Credit Card products across
multiple countries.

Recent increases in the Non-Performing Loan ratio have raised
critical questions regarding portfolio deterioration.

Leadership requires visibility into:

1. How loans transition between delinquency states.
2. Whether delinquency rates are accelerating.
3. Which customer segments contribute the highest risk.
4. Which markets are experiencing deteriorating performance.
5. How current delinquency patterns may affect future NPL
   levels.

Key Questions Answered
------------------------------------------------------------
1. How do loans migrate between delinquency states?
2. What percentage of loans progress toward default?
3. Are delinquent loans worsening faster over time?
4. Which customer segments exhibit higher roll rates?
5. Which countries contribute disproportionately to risk?
6. Are larger loans deteriorating more rapidly?
7. Which delinquency transitions require immediate attention?
8. What signals indicate future increases in portfolio risk?

This workflow follows a credit risk monitoring process:

Data Validation -> Deduplication -> Delinquency State Engine
-> Migration Analysis -> Roll Rate Analysis
-> Transition Probability Analysis -> Portfolio Segmentation
-> Risk Acceleration Monitoring -> Decision Support

===========================================================*/

/*-----------------------------------------------------------
STEP 0: DATA QUALITY VALIDATION AND DEDUPLICATION

This script reads from the same loan_panel table used in the
Portfolio Health & NPL Monitoring project. That analysis found
real duplicate loan_id and month_end combinations in the raw
data (for example, loan LOAN000408 has two conflicting rows for
2023-01-31). A roll rate model is built entirely on LAG()
comparisons between one month and the next, so a duplicate row
does not just inflate a count here, it can fabricate a
delinquency transition that never happened.

We run the same check and the same conservative resolution
here (keep the row with the higher days_past_due value) so this
script is safe to run on its own, independent of the other
project.
-----------------------------------------------------------*/

SELECT
loan_id,
month_end,
COUNT(*)
FROM loan_panel
GROUP BY loan_id, month_end
HAVING COUNT(*) > 1;

WITH ranked_panel AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY loan_id, month_end
            ORDER BY days_past_due DESC
        ) AS rn
    FROM loan_panel
)
DELETE FROM ranked_panel
WHERE rn > 1;

/*-----------------------------------------------------------
STEP 1: BUILD DELINQUENCY STATE ENGINE

Classify loans into standardized delinquency buckets to
support roll rate calculations and migration analysis.

Current     : No delinquency.
30_DPD      : Early stage delinquency.
60_DPD      : Elevated credit risk.
90+_DPD     : Non-Performing Loan indicator.

Note: days_past_due in this dataset only takes the values 0,
30, 60, or 90, confirmed during data validation, so the ELSE
branch below safely captures 90+ without silently swallowing
an unexpected value.
-----------------------------------------------------------*/

CREATE VIEW v_delinquency_base AS
SELECT
loan_id,
month_end,
days_past_due,
CASE
    WHEN days_past_due = 0 THEN 'Current'
    WHEN days_past_due = 30 THEN '30_DPD'
    WHEN days_past_due = 60 THEN '60_DPD'
    ELSE '90+_DPD'
END AS dpd_state
FROM loan_panel;

/*-----------------------------------------------------------
KPI 1: DELINQUENCY MIGRATION ENGINE

Tracks how individual loans move between delinquency states
from one reporting period to another.

This serves as the foundation for transition and roll rate
analysis. It assumes each loan is observed in consecutive
calendar months. If a loan were ever missing from the panel
for a month and reappeared later, LAG() would treat the
previous available row as last month even if it was really two
or three months back, which would understate how long that
loan sat at its prior status. Worth keeping in mind if this
model is extended to a portfolio with irregular reporting.
-----------------------------------------------------------*/

WITH transitions AS (
SELECT
    loan_id,
    month_end,
    dpd_state AS current_state,

    LAG(dpd_state)
    OVER (
        PARTITION BY loan_id
        ORDER BY month_end
    ) AS previous_state

FROM v_delinquency_base
)

SELECT *
FROM transitions
WHERE previous_state IS NOT NULL;

/*-----------------------------------------------------------
KPI 2: DELINQUENCY TRANSITION MATRIX

Measures the volume of loans moving between delinquency
states and provides visibility into portfolio deterioration
patterns.
-----------------------------------------------------------*/

WITH transitions AS (
SELECT
    loan_id,
    dpd_state AS current_state,

    LAG(dpd_state)
    OVER (
        PARTITION BY loan_id
        ORDER BY month_end
    ) AS previous_state

FROM v_delinquency_base
)

SELECT
previous_state,
current_state,
COUNT(*) AS transition_count

FROM transitions

WHERE previous_state IS NOT NULL

GROUP BY
previous_state,
current_state

ORDER BY
previous_state,
current_state;

/*-----------------------------------------------------------
KPI 3: TRANSITION PROBABILITY ANALYSIS

Measures the likelihood that loans move from one delinquency
state to another.

Transition probabilities provide valuable inputs for
portfolio forecasting and future NPL estimation.
-----------------------------------------------------------*/

WITH transitions AS (
SELECT
    dpd_state AS current_state,

    LAG(dpd_state)
    OVER (
        PARTITION BY loan_id
        ORDER BY month_end
    ) AS previous_state

FROM v_delinquency_base
),

counts AS (
SELECT
    previous_state,
    current_state,
    COUNT(*) AS transition_count

FROM transitions
WHERE previous_state IS NOT NULL
GROUP BY
    previous_state,
    current_state
),
totals AS (
SELECT
    previous_state,
    SUM(transition_count) AS total

FROM counts
GROUP BY previous_state
)
SELECT
c.previous_state,
c.current_state,
c.transition_count * 1.0 / t.total
AS transition_probability
FROM counts c
JOIN totals t
ON c.previous_state = t.previous_state
ORDER BY c.previous_state;

/*-----------------------------------------------------------
KPI 4: ROLL RATE MONITORING

Measures the percentage of loans progressing directly from
30 days past due to Non-Performing Loan status.

Higher roll rates indicate accelerating portfolio risk.
-----------------------------------------------------------*/

WITH transitions AS (
SELECT
    dpd_state AS current_state,
    LAG(dpd_state)
    OVER (
        PARTITION BY loan_id
        ORDER BY month_end
    ) AS previous_state

FROM v_delinquency_base
)
SELECT
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        AND current_state = '90+_DPD'
        THEN 1
    END
) * 1.0
/
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        THEN 1
    END
)

AS roll_30_to_90
FROM transitions;

/*-----------------------------------------------------------
KPI 5: TIME BASED ROLL RATE ANALYSIS

Tracks month-over-month changes in the 30 to 60 day roll rate
to determine whether delinquency migration is accelerating
across the portfolio.

Increasing roll rates may serve as an early warning signal
for future increases in Non-Performing Loans.
-----------------------------------------------------------*/

WITH transitions AS (
SELECT
    loan_id,
    month_end,
    dpd_state AS current_state,

    LAG(dpd_state)
    OVER (
        PARTITION BY loan_id
        ORDER BY month_end
    ) AS previous_state

FROM v_delinquency_base
)
SELECT
month_end,
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        AND current_state = '60_DPD'
        THEN 1
    END
) * 1.0 /
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        THEN 1
    END
)
AS roll_30_to_60
FROM transitions
GROUP BY month_end
ORDER BY month_end;

/*-----------------------------------------------------------
KPI 6: CREDIT RISK SEGMENTATION

Measures roll rates across borrower risk segments to identify
which credit profiles are contributing the highest levels of
portfolio deterioration.

Prime      : Lower Risk Borrowers
Mid Tier   : Moderate Risk Borrowers
Subprime   : Higher Risk Borrowers
-----------------------------------------------------------*/

WITH base AS (
SELECT
lp.loan_id,
lp.month_end,
lp.days_past_due,
c.credit_score,
CASE
    WHEN lp.days_past_due = 0 THEN 'Current'
    WHEN lp.days_past_due = 30 THEN '30_DPD'
    WHEN lp.days_past_due = 60 THEN '60_DPD'
    ELSE '90+_DPD'
END AS state,
CASE
    WHEN c.credit_score >= 700 THEN 'Prime'
    WHEN c.credit_score >= 600 THEN 'Mid'
    ELSE 'Subprime'
END AS risk_band
FROM loan_panel lp
JOIN loans l
ON lp.loan_id = l.loan_id
JOIN customers c
ON l.customer_id = c.customer_id
),
transitions AS (
SELECT
loan_id,
risk_band,
month_end,
state AS current_state,
LAG(state)
OVER (
    PARTITION BY loan_id
    ORDER BY month_end
) AS previous_state
FROM base
)
SELECT
risk_band,
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        AND current_state = '60_DPD'
        THEN 1
    END
) * 1.0 /
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        THEN 1
    END
)
AS roll_30_to_60
FROM transitions
GROUP BY risk_band;

/*-----------------------------------------------------------
KPI 7: GEOGRAPHIC RISK ANALYSIS

Measures delinquency migration patterns across countries to
identify markets exhibiting elevated credit risk.
-----------------------------------------------------------*/

WITH base AS (
SELECT
lp.loan_id,
lp.month_end,
lp.days_past_due,
c.country,
CASE
    WHEN lp.days_past_due = 0 THEN 'Current'
    WHEN lp.days_past_due = 30 THEN '30_DPD'
    WHEN lp.days_past_due = 60 THEN '60_DPD'
    ELSE '90+_DPD'
END AS state
FROM loan_panel lp
JOIN loans l
ON lp.loan_id = l.loan_id
JOIN customers c
ON l.customer_id = c.customer_id
),
transitions AS (
SELECT
loan_id,
country,
month_end,
state AS current_state,
LAG(state)
OVER (
    PARTITION BY loan_id
    ORDER BY month_end
) AS previous_state
FROM base
)
SELECT country,
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        AND current_state = '90+_DPD'
        THEN 1
    END
) * 1.0 /
COUNT(
    CASE
        WHEN previous_state = '30_DPD'
        THEN 1
    END
)
AS roll_30_to_90
FROM transitions
GROUP BY country;

/*-----------------------------------------------------------
KPI 8: LOAN SIZE RISK ANALYSIS

Measures delinquency migration across loan size segments to
determine whether larger exposures contribute greater credit
risk.

Small Loans   : Lower Exposure (loan_amount < 1,000)
Medium Loans  : Moderate Exposure (1,000 to 9,999)
Large Loans   : Higher Exposure (10,000 and above)
-----------------------------------------------------------*/

WITH base AS (
SELECT
lp.loan_id,
lp.month_end,
lp.days_past_due,
l.loan_amount,
CASE
    WHEN lp.days_past_due = 0 THEN 'Current'
    WHEN lp.days_past_due = 30 THEN '30_DPD'
    WHEN lp.days_past_due = 60 THEN '60_DPD'
    ELSE '90+_DPD'
END AS state,
CASE
    WHEN l.loan_amount < 1000 THEN 'Small'
    WHEN l.loan_amount < 10000 THEN 'Medium'
    ELSE 'Large'
END AS loan_size_band
FROM loan_panel lp
JOIN loans l
ON lp.loan_id = l.loan_id
),
transitions AS (
SELECT
loan_id,
loan_size_band,
state AS current_state,
LAG(state)
OVER (
    PARTITION BY loan_id
    ORDER BY month_end
) AS previous_state
FROM base
)
SELECT loan_size_band,
COUNT(
    CASE
        WHEN previous_state = '60_DPD'
        AND current_state = '90+_DPD'
        THEN 1
    END
) * 1.0 /
COUNT(
    CASE
        WHEN previous_state = '60_DPD'
        THEN 1
    END
)
AS roll_60_to_90 FROM transitions
GROUP BY loan_size_band;
