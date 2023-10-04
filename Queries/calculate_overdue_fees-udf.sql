-- Create the database function
CREATE FUNCTION fn_CalculateOverdueFees
(
    @LoanID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @OverdueDays INT;
    DECLARE @OverdueFees DECIMAL(10, 2);

    -- Calculate the number of overdue days for the specified loan
    SELECT @OverdueDays = DATEDIFF(DAY, L.DueDate, GETDATE())
    FROM Loan L
    WHERE L.LoanID = @LoanID;

    -- Calculate overdue fees based on the number of overdue days
    IF @OverdueDays <= 30
    BEGIN
        SET @OverdueFees = CAST(@OverdueDays AS DECIMAL(10, 2)); -- $1/day for up to 30 days
    END
    ELSE
    BEGIN
        SET @OverdueFees = CAST(30 AS DECIMAL(10, 2)) + CAST((@OverdueDays - 30) * 2 AS DECIMAL(10, 2)); -- $1/day for up to 30 days, $2/day after
    END

    RETURN @OverdueFees;
END;



-- Example: Calculate overdue fees for LoanID 2061779
DECLARE @LoanID INT = 2061779;
DECLARE @Fees DECIMAL(10, 2);

-- Execute the function and retrieve the result
SET @Fees = dbo.fn_CalculateOverdueFees(@LoanID);

-- Display the result
SELECT @Fees AS OverdueFees;
