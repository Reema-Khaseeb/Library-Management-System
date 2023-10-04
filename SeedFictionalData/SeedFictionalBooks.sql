-- Create a table to store possible book genres
CREATE TABLE PossibleGenres (
    GenreName NVARCHAR(50)
);

-- Insert various book genres into the table
INSERT INTO PossibleGenres (GenreName)
VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Mystery'),
    ('Science Fiction'),
    ('Fantasy'),
    ('Romance'),
    ('Thriller'),
    ('Biography'),
    ('Historical Fiction'),
    ('Self-Help'),
    ('Horror'),
    ('Adventure'),
    ('Cookbook'),
    ('Poetry'),
    ('Drama');

-- Generate random book genres for each book
WITH NumberedRows AS (
    SELECT TOP 1000
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS BookID
    FROM master.dbo.spt_values
)

INSERT INTO Book (BookID, Title, Author, ISBN, PublishedDate, Genre, ShelfLocation, CurrentStatus)
SELECT
    nr.BookID,
    'Book ' + CAST(nr.BookID AS NVARCHAR(255)) AS Title,
    'Author ' + CHAR(65 + (nr.BookID % 26)) AS Author,
    'ISBN-' + RIGHT('0000' + CAST(nr.BookID AS NVARCHAR(10)), 4) AS ISBN,
    DATEADD(DAY, -nr.BookID, GETDATE()) AS PublishedDate,
    RG.GenreName AS Genre,
    'Shelf ' + CAST(1 + (nr.BookID % 5) AS NVARCHAR(10)) AS ShelfLocation,
    CASE WHEN nr.BookID % 5 = 0 THEN 'Borrowed' ELSE 'Available' END AS CurrentStatus
FROM NumberedRows nr
CROSS APPLY (
    SELECT TOP 1 GenreName
    FROM (
        SELECT GenreName, ROW_NUMBER() OVER (ORDER BY NEWID()) AS GenreOrder
        FROM PossibleGenres
    ) AS SubQuery
    WHERE SubQuery.GenreOrder = (nr.BookID % 15) + 1
) AS RG;


-- Drop the PossibleGenres table if no longer needed
DROP TABLE PossibleGenres;
