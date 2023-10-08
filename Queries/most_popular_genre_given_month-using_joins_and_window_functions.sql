DECLARE @GivenMonth INT = 5;

WITH MonthlyGenreCounts AS (
    SELECT
        BorrowMonth,
        B.Genre,
        COUNT(*) AS GenreCount,
        DENSE_RANK() OVER (PARTITION BY BorrowMonth ORDER BY COUNT(*) DESC) AS GenreRank
    FROM (
        SELECT
            MONTH(L.DateBorrowed) AS BorrowMonth,
            L.BookID
        FROM
            Loan AS L
        WHERE
            BorrowMonth = @GivenMonth
    ) AS BorrowMonthTable
    INNER JOIN
        Book AS B ON BorrowMonthTable.BookID = B.BookID
    GROUP BY
        BorrowMonth, B.Genre
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
