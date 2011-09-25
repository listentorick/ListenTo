ALTER TABLE Sites ADD [IsDeleted] bit NOT NULL DEFAULT ((0))
ALTER TABLE Sites ADD [Created] datetime
ALTER TABLE Gigs ADD [EndDate] datetime


ALTER TABLE  [dbo].[Gigs]
 alter column Description varchar(6000) ;

 
ALTER TABLE  [dbo].[Gigs]
 alter column Name varchar(100) ;
 
ALTER TABLE Venues ADD [IsDeleted] bit NOT NULL DEFAULT ((0))

ALTER TABLE Users DROP COLUMN LocationID


USE [ListenTo]
GO
/****** Object:  Table [dbo].[GigAttendees]    Script Date: 01/17/2009 17:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GigAttendees](
	[GigID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]


ALTER TABLE  [dbo].[Images]
 alter column description varchar(50) ;

ALTER TABLE  [dbo].[Images]
 alter column filename varchar(50) ;


ALTER TABLE  [dbo].[Images]
 alter column ownerid uniqueidentifier;

ALTER TABLE  [dbo].[Images]
 alter column ownerType varchar(10);

ALTER TABLE  [dbo].[Comments]
 alter column TargetListenToType varchar(10);
 
ALTER TABLE Tracks DROP COLUMN ArtistName
 
ALTER TABLE [dbo].[Article] 
ADD CONSTRAINT pk_Article PRIMARY KEY (ID)

ALTER TABLE [dbo].[Article]  ADD [ResourceURL] varchar(6000) 

ALTER TABLE  [dbo].Article
 alter column [PublishDate] datetime;

CREATE TABLE [dbo].[Actions](
[ID] [uniqueidentifier] NOT NULL,
[ActionType] [int] NOT NULL,

[ContentType]  int NOT NULL,
[ContentID] [uniqueidentifier] NOT NULL,

[PropertyType] int  NULL,
[OldValue] varchar(600)  NULL,
[NewValue] varchar(600)  NULL,

[OwnerID] [uniqueidentifier] NOT NULL,
[Created] datetime not null

) ON [PRIMARY]


CREATE TABLE [dbo].[ActionsArtists](

    [ActionID] [uniqueidentifier] NOT NULL,
    [ArtistID] [uniqueidentifier] NOT NULL,
) ON [PRIMARY]

CREATE TABLE [dbo].[ActionsTargetSites](
	[ActionID] [uniqueidentifier] NOT NULL,
	[SiteID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]



CREATE TABLE [dbo].[Relationships](CREATE TABLE [dbo].[Relationships](
	[ID] [uniqueidentifier] NOT NULL,
	[SourceID] [uniqueidentifier] NOT NULL,
	[SourceType] [int] NOT NULL,
	[TargetID] [uniqueidentifier] NOT NULL,
	[TargetType] [int] NOT NULL,
 CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE dbo.UsersPreferredStyles ADD CONSTRAINT
	PK_UsersPreferredStyles PRIMARY KEY CLUSTERED 
	(
	UserID,
	StyleID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE Venues  alter column LocationID [uniqueidentifier] NULL

 alter column description varchar(50) ;

GO


