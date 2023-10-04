SELECT
    B.Author,
    COUNT(L.BookID) AS BorrowingFrequency
FROM
    Loan AS L
INNER JOIN
    Book AS B ON L.BookID = B.BookID
GROUP BY
    B.Author
ORDER BY
    BorrowingFrequency DESC;
