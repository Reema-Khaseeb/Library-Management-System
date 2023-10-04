-- Create the AuditLog table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    CREATE TABLE AuditLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        BookID INT,
        StatusChange NVARCHAR(50),
        ChangeDate DATETIME
    );
END
GO

-- Create the trigger
CREATE TRIGGER trg_BookStatusChange
ON Book
AFTER UPDATE
AS
BEGIN
    DECLARE @BookID INT, @OldStatus NVARCHAR(50), @NewStatus NVARCHAR(50);

    -- Check if the 'Status' column was updated
    IF UPDATE(CurrentStatus)
    BEGIN
        SELECT @BookID = i.BookID, @OldStatus = d.CurrentStatus, @NewStatus = i.CurrentStatus
        FROM inserted i
        INNER JOIN deleted d ON i.BookID = d.BookID;

        -- Check if the status changed from 'Available' to 'Borrowed' or vice versa
        IF (@OldStatus = 'Available' AND @NewStatus = 'Borrowed') OR
           (@OldStatus = 'Borrowed' AND @NewStatus = 'Available')
        BEGIN
            -- Log the status change in the AuditLog table
            INSERT INTO AuditLog (BookID, StatusChange, ChangeDate)
            VALUES (@BookID, @NewStatus, GETDATE());
        END
    END
END;
