

USE project4;

-- User Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20),
    FullName VARCHAR(255),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

-- Place Table
CREATE TABLE Place (
    PlaceID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Description TEXT,
    Amenities TEXT,
    ContactInfo VARCHAR(255)
);

-- Field Table
CREATE TABLE Field (
    FieldID INT PRIMARY KEY IDENTITY(1,1),
    PlaceID INT NOT NULL,
    FieldType VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Availability BIT NOT NULL,
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);

-- Booking Table
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    FieldID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    BookingStatus VARCHAR(255) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (FieldID) REFERENCES Field(FieldID)
);

-- Review Table
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    PlaceID INT NOT NULL,
    Rating DECIMAL(2,1) NOT NULL,
    Comment TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PlaceID) REFERENCES Place(PlaceID)
);

-- Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    UserID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(255) NOT NULL,
    PaymentStatus VARCHAR(255) NOT NULL,
    Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
