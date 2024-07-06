use project4

--Đăng kí 
CREATE PROCEDURE RegisterUser
    @Username VARCHAR(255),
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @PhoneNumber VARCHAR(20),
    @FullName VARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        RAISERROR('Username already exists', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR('Email already exists', 16, 1);
        RETURN;
    END

    INSERT INTO Users (Username, Email, Password, PhoneNumber, FullName, CreatedAt, UpdatedAt)
    VALUES (@Username, @Email, @Password, @PhoneNumber, @FullName, GETDATE(), GETDATE());
END;

EXEC RegisterUser
    @Username = 'test',
    @Email = 'testuser2@example.com',
    @Password = 'password123',
    @PhoneNumber = '1234567890',
    @FullName = 'Test User';
select * from Users

--đăng nhập
CREATE PROCEDURE LoginUser
    @Username VARCHAR(255),
    @Password VARCHAR(255)
AS
BEGIN
    SELECT UserID, Username, Email, PhoneNumber, FullName
    FROM Users
    WHERE Username = @Username AND Password = @Password;
END;
--test đăng nhập 
EXEC LoginUser 
    @Username = 'testuser',
    @Password = 'password123';


--hiển thị dữ liệu Place - Field
Create proc getPlace 
as
begin
 select * from Place
end;

Exec getPlace