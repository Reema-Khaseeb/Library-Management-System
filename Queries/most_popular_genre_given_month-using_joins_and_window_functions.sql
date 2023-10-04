DECLARE @GivenMonth INT = 5;

WITH MonthlyGenreCounts AS (
    SELECT
        MONTH(L.DateBorrowed) AS BorrowMonth,
        B.Genre,
        COUNT(*) AS GenreCount,
        DENSE_RANK() OVER (PARTITION BY MONTH(L.DateBorrowed) ORDER BY COUNT(*) DESC) AS GenreRank
    FROM
        Loan AS L
    INNER JOIN
        Book AS B ON L.BookID = B.BookID
    WHERE
        MONTH(L.DateBorrowed) = @GivenMonth
    GROUP BY
        MONTH(L.DateBorrowed), B.Genre
)

SELECT
    BorrowMonth,
    Genre AS MostPopularGenre,
    GenreCount
FROM
    MonthlyGenreCounts
WHERE
    GenreRank = 1
ORDER BY
    GenreCount DESC;
