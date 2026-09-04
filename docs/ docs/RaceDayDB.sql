 
   RACEDAY DATABASE
   PROGRAMMING 2B - PART 1
   SECTION C - SQL DATABASE SCRIPT

   Six Entities:
   1. Users
   2. Events
   3. EventRoutes
   4. Categories
   5. Enrolments
   6. Results
   


 
-- CREATE DATABASE
 
CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO


 
-- ENTITY 1: USERS
-- Stores Organisers and Participants
 
CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName NVARCHAR(50) NOT NULL,

    LastName NVARCHAR(50) NOT NULL,

    Email NVARCHAR(100) NOT NULL UNIQUE,

    Cellphone NVARCHAR(15) NOT NULL UNIQUE,

    PasswordHash NVARCHAR(255) NOT NULL,

    Role NVARCHAR(20) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);

GO


 
-- ENTITY 2: EVENTS
-- Stores events created by Organisers
 
CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,

    OrganiserID INT NOT NULL,

    EventName NVARCHAR(100) NOT NULL,

    EventDescription NVARCHAR(500) NULL,

    EventDate DATE NOT NULL,

    StartTime TIME NOT NULL,

    Location NVARCHAR(150) NOT NULL,

    EntryFee DECIMAL(10,2) NOT NULL
        DEFAULT 0.00,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_EntryFee
        CHECK (EntryFee >= 0)
);

GO


 
-- ENTITY 3: EVENTROUTES
-- Stores route information for each event
 
CREATE TABLE EventRoutes
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,

    EventID INT NOT NULL,

    RouteName NVARCHAR(100) NOT NULL,

    StartPoint NVARCHAR(150) NOT NULL,

    FinishPoint NVARCHAR(150) NOT NULL,

    RouteDistanceKM DECIMAL(6,2) NOT NULL,

    RouteMapURL NVARCHAR(300) NULL,

    RouteNotes NVARCHAR(500) NULL,

    CONSTRAINT FK_EventRoutes_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
        ON DELETE CASCADE,

    CONSTRAINT CK_EventRoutes_Distance
        CHECK (RouteDistanceKM > 0)
);

GO


 
-- ENTITY 4: CATEGORIES
-- Stores categories belonging to events
 
CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,

    EventID INT NOT NULL,

    CategoryName NVARCHAR(100) NOT NULL,

    DistanceKM DECIMAL(6,2) NOT NULL,

    MaximumParticipants INT NOT NULL
        DEFAULT 100,

    CONSTRAINT FK_Categories_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKM > 0),

    CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaximumParticipants > 0),

    CONSTRAINT UQ_Category_Event
        UNIQUE (EventID, CategoryName)
);

GO


 
-- ENTITY 5: ENROLMENTS
-- Connects Participants to Categories
 

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,

    ParticipantID INT NOT NULL,

    CategoryID INT NOT NULL,

    EnrolmentDate DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    EnrolmentStatus NVARCHAR(20) NOT NULL
        DEFAULT 'Confirmed',

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Enrolments_Status
        CHECK (EnrolmentStatus IN
        ('Confirmed', 'Cancelled')),

    CONSTRAINT UQ_Participant_Category
        UNIQUE (ParticipantID, CategoryID)
);

GO


 
-- ENTITY 6: RESULTS
-- Stores participant results
 

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,

    EnrolmentID INT NOT NULL UNIQUE,

    FinishTime TIME NULL,

    Position INT NULL,

    ResultStatus NVARCHAR(30) NOT NULL
        DEFAULT 'Finished',

    RecordedAt DATETIME2 NOT NULL
        DEFAULT GETDATE(),

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Results_Position
        CHECK (Position IS NULL OR Position > 0),

    CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN
        ('Finished', 'Did Not Finish', 'Disqualified'))
);

GO


 
   SAMPLE DATA
   


 
-- USERS
-- 2 Organisers + 4 Participants
 

INSERT INTO Users
(
    FirstName,
    LastName,
    Email,
    Cellphone,
    PasswordHash,
    Role
)
VALUES
(
    'Thabo',
    'Maseko',
    'thabo.maseko@example.com',
    '0714826391',
    'hashed_password_001',
    'Organiser'
),

(
    'Leanne',
    'Jacobs',
    'leanne.jacobs@example.com',
    '0827153048',
    'hashed_password_002',
    'Organiser'
),

(
    'Sipho',
    'Ndlovu',
    'sipho.ndlovu@example.com',
    '0763918257',
    'hashed_password_003',
    'Participant'
),

(
    'Kayla',
    'Naidoo',
    'kayla.naidoo@example.com',
    '0796248135',
    'hashed_password_004',
    'Participant'
),

(
    'Daniel',
    'Petersen',
    'daniel.petersen@example.com',
    '0835172946',
    'hashed_password_005',
    'Participant'
),

(
    'Amahle',
    'Khumalo',
    'amahle.khumalo@example.com',
    '0728364915',
    'hashed_password_006',
    'Participant'
);

GO


 
-- EVENTS
-- 3 Events
 

INSERT INTO Events
(
    OrganiserID,
    EventName,
    EventDescription,
    EventDate,
    StartTime,
    Location,
    EntryFee
)
VALUES
(
    1,
    'Nelson Mandela Bay Road Run',
    'Annual road running event for athletes of different experience levels.',
    '2026-10-18',
    '07:00',
    'Gqeberha, Eastern Cape',
    150.00
),

(
    2,
    'Sunrise Coastal Cycle',
    'Scenic cycling event along the coastal route.',
    '2026-11-08',
    '06:30',
    'Port Elizabeth Beachfront',
    220.00
),

(
    1,
    'Summer Charity Walk',
    'Community charity walking event supporting local organisations.',
    '2026-12-05',
    '08:00',
    'Walmer, Gqeberha',
    80.00
);

GO


 
-- EVENT ROUTES
 
INSERT INTO EventRoutes
(
    EventID,
    RouteName,
    StartPoint,
    FinishPoint,
    RouteDistanceKM,
    RouteMapURL,
    RouteNotes
)
VALUES
(
    1,
    'Bay Road Route',
    'Kings Beach',
    'Nelson Mandela University',
    10.00,
    'https://example.com/routes/bay-road',
    'Mostly flat coastal route.'
),

(
    1,
    'Bay Half Marathon Route',
    'Kings Beach',
    'Sardinia Bay',
    21.10,
    'https://example.com/routes/bay-half',
    'Long-distance coastal route.'
),

(
    2,
    'Coastal Cycle Route',
    'Summerstrand',
    'Cape Recife',
    20.00,
    'https://example.com/routes/coastal-cycle',
    'Scenic coastal cycling route.'
),

(
    3,
    'Walmer Charity Route',
    'Walmer Park',
    'Walmer Town Hall',
    5.00,
    'https://example.com/routes/walmer-walk',
    'Community-friendly walking route.'
);

GO


 
-- CATEGORIES
-- Categories for each event
 

INSERT INTO Categories
(
    EventID,
    CategoryName,
    DistanceKM,
    MaximumParticipants
)
VALUES
(
    1,
    '10KM Run',
    10.00,
    500
),

(
    1,
    '21KM Half Marathon',
    21.10,
    800
),

(
    2,
    '20KM Cycle',
    20.00,
    300
),

(
    2,
    '50KM Cycle',
    50.00,
    500
),

(
    3,
    '5KM Fun Walk',
    5.00,
    400
),

(
    3,
    '10KM Charity Walk',
    10.00,
    300
);

GO


 
-- ENROLMENTS
-- Participants enter event categories
 

INSERT INTO Enrolments
(
    ParticipantID,
    CategoryID,
    EnrolmentStatus
)
VALUES
(
    3,
    1,
    'Confirmed'
),

(
    3,
    3,
    'Confirmed'
),

(
    4,
    1,
    'Confirmed'
),

(
    4,
    5,
    'Confirmed'
),

(
    5,
    2,
    'Confirmed'
),

(
    5,
    4,
    'Confirmed'
),

(
    6,
    2,
    'Confirmed'
),

(
    6,
    6,
    'Confirmed'
);

GO


 
-- RESULTS
 

INSERT INTO Results
(
    EnrolmentID,
    FinishTime,
    Position,
    ResultStatus
)
VALUES
(
    1,
    '00:52:34',
    12,
    'Finished'
),

(
    3,
    '00:48:21',
    7,
    'Finished'
),

(
    5,
    '01:47:52',
    15,
    'Finished'
),

(
    6,
    '02:16:43',
    21,
    'Finished'
),

(
    7,
    '02:01:18',
    18,
    'Finished'
);

GO


 
   VERIFICATION QUERIES
   Use these to confirm that the database was created correctly.
   

-- Show all users
SELECT *
FROM Users;

-- Show all events and their organisers
SELECT
    E.EventID,
    E.EventName,
    E.EventDate,
    E.StartTime,
    E.Location,
    U.FirstName + ' ' + U.LastName AS Organiser
FROM Events E
INNER JOIN Users U
    ON E.OrganiserID = U.UserID;


-- Show events and routes
SELECT
    E.EventName,
    R.RouteName,
    R.StartPoint,
    R.FinishPoint,
    R.RouteDistanceKM
FROM EventRoutes R
INNER JOIN Events E
    ON R.EventID = E.EventID;


-- Show events and categories
SELECT
    E.EventName,
    C.CategoryName,
    C.DistanceKM,
    C.MaximumParticipants
FROM Categories C
INNER JOIN Events E
    ON C.EventID = E.EventID;


-- Show enrolments
SELECT
    En.EnrolmentID,
    U.FirstName + ' ' + U.LastName AS Participant,
    E.EventName,
    C.CategoryName,
    En.EnrolmentDate,
    En.EnrolmentStatus
FROM Enrolments En
INNER JOIN Users U
    ON En.ParticipantID = U.UserID
INNER JOIN Categories C
    ON En.CategoryID = C.CategoryID
INNER JOIN Events E
    ON C.EventID = E.EventID;


-- Show results
SELECT
    R.ResultID,
    U.FirstName + ' ' + U.LastName AS Participant,
    E.EventName,
    C.CategoryName,
    R.FinishTime,
    R.Position,
    R.ResultStatus
FROM Results R
INNER JOIN Enrolments En
    ON R.EnrolmentID = En.EnrolmentID
INNER JOIN Users U
    ON En.ParticipantID = U.UserID
INNER JOIN Categories C
    ON En.CategoryID = C.CategoryID
INNER JOIN Events E
    ON C.EventID = E.EventID;

GO
