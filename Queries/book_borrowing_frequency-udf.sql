-- Create the database function
CREATE FUNCTION fn_BookBorrowingFrequency
(
    @BookID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @BorrowingCount INT;

    -- Calculate the borrowing count for the specified book
    SELECT @BorrowingCount = COUNT(*)
    FROM Loan L
    WHERE L.BookID = @BookID;

    RETURN @BorrowingCount;
END;




-- Example: Get the borrowing frequency for a book with BookID = 205
DECLARE @BookID INT = 205;

-- Call the fn_BookBorrowingFrequency function
DECLARE @BorrowingCount INT;
SET @BorrowingCount = dbo.fn_BookBorrowingFrequency(@BookID);

-- Display the result
SELECT @BookID AS BookID, @BorrowingCount AS BorrowingCount;
