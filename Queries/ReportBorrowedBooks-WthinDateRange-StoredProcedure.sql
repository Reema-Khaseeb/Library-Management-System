CREATE PROCEDURE sp_BorrowedBooksReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT
        B.Title,
        CONCAT(Br.FirstName, ' ', Br.LastName) AS BorrowerName,
        L.DateBorrowed
    FROM
        Loan AS L
    INNER JOIN
        Book AS B ON L.BookID = B.BookID
    INNER JOIN
        Borrower AS Br ON L.BorrowerID = Br.BorrowerID
    WHERE
        L.DateBorrowed BETWEEN @StartDate AND @EndDate
    ORDER BY
        L.DateBorrowed;

END;
