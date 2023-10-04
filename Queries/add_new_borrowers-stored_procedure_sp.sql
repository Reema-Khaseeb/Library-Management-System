CREATE PROCEDURE sp_AddNewBorrower
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DateOfBirth DATE,
    @MembershipDate DATE
AS
BEGIN
    -- Check if the email already exists in the Borrowers table
    IF EXISTS (SELECT 1 FROM Borrower WHERE Email = @Email)
    BEGIN
        -- If the email exists, raise an error message
        THROW 51000, 'Email already exists. Please use a different email address.', 1;
    END
    ELSE
    BEGIN
        -- If the email doesn't exist, insert the new borrower
        INSERT INTO Borrower (FirstName, LastName, Email, DateOfBirth, MembershipDate)
        VALUES (@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate);
        
        -- Return the new BorrowerID of the inserted borrower
        SELECT SCOPE_IDENTITY() AS NewBorrowerID;
    END
END
