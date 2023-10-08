USE [LibrarySystem]
GO

CREATE TABLE Book (
    BookID INT PRIMARY KEY NOT NULL,
    Title VARCHAR(50) NULL,
    Author VARCHAR(50) NULL,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    PublishedDate DATE NULL,
    Genre VARCHAR(25) NULL,
    ShelfLocation VARCHAR(50) NULL,
    CurrentStatus CHAR(10) NULL
);

CREATE TABLE Borrower (
    BorrowerID INT PRIMARY KEY NOT NULL,
    FirstName VARCHAR(20) NULL,
    LastName VARCHAR(20) NULL,
    Email VARCHAR(25) NULL UNIQUE,
    DateOfBirth DATE NULL,
    MembershipDate DATE NULL
);
CREATE UNIQUE INDEX Borrower_Email_index ON Borrower (Email);

/*CREATE INDEX Borrower_date_of_birth_index ON Borrower(date_of_birth);
CREATE INDEX Borrower_membership_date_index ON Borrower(membership_date);
*/
CREATE TABLE LOAN (
    LoanID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    BookID INT NULL,
    BorrowerID INT NULL,
    DateBorrowed DATE NOT NULL,
    DueDate DATE NOT NULL,
    DateReturned DATE NULL,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrower(BorrowerID)
);
CREATE INDEX Loan_BorrowerID_index ON Loan (BorrowerID);
CREATE INDEX Loan_BookID_index ON Loan (BookID);
CREATE INDEX Loan_DateBorrowed_index ON Loan (DateBorrowed);
CREATE NONCLUSTERED INDEX Loan_DateReturned_index ON Loan (DateReturned) WHERE DateReturned IS NULL;

CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY IDENTITY NOT NULL,
    BookID INT NULL,
    StatusChange VARCHAR(255) NULL,
    ChangeDate DATETIME NULL,
	FOREIGN KEY (BookID) REFERENCES Book(BookID)
);