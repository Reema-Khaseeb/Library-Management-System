SELECT
    B.Title AS BookTitle,
    CONCAT(BR.FirstName, ' ', BR.LastName) AS BorrowerName,
    L.DateBorrowed,
    L.DueDate,
    L.DateReturned,
    DATEDIFF(DAY, L.DueDate, GETDATE()) AS DaysOverdue
FROM
    Loan AS L
INNER JOIN
    Book AS B ON L.BookID = B.BookID
INNER JOIN
    Borrower AS BR ON L.BorrowerID = BR.BorrowerID
WHERE
    L.DateReturned IS NULL
    AND DATEDIFF(DAY, L.DueDate, GETDATE()) > 30;
