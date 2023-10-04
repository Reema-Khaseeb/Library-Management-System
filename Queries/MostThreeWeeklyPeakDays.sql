WITH WeeklyLoanCounts AS (
    SELECT
        DATENAME(WEEKDAY, DateBorrowed) AS DayOfWeek,
        COUNT(*) AS LoanCount
    FROM
        Loan
    GROUP BY
        DATENAME(WEEKDAY, DateBorrowed)
)

SELECT TOP 3
    DayOfWeek,
    CONVERT(DECIMAL(5, 2), 100.0 * LoanCount / SUM(LoanCount) OVER ()) AS PercentageOfLoans
FROM
    WeeklyLoanCounts
ORDER BY
    PercentageOfLoans DESC;
