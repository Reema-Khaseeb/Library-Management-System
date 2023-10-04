DECLARE @BorrowerID INT = 4002;

SELECT
    B.BookID, B.Title, B.Author,
	B.Genre, L.DateBorrowed, L.DateReturned
FROM
    Book AS B
INNER JOIN
    Loan AS L ON B.BookID = L.BookID
WHERE
    L.BorrowerID = @BorrowerID
