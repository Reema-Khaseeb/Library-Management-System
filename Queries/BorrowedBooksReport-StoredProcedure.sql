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




DECLARE @StartDate DATE = '2022-01-01';  -- Replace with your desired start date
DECLARE @EndDate DATE = '2022-12-31';    -- Replace with your desired end date

-- Execute the stored procedure with parameters
EXEC sp_BorrowedBooksReport @StartDate, @EndDate;
