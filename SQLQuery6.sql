Use SanBong
go

--Hiển thị Place 
CREATE PROCEDURE DisplayPlaces
AS
BEGIN
    SELECT PlaceID, Name, Address, City, State, PhoneNumber, Email
    FROM Place;
END;
GO
Exec DisplayPlaces

--Hiển thị Filed By Place 
--
CREATE PROCEDURE GetFieldsByPlaceID
    @PlaceID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT f.FieldID, f.Name AS FieldName, ft.Name AS FieldType, f.Description
    FROM Field f
    INNER JOIN FieldType ft ON f.FieldTypeID = ft.FieldTypeID
    WHERE f.PlaceID = @PlaceID;
END;
GO
EXEC GetFieldsByPlaceID @PlaceID = 1;

--Đăng Ký 
CREATE PROCEDURE RegisterUser
    @UserName NVARCHAR(100),
    @Password NVARCHAR(100),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RegistrationDate DATE;
    SET @RegistrationDate = GETDATE(); -- Lấy ngày hiện tại

    INSERT INTO [Users] (UserName, Password, Email, PhoneNumber, RegistrationDate)
    VALUES (@UserName, @Password, @Email, @PhoneNumber, @RegistrationDate);
END;
GO



EXEC RegisterUser
  
    @UserName = 'john_doe3',
    @Password = 'password123',
    @Email = 'john.doe@example.com',
    @PhoneNumber = '123456789';



select * from Users