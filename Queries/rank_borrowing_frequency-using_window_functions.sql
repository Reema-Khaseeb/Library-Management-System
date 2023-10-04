SELECT
    BorrowerID,
    BorrowingFrequency,
    DENSE_RANK() OVER (ORDER BY BorrowingFrequency DESC) AS BorrowingRank
FROM (
    SELECT
        B.BorrowerID,
        COUNT(L.BookID) AS BorrowingFrequency
    FROM
        Borrower AS B
    LEFT JOIN
        Loan AS L ON B.BorrowerID = L.BorrowerID
    GROUP BY
        B.BorrowerID
) AS BorrowerBorrowingCounts;
