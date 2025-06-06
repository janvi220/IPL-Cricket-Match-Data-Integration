CREATE DATABASE IPL_Warehouse;
GO
USE IPL_Warehouse;

/*Table Player*/ 
CREATE TABLE DimPlayer ( 
    Player_ID INT Primary key,
    Player_Name NVARCHAR(100),
	DOb nvarchar(25),
    Batting_hand int,
    Bowling_skill int,
	Country_Name int
);
drop table DimPlayer
select * from [dbo].[player2]
select * from [dbo].[player1]

ALTER TABLE DimPlayer 
ADD CONSTRAINT FK_DimPlayer_Batting_hand 
FOREIGN KEY (Batting_Hand) REFERENCES dimBattingstyle(Batting_ID);

ALTER TABLE DimPlayer 
ADD CONSTRAINT FK_DimPlayer_Bowling_skill 
FOREIGN KEY (Bowling_Skill) REFERENCES dimBowlingSkill(Bowling_ID);

ALTER TABLE DimPlayer 
ADD CONSTRAINT FK_DimPlayer_Country_Name 
FOREIGN KEY (Country_Name) REFERENCES DimCountry(Country_ID);




/*table team*/
CREATE TABLE DimTeam (
    Team_ID INT PRIMARY KEY,
    Team_Name NVARCHAR(100)
);

drop table DimTeam
select * from DimTeam


/*Table Outcome*/
create table dimOutcome(
	Outcome_Id int primary key,
	Outcome_Type varchar(100)
)

select * from dimOutcome


/*create table Out Type*/
create Table dimOutType(
	Out_Id Int Primary Key,
	Out_Name nvarchar(100)
)
drop table dimOutType
select * from dimOutType

/*table Extratype*/
create table dimExtraType(
	Extra_Id int primary key,
	Extra_Name nvarchar(100)
)
drop table dimExtraType
select * from dimExtraType




/*table Country*/
create table DimCountry(
	Country_Id int primary key,
	Country_Name varchar(100)
)
drop table DimCountry
select * from dimcountry



/*table City*/
create table DimCity(
	City_Id int primary key,
	City_Name nvarchar(100),
	Country_id int,
	foreign key (Country_id) REFERENCES DimCountry(Country_id)
)
drop table DimCity
select * from [dbo].[dimCity1]
select * from [dbo].[dimcity2]
select * from [dbo].[dimcity3]
select * from DimCity

/*table Venue*/
CREATE TABLE DimVenue (
	Venue_Id int  PRIMARY KEY,
    Venue_Name NVARCHAR(100),
    City_id int	
	Foreign key (city_id) REFERENCES dimCity (City_id)
)

drop table DimVenue
select * from DimVenue



/*table battingStyle*/
create table dimBattingstyle(
	Batting_Id int primary key,
	Batting_hand varchar(100)
)

select * from dimBattingstyle



/*table bowlingskill*/
create table dimBowlingSkill(
	Bowling_Id	int primary key,
	Bowling_skill varchar(100)
)

select * from dimBowlingSkill

/*table Role*/
create table DimRole(
	Role_Id int primary key,
	Role_Desc nvarchar(100)
)

select * from DimRole

--table Wintype
create table DimWinBy(
	Win_Id int primary key,
	Win_Type nvarchar(100)
)
select * from DimWinBy


/*table Toss Decision*/
create table DimTossDecision(
	Toss_Id int primary key,
	Toss_Name nvarchar(100)
)

select * from DimTossDecision


/*table Season*/
create table FactSeason(
	Season_Id int primary key,
	Man_of_the_Series int,
	Orange_Cap int,
	Purple_Cap int,
	Season_Year nvarchar(50)
)
select * from FactSeason
drop table FactSeason

ALTER TABLE FactSeason 
ADD CONSTRAINT FK_FactSeason_Man_of_the_Series 
FOREIGN KEY (Man_of_the_Series) REFERENCES DimPlayer(Player_ID);

ALTER TABLE FactSeason 
ADD CONSTRAINT FK_FactSeason_Orange_Cap 
FOREIGN KEY (Orange_Cap) REFERENCES DimPlayer(Player_ID);

ALTER TABLE FactSeason 
ADD CONSTRAINT FK_FactSeason_Purple_Cap 
FOREIGN KEY (Purple_Cap) REFERENCES DimPlayer(Player_ID);


/*ALTER TABLE FactSeason
ALTER COLUMN Season_Year NVARCHAR(50);  */



/*table Match*/
create table FactMatch(
	Match_Id int primary key,
	Team_1 int,
	Team_2 int,
	Match_Date date,
	Season_Id int,
	Venue_Id int,
	Toss_Winner int,
	Toss_Decide int,
	Win_Type int,
	Win_Margin int, 
	Outcome_type int,
	Match_Winner int,
	Man_of_the_Match int,
	FOREIGN KEY (Team_1) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Team_2) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Season_ID) REFERENCES FactSeason(Season_ID),
    FOREIGN KEY (Venue_ID) REFERENCES DimVenue(Venue_ID),
    FOREIGN KEY (Toss_Winner) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Toss_Decide) REFERENCES DimTossDecision(Toss_ID),
    FOREIGN KEY (Win_Type) REFERENCES DimWinBy(Win_ID),--
    FOREIGN KEY (Outcome_Type) REFERENCES dimOutcome(Outcome_ID),
    FOREIGN KEY (Match_Winner) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Man_of_the_Match) REFERENCES DimPlayer(Player_ID)
)	
drop table FactMatch

ALTER TABLE FactMatch 
ALTER COLUMN Match_Date VARCHAR(25);

SELECT name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('FactMatch') AND referenced_object_id = OBJECT_ID('DimWinBy');

ALTER TABLE FactMatch DROP CONSTRAINT [FK__FactMatch__Win_T__251C81ED];

ALTER TABLE FactMatch 
ADD CONSTRAINT FK_FactMatch_Win_Type FOREIGN KEY (Win_Type) REFERENCES DimTossDecision(Toss_ID);

SELECT name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('FactMatch');

select * from FactMatch

ALTER TABLE FactMatch 
DROP CONSTRAINT FK_FactMatch_Win_Type;

ALTER TABLE FactMatch 
ADD CONSTRAINT FK_FactMatch_WinType
FOREIGN KEY (Win_Type) REFERENCES DimWinBy(Win_Id);

select * from [dbo].[FactMatch1]
select * from [dbo].[FactMatch2]
select * from [dbo].[FactMatch4]
select * from [dbo].[FactMatch3]


/*table ballbyball*/
create table FactBallByBall(
	Match_Id int primary key ,
	Over_Id int,
	Ball_Id	int ,
	Innings_No int,
	Team_Batting int,
	Team_Bowling int,
	Striker_Batting_Position int,
	Striker	int,
	Non_Striker int,
	Bowler int,
    FOREIGN KEY (Match_ID) REFERENCES FactMatch(Match_ID),
    FOREIGN KEY (Team_Batting) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Team_Bowling) REFERENCES DimTeam(Team_ID),
    FOREIGN KEY (Striker) REFERENCES DimPlayer(Player_ID),
    FOREIGN KEY (Non_Striker) REFERENCES DimPlayer(Player_ID),
    FOREIGN KEY (Bowler) REFERENCES DimPlayer(Player_ID)
)

ALTER TABLE FactBallByBall DROP CONSTRAINT PK__FactBall__5E273180218987BD;

SELECT name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('FactBallByBall');

ALTER TABLE FactBallByBall 
ADD CONSTRAINT PK_FactBallByBall PRIMARY KEY (Match_Id, Over_Id, Ball_Id, Innings_No);

ALTER TABLE FactBallByBall 
ALTER COLUMN Match_Id INT NOT NULL;

ALTER TABLE FactBallByBall 
ALTER COLUMN Over_Id INT NOT NULL;

ALTER TABLE FactBallByBall 
ALTER COLUMN Ball_Id INT NOT NULL;

ALTER TABLE FactBallByBall 
ALTER COLUMN Innings_No INT NOT NULL;

ALTER TABLE FactBallByBall 
ADD CONSTRAINT PK_FactBallByBall PRIMARY KEY (Match_Id, Over_Id, Ball_Id, Innings_No);

SELECT COLUMN_NAME, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'FactBallByBall' AND COLUMN_NAME IN ('Match_Id', 'Over_Id', 'Ball_Id', 'Innings_No');

select * from FactBallByBall
select * from [dbo].[FactBallByBall1]
select * from [dbo].[FactBallByBall2]

/*table Batsman Scored*/
create table factBatsmanScored(
	Match_Id int ,
	Over_Id	int,
	Ball_Id int,
	Runs_Scored int,
	Innings_No int,
    FOREIGN KEY (Match_ID, Over_ID, Ball_ID,Innings_No) REFERENCES FactBallByBall(Match_ID, Over_ID, Ball_ID,Innings_No)
)

SELECT name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('factBatsmanScored');

ALTER TABLE factBatsmanScored 
ADD BatsmanScored_ID INT IDENTITY(1,1) PRIMARY KEY;

select * from factBatsmanScored
select * from [dbo].[FactBatsmanScored2]
select * from [dbo].[actBastmanscored1]

/*table ExtraRuns*/
CREATE TABLE FactExtraRuns(
    Match_Id INT PRIMARY KEY,
    Over_Id INT,
    Ball_Id INT,
    Extra_Type_Id INT,
    Extra_Runs INT,
    Innings_No INT,
    FOREIGN KEY (Match_ID, Over_ID, Ball_ID,Innings_No) REFERENCES FactBallByBall(Match_ID, Over_ID, Ball_ID,Innings_No),
    FOREIGN KEY (Extra_Type_Id) REFERENCES dimExtraType(Extra_ID),
	FOREIGN KEY (Extra_Runs) REFERENCES dimExtraType(Extra_ID),
);
drop table FactExtraRuns
	
SELECT name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('FactExtraRuns') 
AND referenced_object_id = OBJECT_ID('FactBallByBall');

ALTER TABLE FactExtraRuns DROP CONSTRAINT FK__FactExtraRuns__15A53433;

SELECT name 
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('FactExtraRuns');



-- Check the primary key on FactExtraRuns
EXEC sp_helpconstraint 'FactExtraRuns';

ALTER TABLE FactExtraRuns
DROP CONSTRAINT PK__FactExtr__5E273180B5901CA8;


ALTER TABLE FactExtraRuns
ADD CONSTRAINT PK_FactExtraRuns PRIMARY KEY (Match_Id, Over_Id, Ball_Id,Innings_No);

ALTER TABLE FactExtraRuns
DROP CONSTRAINT PK__FactExtr__5E273180B5901CA8;

ALTER TABLE FactExtraRuns
ADD ID INT IDENTITY(1,1) PRIMARY KEY;

select * from FactExtraRuns
select * from [dbo].[FactExtraRuns1]
select * from [dbo].[FcatExtraRuns2]


/* create table Player match*/
CREATE TABLE FactPlayerMatch (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Match_Id INT,
    Player_Id INT,
    Role_Id INT,
    Team_Id INT,
    FOREIGN KEY (Match_Id) REFERENCES FactMatch(Match_Id),
    FOREIGN KEY (Player_Id) REFERENCES DimPlayer(Player_Id),
    FOREIGN KEY (Role_Id) REFERENCES DimRole(Role_Id),
    FOREIGN KEY (Team_Id) REFERENCES DimTeam(Team_Id)
);

select * from FactPlayerMatch
select * from [dbo].[FactPlayerMatch1]
select * from [dbo].[FactPlayerMatch2]
select * from [dbo].[FactPlayerMatch3]
select * from [dbo].[FactPlayerMatch4]

drop table FactPlayerMatch


/*table WicketTaken*/
create table FactWicketTaken(
  ID INT IDENTITY(1,1) PRIMARY KEY,
	Match_Id int,
	Over_Id int,
	Ball_Id int,
	Player_Out int,
	Kind_Out int,
	Fielders int,
	Innings_No int,
    FOREIGN KEY (Player_Out) REFERENCES DimPlayer(Player_ID),
	FOREIGN KEY (Kind_Out) REFERENCES dimOutType(Out_ID),
    FOREIGN KEY (Fielders) REFERENCES DimPlayer(Player_ID)
)
select * from FactWicketTaken
select * from [dbo].[FactWickenTacken1]
select * from [dbo].[FactWicketTaken2]
select * from [dbo].[FactWicketTaken3]

