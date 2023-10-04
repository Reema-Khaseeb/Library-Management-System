WITH BorrowerBorrowCounts AS (
    SELECT
        L.BorrowerID,
        COUNT(*) AS BorrowedCount
    FROM
        Loan AS L
    WHERE
        L.DateReturned IS NULL
    GROUP BY
        L.BorrowerID
    HAVING
        COUNT(*) >= 2
)

SELECT
    B.BorrowerID,
    B.FirstName,
    B.LastName,
    B.Email,
    B.DateOfBirth,
    B.MembershipDate
FROM
    Borrower AS B
JOIN
    BorrowerBorrowCounts AS BBC ON B.BorrowerID = BBC.BorrowerID;
