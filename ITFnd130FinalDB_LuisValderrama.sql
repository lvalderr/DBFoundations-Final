--**********************************************************************************************--
-- Title: ITFnd130Final
-- Author: Luis Valderrama
-- Desc: This file demonstrates how to design and create; 
--       tables, views, and stored procedures
-- Change Log: When,Who,What
-- 2021-06-04,LuisValderrama,Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'ITFnd130FinalDB_LuisValderrama')
	 Begin 
	  Alter Database [ITFnd130FinalDB_LuisValderrama] set Single_user With Rollback Immediate;
	  Drop Database ITFnd130FinalDB_LuisValderrama;
	 End
	Create Database ITFnd130FinalDB_LuisValderrama;
End Try
Begin Catch
	Print Error_Number();
End Catch
go

/*--Please Use ITFnd130FinalDB_LuisValderrama database to run the scripts for the tasks below--*/
Use ITFnd130FinalDB_LuisValderrama;
Go
 
 --Create Tables (Module 01)--
 Create Table Courses
([CourseID] [Int] Identity(1,1) Not Null 
,[CourseName] [Nvarchar](100) Not Null
,[CourseStartDate][Date] Null
,[CourseEndDate][Date] Null
,[CourseCurrentPrice][Money] Null
,[CourseDays][Nvarchar] (100) Not Null
,[CourseStartTime][Time] Not Null
,[CourseEndTime][Time] Not Null 
);
Go

Create Table Enrollments
([EnrollmentID] [Int] Identity(1,1) Not Null 
,[SignupDate][Date] Not Null
,[Paid][Money] Not Null
,[StudentID][Int]
,[CourseID][Int]
);
Go

Create Table Students
([StudentID] [Int] Identity(1,1) Not Null 
,[FirstName] [Nvarchar](100) Not Null
,[LastName] [Nvarchar](100) Not Null
,[StudentNumber] [Nvarchar](100) Not Null
,[Email] [Nvarchar](100) Not Null
,[PhoneNumber][Int] Not Null
,[Address][Nvarchar](100) Not Null
,[City][Nvarchar](100) Not Null
,[State][Nvarchar] (100) Not Null
,[Zip][Nvarchar] (100) Not Null
);
Go

-- Add Constraints (Module 02) -- 
--Courses--
Begin
	Alter Table Courses 
	  Add Constraint pkCourses 
		Primary Key (CourseID);

	Alter Table Courses
	  Add Constraint ukCourses 
		Unique (CourseName);
End
Go

--Students--
Begin
	Alter Table Students 
	  Add Constraint pkStudents
		Primary Key (StudentID);

	Alter Table Students 
	  Add Constraint ukStudents 
	    Unique (StudentNumber);
End
Go

--Enrollments--
Begin
	Alter Table Enrollments
	  Add Constraint pkEnrollments
		Primary Key (EnrollmentID);

	Alter Table Enrollments 
	  Add Constraint fkEnrollmentsToStudents 
		Foreign Key (StudentID) References Students (StudentID);

	Alter Table Enrollments 
	  Add Constraint ckCoursePriceOrHigher 
		Check (Paid >= 0);

	Alter Table Enrollments 
	  Add Constraint fkEnrollmentsToCourses 
		Foreign Key (CourseID) References Courses (CourseID);
End
Go

-- Add Views (Module 03 and 06) -- 
--Create View with schema binding for Courses Table. Call the view vCourses 
Create View vCourses With Schemabinding
As 
  Select CourseID, CourseName, CourseStartDate, CourseEndDate, CourseCurrentPrice, CourseDays, CourseStartTime, CourseEndTime
  From dbo.Courses;
Go

--Create View with schema binding for Students Table. Call the view vStudents 
Create View vStudents With Schemabinding
As 
  Select StudentID, FirstName, LastName, StudentNumber, Email, PhoneNumber, Address, City, State, Zip  
  From dbo.Students;
Go

--Create View with schema binding for Enrollments Table. Call the view vEnrollments 
Create View vEnrollments With Schemabinding
As 
  Select EnrollmentID, SignupDate, Paid, StudentID, CourseID  
  From dbo.Enrollments;
Go

--< Test Tables by adding Sample Data >--  
-- Add Stored Procedures (Module 04, 08, and 09) --

--Create Procedure pInsCourses
Create Procedure pInsCourses
 (@CourseName Nvarchar (100)
 ,@CourseStartDate Date
 ,@CourseEndDate Date
 ,@CourseCurrentPrice Money
 ,@CourseDays Nvarchar (100)
 ,@CourseStartTime Time
 ,@CourseEndTime Time)
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-06-05, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Courses(CourseName, CourseStartDate, CourseEndDate, CourseCurrentPrice, CourseDays, CourseStartTime, CourseEndTime)
    Values (@CourseName, @CourseStartDate, @CourseEndDate, @CourseCurrentPrice, @CourseDays, @CourseStartTime, @CourseEndTime);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

--Create Procedure pInsStudents
Create Procedure pInsStudents
 (@FirstName Nvarchar (100)
 ,@LastName Nvarchar (100)
 ,@StudentNumber Nvarchar (100)
 ,@Email Nvarchar (100)
 ,@PhoneNumber Int
 ,@Address Nvarchar (100)
 ,@City Nvarchar (100)
 ,@State Nvarchar (100)
 ,@Zip Nvarchar (100))
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-06-05, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Students(FirstName, LastName, StudentNumber, Email, PhoneNumber, Address, City, State, Zip)
    Values (@FirstName, @LastName, @StudentNumber, @Email, @PhoneNumber, @Address, @City, @State, @Zip);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

--Create Procedure pInsEnrollments
Create Procedure pInsEnrollments
 (@SignupDate Date
 ,@Paid Money
 ,@StudentID Int
 ,@CourseID Int)
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-06-05, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Enrollments(SignupDate, Paid, StudentID, CourseID)
    Values (@SignupDate, @Paid, @StudentID, @CourseID);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

-- Set Permissions --
--Permissions for Courses Table
Deny Select On Courses To Public;
Grant Select On vCourses To Public;
Go

--Permissions for Students Table
Deny Select On Students To Public;
Grant Select On vStudents To Public;
Go

--Permissions for Enrollments Table
Deny Select On Enrollments To Public;
Grant Select On vEnrollments To Public;
Go

--< Test Sprocs >-- 
-- Test [dbo].[pInsCourses]
Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsCourses
               @CourseName = 'SQL1 - Winter 2017'
			  ,@CourseStartDate = '01/10/2017'
			  ,@CourseEndDate = '01/24/2017'
			  ,@CourseCurrentPrice = 399
			  ,@CourseDays = 'T'
			  ,@CourseStartTime = '06:00:00 PM'
			  ,@CourseEndTime = '08:50:00 PM';
Print @Status;
Select Case @Status
  When +1 Then 'Courses Insert was successful!'
  When -1 Then 'Courses Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vCourses Where CourseID = Ident_Current('vCourses');
Go

Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsCourses
               @CourseName = 'SQL2 - Winter 2017'
			  ,@CourseStartDate = '01/31/2017'
			  ,@CourseEndDate = '02/14/2017'
			  ,@CourseCurrentPrice = 399
			  ,@CourseDays = 'T'
			  ,@CourseStartTime = '06:00:00 PM'
			  ,@CourseEndTime = '08:50:00 PM';
Print @Status;
Select Case @Status
  When +1 Then 'Courses Insert was successful!'
  When -1 Then 'Courses Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vCourses Where CourseID = Ident_Current('vCourses');
Go

-- Test [dbo].[pInsStudents]
Declare @Status Int;
Declare @LastID Int;
Declare @CourseID Int;
Exec @Status = pInsStudents
               @FirstName = 'Bob'
			  ,@LastName = 'Smith'
			  ,@StudentNumber = 'B-Smith-071'
			  ,@Email = 'Bsmith@HipMail.com'
			  ,@PhoneNumber = '2061112222'
			  ,@Address = '123 Main St.'
			  ,@City = 'Seattle'
			  ,@State = 'WA'
			  ,@Zip = '98001';
Print @Status;
Select Case @Status
  When +1 Then 'Students Insert was successful!'
  When -1 Then 'Students Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vStudents Where StudentID = Ident_Current('vStudents');
Go

Declare @Status Int;
Declare @LastID Int;
Declare @CourseID Int;
Exec @Status = pInsStudents
               @FirstName = 'Sue'
			  ,@LastName = 'Jones'
			  ,@StudentNumber = 'S-Jones-003'
			  ,@Email = 'SueJones@YaYou.com'
			  ,@PhoneNumber = '2062314321'
			  ,@Address = '333 1st Ave.'
			  ,@City = 'Seattle'
			  ,@State = 'WA'
			  ,@Zip = '98001';
Print @Status;
Select Case @Status
  When +1 Then 'Students Insert was successful!'
  When -1 Then 'Students Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vStudents Where StudentID = Ident_Current('vStudents');
Go

 --Test [dbo].[pInsEnrollments]
 --Bob Smith Enrolls in Course 1--
Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsEnrollments
               @SignupDate = '01/03/2017'
			  ,@Paid = 399
			  ,@StudentID = 1
			  ,@CourseID = 1;
Print @Status;
Select Case @Status
  When +1 Then 'Enrollments Insert was successful!'
  When -1 Then 'Enrollments Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vEnrollments Where EnrollmentID = Ident_Current('vEnrollments');
Go

--Sue Jones Enrolls in Course 1--
Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsEnrollments
               @SignupDate = '12/14/2016'
			  ,@Paid = 349
			  ,@StudentID = 2
			  ,@CourseID = 1;
Print @Status;
Select Case @Status
  When +1 Then 'Enrollments Insert was successful!'
  When -1 Then 'Enrollments Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vEnrollments Where EnrollmentID = Ident_Current('vEnrollments');
Go

--Bob Smith Enroll in Course 2--
Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsEnrollments
               @SignupDate = '01/12/2017'
			  ,@Paid = 399
			  ,@StudentID = 1
			  ,@CourseID = 2;
Print @Status;
Select Case @Status
  When +1 Then 'Enrollments Insert was successful!'
  When -1 Then 'Enrollments Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vEnrollments Where EnrollmentID = Ident_Current('vEnrollments');
Go

--Sue Jones Enrolls in Course 2--
Declare @Status Int;
Declare @LastID Int;
Exec @Status = pInsEnrollments
               @SignupDate = '12/14/2016'
			  ,@Paid = 349
			  ,@StudentID = 2
			  ,@CourseID = 2;
Print @Status;
Select Case @Status
  When +1 Then 'Enrollments Insert was successful!'
  When -1 Then 'Enrollments Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vEnrollments Where EnrollmentID = Ident_Current('vEnrollments');
Go

Go
Create View vEnrollmentTracker With Schemabinding
As
Select Top 1000000
 [Course] = CourseName
,[Dates] = Format (CourseStartDate, 'd','en-US') + '  to  ' + Format (CourseEndDate, 'd','en-US') 
,[Days] = CourseDays
,[Start] = Format(Cast(CourseStartTime as datetime2), N'hh:mm tt')
,[End] = Format( Cast(CourseEndTime as datetime2), N'hh:mm tt')
,[Price] = Format (CourseCurrentPrice, 'C', 'en-US')
,[Student] = FirstName + ' ' + LastName
,[Email] = Email
,[Number] = StudentNumber
,[Phone] = Format (PhoneNumber, '(###)-###-####')
,[Address] = Address + ' ' + City + ', ' + State + ', ' + Zip
,[Signup Date] = Format (SignupDate, 'd', 'en-US')
,[Paid] = Format (Paid, 'C', 'en-US')
From dbo.vCourses
Inner Join dbo.vEnrollments
On dbo.vCourses.CourseID = dbo.vEnrollments.CourseID
Inner Join dbo.vStudents
On dbo.vEnrollments.StudentID = dbo.vStudents.StudentID
;
Go

--The View below has been set up to consolidate and display the data from the Course, Students, Enrollments tables into one-- 

Select * From [dbo].[vEnrollmentTracker]
Go

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  
/**************************************************************************************************/