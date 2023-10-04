-- Create the stored procedure
CREATE PROCEDURE sp_GetBorrowersWithOverdueBooks
AS
BEGIN
    -- Step 1: Create a temporary table to store borrowers with overdue books
    CREATE TABLE #TempBorrowersWithOverdue (
        BorrowerID INT PRIMARY KEY
    );

    -- Step 2: Retrieve borrowers with overdue books and insert into the temporary table
    INSERT INTO #TempBorrowersWithOverdue (BorrowerID)
    SELECT DISTINCT L.BorrowerID
    FROM Loan L
    WHERE L.DateReturned IS NULL
      AND L.DueDate < GETDATE();

    -- Step 3: Join the temporary table with Loans table to list specific overdue books
    SELECT
        B.Title AS BookTitle,
        CONCAT(Br.FirstName, ' ', Br.LastName) AS BorrowerName,
        L.DueDate AS DueDate
    FROM
        Loan AS L
    INNER JOIN
        Book AS B ON L.BookID = B.BookID
    INNER JOIN
        Borrower AS Br ON L.BorrowerID = Br.BorrowerID
    INNER JOIN
        #TempBorrowersWithOverdue AS T ON L.BorrowerID = T.BorrowerID;

    -- Step 4: Drop the temporary table when done
    DROP TABLE #TempBorrowersWithOverdue;
END;
