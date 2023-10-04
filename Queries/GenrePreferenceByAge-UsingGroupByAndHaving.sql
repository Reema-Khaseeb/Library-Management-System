WITH AgeGroups AS (
    SELECT
        B.BorrowerID,
        Book.Genre AS PreferredGenre,
        CASE
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 0 AND 10 THEN '0-10'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 11 AND 20 THEN '11-20'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 21 AND 30 THEN '21-30'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 31 AND 40 THEN '31-40'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
            ELSE '51+'
        END AS AgeGroup
    FROM
        Borrower AS B
    INNER JOIN
        Loan AS L ON B.BorrowerID = L.BorrowerID
    INNER JOIN
        Book ON L.BookID = Book.BookID
)
SELECT
    AgeGroup,
    PreferredGenre,
    COUNT(*) AS BorrowerCount
FROM
    AgeGroups
GROUP BY
    AgeGroup,
    PreferredGenre
HAVING
    COUNT(*) = (
        SELECT MAX(BorrowerCount)
        FROM (
            SELECT
                AgeGroup,
                PreferredGenre,
                COUNT(*) AS BorrowerCount
            FROM
                AgeGroups
            GROUP BY
                AgeGroup,
                PreferredGenre
        ) AS Subquery
        WHERE Subquery.AgeGroup = AgeGroup
    )
ORDER BY
    AgeGroup, BorrowerCount DESC;
