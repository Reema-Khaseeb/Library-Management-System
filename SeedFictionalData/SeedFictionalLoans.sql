/*-- Generate random BookID and BorrowerID combinations and insert into Loan table
WITH RandomLoanData AS (
  SELECT TOP 1000
    b.BookID,
    br.BorrowerID,
    DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365) AS DateBorrowed
  FROM (
    SELECT TOP 1000
      BookID
    FROM Book
    ORDER BY NEWID()
  ) AS b
  CROSS JOIN (
    SELECT TOP 1000
      BorrowerID
    FROM Borrower
    ORDER BY NEWID()
  ) AS br
)

INSERT INTO Loan (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
SELECT
  BookID,
  BorrowerID,
  DateBorrowed,
  DATEADD(DAY, 60, DateBorrowed) AS DueDate,
  DATEADD(DAY, 30 + FLOOR(RAND() * 30 + 1), DateBorrowed) AS DateReturned
FROM RandomLoanData
ORDER BY NEWID(); -- Shuffle the resulting rows to ensure randomness
*/

/*
-- Generate random Loan data with BorrowerID and BookID including duplication and repetition
WITH RandomLoanData AS (
  SELECT TOP 1000
    ABS(CHECKSUM(NEWID())) % 1000 + 1 AS BookID, -- Generate random BookID values (1 to 1000)
    B.BorrowerID, -- Random BorrowerID values from the Borrower table
    DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365) AS DateBorrowed,
    DATEADD(DAY, 60, DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365)) AS DueDate,
    CASE
      WHEN CAST(RAND() AS FLOAT) < 0.8 THEN NULL -- 80% chance of NULL for 'Date Returned'
      ELSE DATEADD(DAY, 30 + FLOOR(RAND() * 30 + 1), DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365)) -- Random date within the next 30 days
    END AS DateReturned
  FROM (
    SELECT TOP 1000 BorrowerID
    FROM Borrower
    ORDER BY NEWID()
  ) AS B
CROSS JOIN (
  SELECT TOP 100
    n = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM master.dbo.spt_values
) AS Numbers
WHERE Numbers.n <= 100;
)

-- Insert random Loan data into the Loan table
INSERT INTO Loan (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
SELECT
  BookID,
  BorrowerID,
  DateBorrowed,
  DueDate,
  DateReturned
FROM RandomLoanData;
*/

WITH RandomLoanData AS (
  SELECT TOP 1000
    ABS(CHECKSUM(NEWID())) % 1000 + 1 AS BookID, -- Generate random BookID values (1 to 1000)
    B.BorrowerID, -- Random BorrowerID values from the Borrower table
    DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365) AS DateBorrowed
  FROM (
    SELECT TOP 1000 BorrowerID
    FROM Borrower
    ORDER BY NEWID()
  ) AS B
CROSS JOIN (
  SELECT TOP 100
    n = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM master.dbo.spt_values
) AS Numbers
WHERE Numbers.n <= 100
)

-- Insert random Loan data into the Loan table
INSERT INTO Loan (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
SELECT
    RLD.BookID,
    RLD.BorrowerID,
    RLD.DateBorrowed,
    DATEADD(DAY, 60, RLD.DateBorrowed) AS DueDate,
    DATEADD(DAY, 30 + FLOOR(RAND() * 30 + 1), RLD.DateBorrowed) AS DateReturned -- Adjusted DateReturned calculation
FROM RandomLoanData AS RLD;






-- Update first 200 rows in the Loan table to set DateReturned to NULL
UPDATE TOP (200) Loan
SET DateReturned = NULL
WHERE DateReturned IS NOT NULL;
