-- Create the database function
CREATE FUNCTION fn_CalculateOverdueFees
(
    @LoanID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @OverdueDays INT;
    DECLARE @OverdueFees INT;

    -- Calculate the number of overdue days for the specified loan
    SELECT @OverdueDays = DATEDIFF(DAY, L.DueDate, GETDATE())
    FROM Loan L
    WHERE L.LoanID = @LoanID;

    -- Calculate overdue fees based on the number of overdue days
    IF @OverdueDays <= 30
    BEGIN
        SET @OverdueFees = @OverdueDays; -- $1/day for up to 30 days
    END
    ELSE
    BEGIN
        SET @OverdueFees = 30 + ((@OverdueDays - 30) * 2); -- $1/day for up to 30 days, $2/day after
    END

    RETURN @OverdueFees;
END;



-- Example: Calculate overdue fees for LoanID 2061779
DECLARE @LoanID INT = 2061779;
DECLARE @Fees INT;

-- Execute the function and retrieve the result
SET @Fees = dbo.fn_CalculateOverdueFees(@LoanID);

-- Display the result
SELECT @Fees AS OverdueFees;
