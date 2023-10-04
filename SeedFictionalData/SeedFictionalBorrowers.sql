-- Generate 1000 rows of fictional borrower data using SELECT TOP 1000
INSERT INTO Borrower (FirstName, LastName, Email, DateOfBirth, MembershipDate)
SELECT TOP 1000
    'FirstName' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
    'LastName' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
    'email' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)) + '@example.com',
    DATEADD(YEAR, -CAST(RAND() * 40 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365), -- Random date of birth within the last 40 years
    DATEADD(DAY, -CAST(RAND() * 365 AS INT), GETDATE() - ABS(CHECKSUM(NEWID())) % 365) -- Random membership date within the last year
FROM master.dbo.spt_values;
