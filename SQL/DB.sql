IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'transparent')
EXEC sys.sp_executesql N'CREATE SCHEMA [transparent] AUTHORIZATION [transparent]'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Styles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Styles](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Styles_ID]  DEFAULT (newid()),
	[Name] [varchar](50) NULL,
	[Description] [varchar](200) NULL,
 CONSTRAINT [PK_Styles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTownsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[GetTownsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest bit,
@SiteId as uniqueidentifier,
@CountryId as dateTime

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''



DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''  @SiteId  as uniqueidentifier , @CountryId as uniqueidentifier ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Name,
CountryId,
Created


FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if @CountryId<> null or @SiteId <> null 

	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID BASED COUNTRY SEARCH                                                                               */
/*******************************************************************************************************/

if @CountryId <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  CountryId = @CountryId ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD ID BASED SITE SEARCH                                                                               */
/*******************************************************************************************************/

if @SiteId <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  SiteId = @SiteId ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @SqlString = @SqlSelectString + ''vw_TownsView'' + @SqlFilterString


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name  varchar(50),
CountryId uniqueidentifier, 
Created datetime

)

INSERT INTO #TempItems (ID,Name, CountryId, CreatedDate)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
@SiteId = @SiteId, @CountryId = @CountryId


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Name,
		CountryId, 
		Created


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Name,
		CountryId, 
		Created

		FROM #TempItems

	end


/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddGig]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddGig]
(
@ID uniqueidentifier,
@Name varchar(50),
@Date DateTime,
@Description varchar(1000),
@VenueID uniqueidentifier,
@TicketPrice varchar(50),
@UserID uniqueidentifier,
@ImageID uniqueidentifier,
@Created DateTime
)

as

insert into Gigs
(ID,Name,Date,description,venueID,TicketPrice,UserID,ImageID,Created) values (@ID,@Name,@Date,@Description,@VenueID,@TicketPrice,@UserID,@ImageID,@Created)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddSite]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddSite]
(
@ID uniqueidentifier,
@LocationID uniqueidentifier,
@URL varchar(50),
@Name varchar(200)


)

as

insert into Sites
(ID,LocationID,URL,Name) values (@ID,@LocationID,@URL,@Name)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gigs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Gigs](
	[ID] [uniqueidentifier] NOT NULL,
	[VenueID] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Name] [varchar](100) NULL,
	[Description] [varchar](6000) NULL,
	[TicketPrice] [varchar](50) NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[ImageID] [uniqueidentifier] NULL,
	[Created] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_Gigs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Article]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Article](
	[ID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Body] [text] NOT NULL,
	[Created] [datetime] NOT NULL,
	[PublishDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[LocationID] [uniqueidentifier] NULL,
	[IsLocationSpecific] [bit] NULL,
	[ImageID] [uniqueidentifier] NULL,
	[IsPublished] [bit] NULL,
	[IsSuspended] [bit] NULL,
	[ResourceURL] [varchar](6000) NULL,
 CONSTRAINT [pk_Article] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BandClassifieds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BandClassifieds](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_BandClassifieds_ID]  DEFAULT (newid()),
	[ClassifiedID] [uniqueidentifier] NULL,
	[InstrumentID] [uniqueidentifier] NULL,
	[StyleID] [uniqueidentifier] NULL,
	[ArtistID] [uniqueidentifier] NULL,
	[ArtistName] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClassifiedsStyles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClassifiedsStyles](
	[ClassifiedID] [uniqueidentifier] NOT NULL,
	[StyleID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClassifiedsTowns]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClassifiedsTowns](
	[ClassifiedID] [uniqueidentifier] NOT NULL,
	[TownID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Instruments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Instruments](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Instruments_ID]  DEFAULT (newid()),
	[Name] [varchar](50) NULL,
	[Created] [datetime] NULL,
	[Performer] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetArticlesView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetArticlesView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@PublishedBefore as datetime,
@PublicationStatus as varchar(20),
@PublishedAfter as datetime,
@OwnerUserID as uniqueidentifier,
@SiteID as uniqueidentifier



as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''


DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@SiteID as uniqueidentifier, @OwnerUserID as uniqueidentifier,@PublishedBefore as datetime, @PublishedAfter as datetime ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlString =  ''

SELECT      

dbo.Article.ID, 
dbo.Users.Username,
dbo.Users.ID as UserID,
dbo.Article.Name, 
dbo.Article.Description,
dbo.Article.PublishDate,
Images_1.filename AS Filename, 
dbo.Article.IsPublished,  
dbo.Article.IsSuspended
                    
FROM         dbo.ArticlesTargetSites INNER JOIN
                      dbo.Article ON dbo.ArticlesTargetSites.ArticleID = dbo.Article.ID LEFT OUTER JOIN
                      dbo.Images Images_1 RIGHT OUTER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Article.ImageID = Images_2.ID LEFT OUTER JOIN
                      dbo.Users ON dbo.Article.UserID = dbo.Users.ID

''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @OwnerUserID <> null or @SiteID <>  null or @PublicationStatus <> null or @PublishedBefore <> null or @PublishedAfter <> null
	begin
		  set @SqlString = @SqlString + '' where ''
	end




/*******************************************************************************************************/
/* SITE SEARCH                                                                                                    */
/*******************************************************************************************************/

if @SiteID <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlString = @SqlString + '' and ''
			end




		SET @SqlString = @SqlString  +  '' dbo.ArticlesTargetSites.SiteID = @SiteID ''
		SET @NStatements=1
	end




/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  UserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlString = @SqlString + '' and ''

		end


		SET @SqlString = @SqlString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlString = @SqlString + '' and ''

		end


		SET @SqlString = @SqlString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlString = @SqlString + '' and  ''

		end

		SET @SqlString = @SqlString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  PublishDate <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  PublishDate >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  PublishDate >  @PublishedAfter and  PublishDate <   @PublishedBefore ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString + '' order by  PublishDate desc , Name ''

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Username  varchar(50),
UserID uniqueidentifier, 
Name varchar(50),
Description varchar(200), 
PublishDate datetime,
ImageID uniqueidentifier,
Filename  varchar(200), 
IsSuspended bit,
IsPublished bit,


)

INSERT INTO #TempItems (ID,Username, UserID, Name, Description, PublishDate, Filename,IsSuspended, IsPublished)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
  @OwnerUserID =@OwnerUserID, @SiteID = @SiteID, @PublishedBefore=@PublishedBefore, @PublishedAfter = @PublishedAfter


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		Filename, 
		IsSuspended,
		IsPublished 


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		Filename, 
		IsSuspended,
		IsPublished 


		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserClassifieds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserClassifieds](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_UserClassifieds_ID]  DEFAULT (newid()),
	[ClassifiedID] [uniqueidentifier] NOT NULL,
	[InstrumentID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMessagesView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetMessagesView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@ToUserID as uniqueidentifier,
@FromUserID as uniqueidentifier,
@ClassifiedID as uniqueidentifier

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE @OrderSQLString  NVARCHAR(4000)
SET @OrderSQLString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''

DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)

SET @ParamDef =''
@ToUserID as uniqueidentifier, 
@FromUserID as uniqueidentifier, 
@ClassifiedID as uniqueidentifier

''

/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Subject,
Created,
OwnerUserID, 
ClassifiedID,
ToUserID,
ToUsername,
FromUserID,
FromUsername,
IsRead

FROM

vw_Messages 
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if
	
	@ToUserID <>  null or 
	@FromUserID <> null or 
	@ClassifiedID <> null 

	
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end




/*******************************************************************************************************/
/* BUILD TOUSERID  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @ToUserID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ToUserID = @ToUserID ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD FROMUSERID  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @FromUserID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  FromUserID = @FromUserID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* BUILD CLASSIFIEDID  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @ClassifiedID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ClassifiedID = @ClassifiedID ''

		SET @NStatements=1

end

if @OrderByLatest=1
begin

set  @OrderSQLString = @OrderSQLString +  '' order by created desc''

end
else


begin
set @OrderSQLString = @OrderSQLString +  '' order by subject''
end


set @SqlString = @SqlSelectString +   @SqlFilterString + @OrderSQLString


	CREATE TABLE #TempItems
	(

		nID INT IDENTITY,
		ID uniqueidentifier, 
		Subject  varchar(50),
		Created datetime,
		OwnerUserID uniqueidentifier, 
		ClassifiedID  uniqueidentifier,
		ToUserID uniqueidentifier,
		ToUsername varchar(50),
		FromUserID uniqueidentifier,
		FromUsername varchar(50),
		IsRead bit
		
	)


	INSERT INTO #TempItems 
	(
		
		ID, 
		Subject,
		Created,
		OwnerUserID, 
		ClassifiedID,
		ToUserID,
		ToUsername,
		FromUserID,
		FromUsername,
		IsRead
	)
	
			
	exec  sp_executesql

	@SqlString, 
	@ParamDef, 
	@ToUserID = @ToUserID, @FromUserID = @FromUserID, @ClassifiedID=@ClassifiedID

/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Subject,
		Created,
		OwnerUserID, 
		ClassifiedID,
		ToUserID,
		ToUsername,
		FromUserID,
		FromUsername,
		IsRead

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end

else
 
	begin

		SELECT 

		ID, 
		Subject,
		Created,
		OwnerUserID, 
		ClassifiedID,
		ToUserID,
		ToUsername,
		FromUserID,
		FromUsername,
		IsRead

		FROM #TempItems

	end



/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/



Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateGeneralClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateGeneralClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier
)
AS

-- Add the Classifieds info

update  dbo.Classifieds

set 

dbo.Classifieds.Title = @Title,
dbo.Classifieds.Body = @Body,
dbo.Classifieds.IsActive = @IsActive,
dbo.Classifieds.Type = @Type,
dbo.Classifieds.OwnerUserID = @OwnerUserID,

dbo.Classifieds.FirstPublished =	@FirstPublished ,
dbo.Classifieds.IsPublished = @IsPublished,
dbo.Classifieds.IsSuspended = @IsSuspended,
dbo.Classifieds.ImageID = @ImageID

where 

dbo.Classifieds.ID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddGeneralClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddGeneralClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier


)
AS

-- Add the Classifieds info

Insert into dbo.Classifieds

(
dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID,
dbo.Classifieds.FirstPublished, 
dbo.Classifieds.IsPublished, 
dbo.Classifieds.IsSuspended,
dbo.Classifieds.ImageID
)

Values

(
@ID, 
@Title, 
@Body, 
@Created, 
@IsActive, 
@Type, 
@OwnerUserID,
@FirstPublished,
@IsPublished,
@IsSuspended,
@ImageID
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetReviewLocationFromCache]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*This is required so that we can search for reviews by location */ 
/* We could put the locationID from the Artist into the review table when the artist is created
However, should the artist move, the location it was assocated with would become invalid*/


CREATE PROCEDURE [dbo].[GetReviewLocationFromCache]

@OwnerType as VarChar(10),
@OwnerID as uniqueidentifier,
@OwnerIDs as varchar(500),
@ImageID as uniqueidentifier

as
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInstrumentsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetInstrumentsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest bit

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''


DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Name,
Performer,
Created

FROM
''





/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @SqlString = @SqlSelectString + ''  Instruments '' + @SqlFilterString


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name  varchar(50),
Performer  varchar(50),
Created datetime

)

INSERT INTO #TempItems (ID,Name, Performer, Created)

        
exec  sp_executesql 
@SqlString, 
@ParamDef


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Name,
		Performer,
		Created


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Name,
		Performer,
		Created

		FROM #TempItems

	end


/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserIdentityList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserIdentityList]

@UserIdentityID as uniqueidentifier,
@Username as varchar(50),
@EmailAddress as varchar(50)

as

DECLARE  @SQLString NVARCHAR(500)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @NStatements bit

SET @SqlString =''''
SET @SqlString = @SqlString + ''SELECT   dbo.Users.ID, dbo.Users.Username from  dbo.Users''
SET @ParmDefinition =''@UserIdentityID as uniqueidentifier, @Username as varchar(50), @EmailAddress as varchar(50) ''
SET @NStatements=0


if @UserIdentityID <> null or @Username <> null  or @EmailAddress <> null  
begin
  set @SqlString = @SqlString + '' where ''
end


if @UserIdentityID <> null

begin

SET @SqlString = @SqlString + '' dbo.Users.ID = @UserIdentityID ''

Set @NStatements=1

end



if @Username <> null

begin


if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' dbo.Users.Username = @Username ''

end


if @EmailAddress <> null

begin


if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' dbo.Users.EmailAddress = @EmailAddress ''

end


SET @SqlString = @SqlString + '' order by  dbo.Users.Username''

 Exec  sp_executesql @SqlString,@ParmDefinition,@UserIdentityID,@Username, @EmailAddress' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVenueList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*******************************************************************************************************/
/* Created 03/04/2006                                                                                                     */
/* This is a simple SP that returns a VenueList based upon the criteria passed.                */         
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetVenueList]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@TownIDs as varchar(500)


as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
DECLARE @SqlFilterString  NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)

SET @NStatements = 0
SET @SqlFilterString=''  ''
SET @SqlString =

''
Select id,name 
from venues

''

SET @ParamDef =''@TownIDs as varchar(500) ''


/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @TownIDs <> null  
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* TOWN SEARCH                                                                                                           */
/*******************************************************************************************************/

if @TownIDs <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblTowns FROM fnSplitter(@TownIDs)

		SET @SqlFilterString = @SqlFilterString  + '' TownID in (select id from #tblTowns) ''
		
		SET @NStatements=1
	end


SET @SqlString = @SqlString + @SqlFilterString

/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString 

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name  varchar(50),


)

INSERT INTO #TempItems (ID,Name)

        
exec  sp_executesql 
@SqlString,
@ParamDef, 
 @TownIds = @TownIds



/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Name

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Name

		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMessage]
(
@ID uniqueidentifier
)
AS



SELECT 

id, 
Subject, 
Body,  
ToUserID, 
FromUserID, 
OwnerUserID, 
ClassifiedID, 
ParentMessageID, 
IsRead, 
Created

FROM 

Messages

Where ID = @ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dtproperties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dtproperties](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectid] [int] NULL,
	[property] [varchar](64) NOT NULL,
	[value] [varchar](255) NULL,
	[uvalue] [nvarchar](255) NULL,
	[lvalue] [image] NULL,
	[version] [int] NOT NULL DEFAULT (0),
 CONSTRAINT [pk_dtproperties] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[property] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Messages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Messages](
	[ID] [uniqueidentifier] NOT NULL,
	[ClassifiedId] [uniqueidentifier] NOT NULL,
	[ParentMessageId] [uniqueidentifier] NULL,
	[ToUserId] [uniqueidentifier] NOT NULL,
	[FromUserId] [uniqueidentifier] NOT NULL,
	[Subject] [varchar](50) NOT NULL,
	[Body] [text] NOT NULL,
	[IsRead] [bit] NULL,
	[Created] [datetime] NOT NULL,
	[OwnerUserId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reviews]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Reviews](
	[ID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Body] [text] NOT NULL,
	[Created] [datetime] NOT NULL,
	[PublishDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[ImageID] [uniqueidentifier] NULL,
	[SubjectListenToType] [char](10) NOT NULL,
	[SubjectListenToTypeID] [uniqueidentifier] NOT NULL,
	[RatingID] [uniqueidentifier] NULL,
	[IsPublished] [bit] NULL,
	[IsSuspended] [bit] NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Podcast]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Podcast](
	[ID] [uniqueidentifier] NULL CONSTRAINT [DF_Podcast_ID]  DEFAULT (newid()),
	[Title] [varchar](50) NULL,
	[Description] [text] NULL,
	[UserID] [uniqueidentifier] NULL,
	[FirstPublished] [datetime] NULL,
	[IsPublished] [bit] NULL,
	[IsSuspended] [bit] NULL,
	[Created] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRatingsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetRatingsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@OwnerUserID as uniqueidentifier,
@SubjectListenToType as varchar(10),
@SubjectListenToTypeID as uniqueidentifier

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''


DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''

DECLARE @NStatements bit
SET @NStatements=0

DECLARE @ParamDef NVARCHAR(500)
SET @ParamDef ='' @OwnerUserID as uniqueidentifier, @SubjectListenToTypeID  as uniqueidentifier, @SubjectListenToType as varchar(10)''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlString =  ''
SELECT     

ID, 
Score,
OwnerUserID, 
OwnerUsername,
SubjectListenToType,
SubjectListenToTypeID, 
Created


FROM 

vw_Ratings

''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @OwnerUserID <> null or @SubjectListenToTypeID <>  null or @SubjectListenToType <>  null 
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @SubjectListenToTypeID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  SubjectListenToTypeID = @SubjectListenToTypeID ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD TYPE SEARCH                                                                              		     */
/*******************************************************************************************************/

if @SubjectListenToType <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  SubjectListenToType = @SubjectListenToType ''

		SET @NStatements=1

end



/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  OwnerUserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end




SET @SqlString = @SqlString + @SqlFilterString

/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString + '' order by  Created desc''

	end
else


	begin



		SET @SqlString = @SqlString 


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
	
	nID INT IDENTITY,
	ID uniqueidentifier, 
	Score int,
	OwnerUserID uniqueidentifier, 
	OwnerUsername  varchar(50),
	SubjectListenToType  varchar(20), 
	SubjectListenToTypeID uniqueidentifier, 
	Created DateTime

)

INSERT INTO #TempItems (ID, Score, OwnerUserID, OwnerUsername, SubjectListenToType, SubjectListenToTypeID, Created)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
 @OwnerUserID =@OwnerUserID, @SubjectListenToTypeID = @SubjectListenToTypeID,@SubjectListenToType = @SubjectListenToType


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Score,
		OwnerUserID, 
		OwnerUsername,
		SubjectListenToType,
		SubjectListenToTypeID, 
		Created

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Score,
		OwnerUserID, 
		OwnerUsername,
		SubjectListenToType,
		SubjectListenToTypeID, 
		Created

		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AssertionTargetSites]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AssertionTargetSites](
	[AssertionID] [uniqueidentifier] NOT NULL,
	[SiteID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AssertionTargetSites] PRIMARY KEY CLUSTERED 
(
	[AssertionID] ASC,
	[SiteID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Classifieds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Classifieds](
	[ID] [uniqueidentifier] NOT NULL,
	[Title] [varchar](150) NULL,
	[Body] [varchar](3000) NULL,
	[Created] [datetime] NULL,
	[OwnerUserID] [uniqueidentifier] NULL,
	[IsActive] [bit] NULL,
	[Type] [varchar](50) NULL,
	[IsPublished] [bit] NULL,
	[FirstPublished] [datetime] NULL,
	[IsSuspended] [bit] NULL,
	[ImageID] [uniqueidentifier] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Opinions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Opinions](
	[ID] [uniqueidentifier] NOT NULL,
	[Body] [text] NULL,
	[OwnerUserID] [uniqueidentifier] NULL,
	[Created] [datetime] NULL,
	[AssertionID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Opinions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Actions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Actions](
	[ID] [uniqueidentifier] NOT NULL,
	[ActionType] [int] NOT NULL,
	[ContentType] [int] NOT NULL,
	[ContentID] [uniqueidentifier] NOT NULL,
	[PropertyType] [int] NULL,
	[OldValue] [varchar](600) NULL,
	[NewValue] [varchar](600) NULL,
	[OwnerID] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionsArtists]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionsArtists](
	[ActionID] [uniqueidentifier] NOT NULL,
	[ArtistID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionsTargetSites]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionsTargetSites](
	[ActionID] [uniqueidentifier] NOT NULL,
	[SiteID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAssertionsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetAssertionsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@PublishedBefore as datetime,
@PublicationStatus as varchar(20),
@PublishedAfter as datetime,
@OwnerUserID as uniqueidentifier,
@SiteID as uniqueidentifier,
@IsActive as bit



as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''


DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@IsActive as bit, @SiteID as uniqueidentifier, @OwnerUserID as uniqueidentifier,@PublishedBefore as datetime, @PublishedAfter as datetime ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlString =  ''

SELECT      

ID, 
Name,
Description,
OwnerUserID,
OwnerUsername,
ThumbnailFilename, 
Created,
NumberOfOpinions,
FirstPublished,
IsSuspended,
IsPublished,  
IsActive


FROM       

vw_AssertionsView

''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @IsActive <> null or @OwnerUserID <> null or @SiteID <>  null or @PublicationStatus <> null or @PublishedBefore <> null or @PublishedAfter <> null
	begin
		  set @SqlString = @SqlString + '' where ''
	end




/*******************************************************************************************************/
/* SITE SEARCH                                                                                                    */
/*******************************************************************************************************/

if @SiteID <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlString = @SqlString + '' and ''
			end




		SET @SqlString = @SqlString  +  '' SiteID = @SiteID ''
		SET @NStatements=1
	end




/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  OwnerUserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlString = @SqlString + '' and ''

		end


		SET @SqlString = @SqlString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlString = @SqlString + '' and ''

		end


		SET @SqlString = @SqlString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlString = @SqlString + '' and  ''

		end

		SET @SqlString = @SqlString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  FirstPublished <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  FirstPublished >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  FirstPublished >  @PublishedAfter and  FirstPublished <   @PublishedBefore ''

		SET @NStatements = 1
		
	end




/*******************************************************************************************************/
/* ACTIVE                                                                                             	  	    */
/*******************************************************************************************************/


if @NStatements <> 0

		begin
			SET @SqlString = @SqlString + '' and ''
		end

		SET @SqlString = @SqlString + ''  IsActive = @IsActive  ''

		SET @NStatements = 1




/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString + '' order by  FirstPublished desc, Name''

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name varchar(300),
Description varchar(300), 
OwnerUserID uniqueidentifier, 
OwnerUsername  varchar(50),
ThumbnailFilename varchar(200), 
Created datetime,
NumberOfOpinions int,
FirstPublished datetime,
IsSuspended bit,
IsPublished bit,
IsActive bit






)



INSERT INTO #TempItems (ID, Name, Description, OwnerUserID, OwnerUsername, ThumbnailFilename, Created, NumberOfOpinions,  FirstPublished,IsSuspended, IsPublished, IsActive)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
  @IsActive =@IsActive,  @OwnerUserID =@OwnerUserID, @SiteID = @SiteID, @PublishedBefore=@PublishedBefore, @PublishedAfter = @PublishedAfter





/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

			ID, 
			Name, 
			Description, 
			OwnerUserID,
			 OwnerUsername, 
			ThumbnailFilename, 
			Created, 
			NumberOfOpinions, 
			 FirstPublished,
			IsSuspended, 
			IsPublished, 
			IsActive


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

			ID, 
			Name, 
			Description, 
			OwnerUserID,
			 OwnerUsername, 
			ThumbnailFilename, 
			Created, 
			NumberOfOpinions, 
			 FirstPublished,
			IsSuspended, 
			IsPublished, 
			IsActive


		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GigAttendees]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GigAttendees](
	[GigID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Relationships]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Relationships](
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
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RemoveActiveAssertions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[RemoveActiveAssertions]

@SiteIds as varchar(500)

as



SELECT *
INTO #tblSiteIds
FROM fnSplitter(@SiteIds)



/*Grab the Assertion IDS*/

SELECT      dbo.Assertions.ID into #tblAssertionIds
FROM         dbo.Assertions INNER JOIN
                      dbo.AssertionTargetSites ON dbo.Assertions.ID = dbo.AssertionTargetSites.AssertionID where  dbo.AssertionTargetSites.SiteID in (select id from #tblSiteIds)


/*Perform the update*/
Update Assertions

set IsActive=0

where ID in (select id from #tblAssertionIds)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetOpinionsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetOpinionsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest bit,
@AssertionID as uniqueidentifier,
@OwnerUserID as uniqueidentifier

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''



DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''  @OwnerUserID  as uniqueidentifier , @AssertionID as uniqueidentifier ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Body,
OwnerUserID,
OwnerUsername,
AssertionID,
AssertionName,
Created


FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if @AssertionID<> null or @OwnerUserID <> null 

	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID BASED COUNTRY SEARCH                                                                               */
/*******************************************************************************************************/

if @AssertionID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  AssertionID = @AssertionID ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD ID BASED SITE SEARCH                                                                               */
/*******************************************************************************************************/

if @OwnerUserID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  OwnerUserID = @OwnerUserID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @SqlString = @SqlSelectString + ''vw_OpinionsView'' + @SqlFilterString + '' order by created''




/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/



CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Body  text,
OwnerUserID uniqueidentifier, 
OwnerUsername varchar(50),
AssertionID uniqueidentifier, 
AssertionName varchar(200),
Created datetime
)



INSERT INTO #TempItems (ID, Body, OwnerUserID, OwnerUsername, AssertionID,  AssertionName, Created)

exec  sp_executesql 
@SqlString, 
@ParamDef, 
@OwnerUserID = @OwnerUserID, @AssertionID = @AssertionID

/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

			ID , 
			Body  ,
			OwnerUserID , 
			OwnerUsername ,
			AssertionID , 
			AssertionName,
			Created 


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

			ID , 
			Body  ,
			OwnerUserID , 
			OwnerUsername ,
			AssertionID , 
			AssertionName,
			Created 

		FROM #TempItems

	end


/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplitter]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[fnSplitter] (@IDs Varchar(1000))
Returns @Tbl_IDS Table (ID Uniqueidentifier) as

Begin

Set @IDs = @IDs + '',''


Declare @Pos1 int
Declare @Pos2 int

Set @Pos1=1
Set @Pos2=1

While @Pos1 < Len(@IDS)

Begin

Set @Pos1 = CharIndex('','',@IDs,@Pos1)
Insert @Tbl_IDs Select Cast (Substring(@IDs,@Pos2,@Pos1-@Pos2) as Uniqueidentifier)
Set @Pos2=@Pos1+1
Set @Pos1=@Pos1+1
End 

Return

End








' 
END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnStringSplitter]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[fnStringSplitter] (@strings Varchar(1000))
Returns @Tbl_IDS Table (string varchar(50)) as

Begin

Set @strings = @strings + '',''


Declare @Pos1 int
Declare @Pos2 int

Set @Pos1=1
Set @Pos2=1

While @Pos1 < Len(@strings)

Begin

Set @Pos1 = CharIndex('','',@strings,@Pos1)
Insert @Tbl_IDs Select  Substring(@strings,@Pos2,@Pos1-@Pos2)
Set @Pos2=@Pos1+1
Set @Pos1=@Pos1+1
End 

Return

End




' 
END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommentsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetCommentsView]
@Count as int,
@OrderByLatest bit,
@TargetListenToTypeID as  uniqueidentifier,
@TargetListenToType as varchar(10)




as


DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@TargetListenToTypeID as uniqueidentifier,@TargetListenToType as varchar(10)''



/* TOP n */

if @Count <> null
begin
SET ROWCOUNT @Count 
end

SET @NStatements=0
SET @SqlString =''''
SET @SqlString = @SqlString + 

''
SELECT     dbo.Comments.ID, dbo.Comments.Body, dbo.Comments.UserID, dbo.Users.Username, dbo.Comments.TargetListenToType, 
                      dbo.Comments.TargetListenToTypeID, dbo.Comments.Created
FROM         dbo.Comments INNER JOIN
                      dbo.Users ON dbo.Comments.UserID = dbo.Users.ID
''

if @TargetListenToType<> null or @TargetListenToTypeID <> null 
begin
  set @SqlString = @SqlString + '' where ''
end




/*TARGET ID SEARCH*/

if @TargetListenToTypeID <> null
begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''  dbo.Comments.TargetListenToTypeID = @TargetListenToTypeID ''
set @NStatements=1
end

/*TARGET TYPE SEARCH*/

if @TargetListenToType <> null
begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''  dbo.Comments.TargetListenToType = @TargetListenToType''
end


/*ORDER*/
if @OrderByLatest = 1
begin

SET @SqlString = @SqlString + ''  order by dbo.Comments.Created desc''
end
else
begin

SET @SqlString = @SqlString + ''  order by dbo.Comments.Created  ''
end


print @SqlString

Exec  sp_executesql 
@SqlString, 
@ParamDef,
@TargetListenToType = @TargetListenToType,@TargetListenToTypeID=@TargetListenToTypeID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Assertions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Assertions](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Assertions_ID]  DEFAULT (newid()),
	[Name] [varchar](200) NOT NULL,
	[Description] [char](200) NOT NULL,
	[Body] [text] NOT NULL,
	[OwnerUserID] [uniqueidentifier] NOT NULL,
	[ImageID] [uniqueidentifier] NOT NULL,
	[FirstPublished] [datetime] NOT NULL,
	[IsPublished] [bit] NOT NULL,
	[IsSuspended] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_Assertions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ratings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Ratings](
	[ID] [uniqueidentifier] NOT NULL,
	[Score] [int] NULL,
	[UserID] [uniqueidentifier] NULL,
	[SubjectListenToType] [varchar](50) NULL,
	[SubjectListenToTypeID] [uniqueidentifier] NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Ratings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_ID]  DEFAULT (newid()),
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Forename] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Profile] [varchar](1000) NULL,
	[EmailAddress] [varchar](50) NOT NULL,
	[AvatarImageID] [uniqueidentifier] NULL,
	[Created] [datetime] NULL,
	[IsUserValidated] [bit] NULL,
	[TownID] [uniqueidentifier] NULL,
	[AlternativeLocation] [varchar](50) NULL,
	[RecievesNewsletter] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActsList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetActsList]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit



as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =

''

SELECT DISTINCT ArtistID AS ID, Name
FROM         dbo.Acts


''

/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString 

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name  varchar(50),


)

INSERT INTO #TempItems (ID,Name)

        
exec  sp_executesql 
@SqlString


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Name

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Name

		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_verstamp006]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	This procedure returns the version number of the stored
**    procedures used by legacy versions of the Microsoft
**	Visual Database Tools.  Version is 7.0.00.
*/
create procedure [dbo].[dt_verstamp006]
as
	select 7000
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddReview]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(50),
@Description varchar(200),
@Body text,
@Created DateTime,
@PublishDate DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit,
@SubjectListenToType varchar(15),
@SubjectListenToTypeID uniqueidentifier,
@RatingID uniqueidentifier

)

as

insert into Reviews
(
ID,
UserID,
Name,
Description,
Body,
Created,
PublishDate,
ImageID,
IsPublished,
IsSuspended,
SubjectListenToType,
SubjectListenToTypeID,
RatingID
)

values 
(

@ID,
@OwnerUserID,
@Name,
@Description,
@Body,
@Created,
@PublishDate,
@ImageID,
@IsPublished,
@IsSuspended,
@SubjectListenToType,
@SubjectListenToTypeID,
@RatingID
)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_verstamp007]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	This procedure returns the version number of the stored
**    procedures used by the the Microsoft Visual Database Tools.
**	Version is 7.0.05.
*/
create procedure [dbo].[dt_verstamp007]
as
	select 7005
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGigReviewsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetGigReviewsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@PublishedBefore as datetime,
@PublishedAfter as datetime,
@PublicationStatus as varchar(10),
@ArtistID as uniqueidentifier,
@ArtistName as varchar(50),
@VenueID as uniqueidentifier,
@OwnerUserID  as uniqueidentifier


as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''

DECLARE  @GigByArtistSQLString NVARCHAR(4000)
SET @GigByArtistSQLString =''  ''

DECLARE  @GigSQLString NVARCHAR(4000)
SET @GigSQLString =''  ''

DECLARE  @VenueSQLString NVARCHAR(4000)
SET @VenueSQLString =''  ''

DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@VenueID as uniqueidentifier, @ArtistID as uniqueidentifier, @ArtistName as varchar(50),  @PublishedBefore as datetime, @PublishedAfter as datetime ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     distinct

ID, 
Username,
UserID, 
Name,
Description, 
PublishDate,
ExpiryDate, 
ImageID,
Filename, 
SubjectListenToTypeID, 
SubjectListenToType,
TownID,
IsSuspended,
IsPublished,
Score

FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @ArtistID <> null  or @VenueID <> null or @PublicationStatus <> null or @PublishedBefore <> null or @PublishedAfter <> null
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID BASED ARTISTID SEARCH                                                                          */
/*******************************************************************************************************/

if @ArtistID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ArtistID = @ArtistID ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD ID BASED ARTISTNAME SEARCH                                                                 */
/*******************************************************************************************************/

if @ArtistName <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ArtistName = @ArtistName ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* BUILD ID BASED VENUEID SEARCH                                                                          */
/*******************************************************************************************************/

if @VenueID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  VenueID = @VenueID ''

		SET @NStatements=1

end







/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and  ''

		end

		SET @SqlFilterString = @SqlFilterString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter and  PublishDate <   @PublishedBefore ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @SqlString = @SqlSelectString + ''vw_GigReviewsDetailed'' + @SqlFilterString

/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString + '' order by  PublishDate desc''

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Username  varchar(50),
UserID uniqueidentifier, 
Name varchar(50),
Description varchar(200), 
PublishDate datetime,
ExpiryDate datetime, 
ImageID uniqueidentifier,
Filename  varchar(200), 
SubjectListenToTypeID uniqueidentifier, 
SubjectListenToType  varchar(20), 
TownID uniqueidentifier,
IsSuspended bit,
IsPublished bit,
Score integer

)

INSERT INTO #TempItems (ID,Username, UserID, Name, Description, PublishDate, ExpiryDate, ImageID, Filename,SubjectListenToTypeID, SubjectListenToType, TownID, IsSuspended, IsPublished, Score)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
 @ArtistID = @ArtistID, @ArtistName = @ArtistName,  @VenueID =@VenueID, @PublishedBefore= @PublishedBefore, @PublishedAfter=@PublishedAfter


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		ExpiryDate, 
		ImageID,
		Filename, 
		SubjectListenToTypeID, 
		SubjectListenToType,
		TownID,
		IsSuspended,
		IsPublished,
		Score

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		ExpiryDate, 
		ImageID,
		Filename, 
		SubjectListenToTypeID, 
		SubjectListenToType,
		TownID,
		IsSuspended,
		IsPublished,
		Score

		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateReview]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(50),
@Description varchar(200),
@Body text,
@Created DateTime,
@PublishDate DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit,
@SubjectListenToType varchar(15),
@SubjectListenToTypeID uniqueidentifier,
@RatingID uniqueidentifier

)

as

UPDATE  Reviews

set


UserID = @OwnerUserID,
Name = @Name,
Description=@Description,
Body =  @Body,
Created = @Created,
PublishDate = @PublishDate,
ImageID = @ImageID,
IsPublished = @IsPublished,
IsSuspended = @IsSuspended,
SubjectListenToType = @SubjectListenToType,
SubjectListenToTypeID = @SubjectListenToTypeID,
RatingID = @RatingID


where 

ID = @ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_displayoaerror]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dt_displayoaerror]
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = master.dbo.sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + '': '' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Plays]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Plays](
	[ID] [uniqueidentifier] NOT NULL,
	[IP] [char](15) NOT NULL,
	[UserID] [uniqueidentifier] NULL,
	[TrackID] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Plays] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTracksView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetTracksView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest bit,
@PublishedBefore as datetime,
@PublishedAfter as datetime,
@TownIDs as varchar(500),
@TrackIDs as varchar(500),
@ArtistID as uniqueidentifier,
@ArtistIDs as varchar(1000),
@StyleID as uniqueidentifier,
@OwnerUserID as uniqueidentifier,
@PublicationStatus as varchar(10)



as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlSelectString   NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''


DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''


DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef ='' @ArtistIDs as varchar(1000), @TrackIDs as varchar(500), @TownIDs as varchar(500), @OwnerUserID as uniqueidentifier, @ArtistID  as uniqueidentifier,   @StyleID as uniqueidentifier, @PublishedBefore as datetime , @PublishedAfter as dateTime ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Name,
Description, 
UserID, 
Username,
ArtistID,
ArtistName,
ArtistProfileAddress,
StyleID,
StyleName,
FirstPublished,
IsPublished,
IsSuspended,
TotalRating,
NumVotes,
TotalPlays


FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @TownIDs <> null  or @OwnerUserID <> null or @ArtistID <>  null or @StyleID <> null or @ArtistIDs <> null or @TrackIDs <> null or @PublicationStatus<>null

	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ARTISTID BASED TYPE SEARCH                                                                   */
/*******************************************************************************************************/

if @ArtistID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ArtistID = @ArtistID ''

		SET @NStatements=1

end



/*******************************************************************************************************/
/* BUILD ARTISTID BASED TYPE SEARCH                                                                   */
/*******************************************************************************************************/


if @ArtistIDs <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblArtistIDs FROM fnSplitter(@ArtistIDs)

		SET @SqlFilterString = @SqlFilterString  + ''ArtistID  in (select id from #tblArtistIDs) ''
		
		SET @NStatements=1
	end



/*******************************************************************************************************/
/* BUILD TRACKIDs BASED TYPE SEARCH                                                                   */
/*******************************************************************************************************/


if @TrackIDs <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblTrackIDs FROM fnSplitter(@TrackIDs)

		SET @SqlFilterString = @SqlFilterString  + '' ID  in (select id from #tblTrackIDs)  ''
		
		SET @NStatements=1
	end


/*******************************************************************************************************/
/* BUILD STYLEID BASED TYPE SEARCH                                                                   */
/*******************************************************************************************************/

if @StyleID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  StyleID = @StyleID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* TOWN SEARCH                                                                                                    */
/*******************************************************************************************************/

if @TownIDs <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblTowns FROM fnSplitter(@TownIDs)

		SET @SqlFilterString = @SqlFilterString  + ''TownID  in (select id from #tblTowns) ''
		
		SET @NStatements=1
	end



/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  UserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and  ''

		end

		SET @SqlFilterString = @SqlFilterString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter and  PublishDate <   @PublishedBefore ''

		SET @NStatements = 1
		
	end





Set @SqlString = @SqlSelectString + ''  vw_TracksView''  + @SqlFilterString 


if @OrderByLatest=1

begin

Set @SqlString = @SqlString + ''  order by FirstPublished desc ''

end

else

begin

Set @SqlString = @SqlString + ''  order by Name ''

end


/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Name varchar(50),
Description varchar(200), 
UserID uniqueidentifier, 
Username  varchar(50),
ArtistID uniqueidentifier,
ArtistName varchar(50),
ArtistProfileAddress varchar(50),
StyleID uniqueidentifier,
StyleName varchar(50),
FirstPublished datetime,
IsPublished bit,
IsSuspended bit,
TotalRating int,
NumVotes int,
TotalPlays int
)



INSERT INTO #TempItems (ID,Name, Description,UserID,Username, ArtistID, ArtistName, ArtistProfileAddress, StyleID, StyleName, FirstPublished, IsPublished, IsSuspended, TotalRating, NumVotes, TotalPlays)

        



exec  sp_executesql 
@SqlString, 
@ParamDef, 
@ArtistIDs = @ArtistIDs, @TownIDs = @TownIDs,  @OwnerUserID =@OwnerUserID, @TrackIDs = @TrackIDs, @ArtistID = @ArtistID, @StyleID = @StyleID, @PublishedBefore = @PublishedBefore, @PublishedAfter = @PublishedAfter 



/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID , 
		Name,
		Description ,
		UserID ,
		Username,  
		ArtistID,
		ArtistName,
		ArtistProfileAddress,
		StyleID ,
		StyleName,
		FirstPublished,
		IsPublished,
		IsSuspended,
		TotalRating,
		NumVotes,
		TotalPlays



		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

				ID , 
		Name,
		Description ,
		UserID ,
		Username,  
		ArtistID,
		ArtistName,
		ArtistProfileAddress,
		StyleID ,
		StyleName,
		FirstPublished,
		IsPublished,
		IsSuspended,
		TotalRating,
		NumVotes,
		TotalPlays

		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_vcsenabled]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_vcsenabled]

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = ''SQLVersionControl.VCS_SQL''

    declare @iReturn int
    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('''', 16, -1) /* Can''t Load Helper DLLC */


' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[depricated_GetGigsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[depricated_GetGigsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@LocationIDs as varchar(500),
@BeforeDate as DateTime,
@OnDate as DateTime,
@AfterDate as DateTime,
@VenueID as uniqueidentifier,
@ArtistID as uniqueidentifier,
@ActName as varchar(100)


as


DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@LocationIDs as varchar(500),
@BeforeDate as DateTime,
@OnDate as DateTime,
@AfterDate as DateTime,
@VenueID as uniqueidentifier,
@ActName as varchar(100),
@ArtistID as uniqueidentifier''


/* TOP n */
/*
if @Count <> null
begin
SET ROWCOUNT @Count 
end
*/

SET @NStatements=0
SET @SqlString =''''
SET @SqlString = @SqlString + 




''SELECT DISTINCT 
                      dbo.Gigs.ID, dbo.Gigs.Name, dbo.Venues.ID AS VenueID, dbo.Venues.Name AS VenueName, dbo.Gigs.Date, 
                      Images_1.filename AS ThumbnailFilename
FROM         dbo.Images Images_1 RIGHT OUTER JOIN
                      dbo.Images ON Images_1.ID = dbo.Images.ThumbnailID RIGHT OUTER JOIN
                      dbo.Venues INNER JOIN
                      dbo.Gigs ON dbo.Venues.ID = dbo.Gigs.VenueID INNER JOIN
                      dbo.Acts ON dbo.Gigs.ID = dbo.Acts.GigID ON dbo.Images.ID = dbo.Gigs.ImageID''


if @LocationIDs <> null or @BeforeDate <> null or @OnDate <> null   or @AfterDate <> null or @VenueID <> null or @ActName<> null or @ArtistID <> null
begin
  set @SqlString = @SqlString + '' where ''
end

/* LOCATION SEARCH */

if @LocationIDs <> null

begin

SELECT *
INTO #tblLocations
FROM fnSplitter(@LocationIDs)

SET @SqlString = @SqlString + ''LocationID in (select id from #tblLocations) ''
SET @NStatements=1
end

/*DATE SEARCH */


if @BeforeDate <> null and @AfterDate <> null

begin

/*BETWEEN DATES*/

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''(Date  BETWEEN @AfterDate AND @BeforeDate) ''

SET @NStatements=1
end


/*BEFORE DATE */

if @BeforeDate <> null and @AfterDate = null

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Date  < = @BeforeDate ''


SET @NStatements=1
end

/*AFTER DATE */

if @BeforeDate = null and @AfterDate <> null

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Date >= @AfterDate ''


SET @NStatements=1
end

/*ON DATE */

if @OnDate <> null 

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Date = @OnDate ''


SET @NStatements=1
end




/*VENUE SEARCH*/

if @VenueID <> null

begin


if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''((@VenueID is null) or (VenueID =  @VenueID))''
SET @NStatements=1
end	

/*NAME SEARCH*/

if @ActName <> null
begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' ((@ActName is null) or (dbo.Acts.Name like  @ActName))''
SET @NStatements=1
end
print @SqlString



/*VENUE SEARCH*/

if @ArtistID <> null

begin


if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''  (dbo.Acts.ArtistID =  @ArtistID)''
SET @NStatements=1
end	



/*ORDER*/

if(@OrderByLatest=0)

begin

SET @SqlString = @SqlString + ''  order by dbo.Gigs.Name ''
end

else
begin
SET @SqlString = @SqlString + ''  order by dbo.Gigs.Date ''
end

/*
Exec  sp_executesql 
@SqlString, 
@ParamDef,
@LocationIDs =@LocationIDs,
@StartDate =@StartDate,
@EndDate =@EndDate,
@VenueID = @VenueID,
@ActName = @ActName,
@ArtistID=@ArtistID
*/









/*PLACE IN TEMP TABLE*/









--Create a temporary table
CREATE TABLE #TempItems
(
	nID INT IDENTITY,
	ID uniqueidentifier,
	Name varchar(50),
	VenueID uniqueidentifier,
	VenueName varchar(50),
	Date datetime,
	ThumbFilename varchar(50)

)


-- Insert
INSERT INTO #TempItems (ID,NAME,VenueID,VenueName,Date,ThumbFilename)

        
Exec  sp_executesql 
@SqlString, 
@ParamDef,
@LocationIDs =@LocationIDs,
@BeforeDate =@BeforeDate,
@OnDate =@OnDate,
@AfterDate =@AfterDate,
@VenueID = @VenueID,
@ActName = @ActName,
@ArtistID=@ArtistID




/*PAGIN*/

if( @FirstRecord<>null)
begin


-- Now, return the set of paged records
SELECT 

	ID,
	Name,
	VenueID,
	VenueName,
	Date datetime,
	ThumbFilename

FROM #TempItems
WHERE nID >= @FirstRecord AND nID <= @LastRecord


/*Return total number of results*/

end



else 
begin

SELECT 

	ID,
	Name,
	VenueID,
	VenueName,
	Date datetime,
	ThumbFilename

FROM #TempItems


end

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tracks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tracks](
	[ID] [uniqueidentifier] NOT NULL,
	[StyleID] [uniqueidentifier] NOT NULL,
	[ArtistID] [uniqueidentifier] NULL,
	[Title] [varchar](50) NOT NULL,
	[Description] [varchar](3000) NOT NULL,
	[Filename] [varchar](200) NULL,
	[Length] [int] NULL,
	[Studio] [varchar](50) NULL,
	[Producer] [varchar](50) NULL,
	[Engineer] [varchar](50) NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[FirstPublished] [datetime] NULL,
	[IsPublished] [bit] NULL,
	[IsSuspended] [bit] NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Tracks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SiteTowns]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SiteTowns](
	[SiteId] [uniqueidentifier] NOT NULL,
	[TownId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SiteTowns] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[TownId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Countries]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Countries](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Countries_ID]  DEFAULT (newid()),
	[Name] [varchar](50) NOT NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ArticlesTargetSites]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ArticlesTargetSites](
	[ArticleID] [uniqueidentifier] NOT NULL,
	[SiteID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ArticlesTargetSites] PRIMARY KEY CLUSTERED 
(
	[ArticleID] ASC,
	[SiteID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Images]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Images](
	[ID] [uniqueidentifier] NOT NULL,
	[height] [int] NOT NULL,
	[width] [int] NOT NULL,
	[description] [varchar](50) NULL,
	[filename] [varchar](50) NULL,
	[OwnerID] [uniqueidentifier] NULL,
	[OwnerType] [varchar](10) NULL,
	[ThumbnailID] [uniqueidentifier] NULL,
	[OwnerUserID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Locations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Locations](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[lft] [int] NULL,
	[rgt] [int] NULL,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Regions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Regions](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ParentID] [uniqueidentifier] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReviewLocationCache]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReviewLocationCache](
	[ReviewID] [varchar](50) NOT NULL,
	[LocationID] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Roles](
	[Username] [varchar](20) NOT NULL,
	[Role] [varchar](20) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersPreferredStyles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersPreferredStyles](
	[UserID] [uniqueidentifier] NOT NULL,
	[StyleID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UsersPreferredStyles] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[StyleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Acts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Acts](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [char](50) NOT NULL,
	[GigID] [uniqueidentifier] NOT NULL,
	[ArtistID] [uniqueidentifier] NULL,
	[StageTime] [datetime] NULL,
	[SetLength] [char](100) NULL,
	[Thumbnail] [varchar](50) NULL,
 CONSTRAINT [PK_Acts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Comments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Comments](
	[ID] [uniqueidentifier] NOT NULL,
	[Body] [text] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[TargetListenToType] [varchar](10) NULL,
	[TargetListenToTypeID] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Artists]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Artists](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[StyleID] [uniqueidentifier] NOT NULL,
	[LocationID] [uniqueidentifier] NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[Profile] [varchar](3000) NULL,
	[Created] [datetime] NOT NULL,
	[Formed] [datetime] NULL,
	[LogoImageID] [uniqueidentifier] NULL,
	[OfficalWebsiteURL] [varchar](200) NULL,
	[EmailAddress] [varchar](200) NULL,
	[ProfileAddress] [varchar](50) NULL,
	[TownID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Artists] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Towns]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Towns](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Towns_ID]  DEFAULT (newid()),
	[Name] [varchar](50) NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Towns] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sites]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Sites](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Sites_ID]  DEFAULT (newid()),
	[Name] [varchar](50) NOT NULL,
	[URL] [varchar](50) NOT NULL,
	[LocationID] [uniqueidentifier] NULL,
	[Description] [varchar](200) NULL,
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
	[Created] [datetime] NULL,
 CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Venues]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Venues](
	[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Venues_ID]  DEFAULT (newid()),
	[LocationID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [text] NULL,
	[Capacity] [int] NULL,
	[Website] [varchar](50) NULL,
	[Telephone] [varchar](50) NULL,
	[Address] [varchar](200) NULL,
	[ImageID] [uniqueidentifier] NULL,
	[UserID] [uniqueidentifier] NULL,
	[Created] [datetime] NULL,
	[TownID] [uniqueidentifier] NULL,
	[IsDeleted] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddStyle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddStyle]
(
@ID uniqueidentifier,
@Name varchar(50),
@Description  varchar(200)

)

as

insert into Styles
(ID,Name,Description) values (@ID,@Name,@Description)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateStyle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateStyle]
(
@ID uniqueidentifier,
@Name varchar(50),
@Description  varchar(200)

)

as

update  Styles set 
Name = @Name,Description=@Description
where ID =  @ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserClassified]
(
	@ID uniqueidentifier
)
AS

SELECT    

dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.IsPublished,
dbo.Classifieds.IsSuspended,
dbo.Classifieds.FirstPublished, 
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID, 
dbo.UserClassifieds.InstrumentID,
dbo.Classifieds.ImageID


FROM         

dbo.UserClassifieds INNER JOIN  dbo.Classifieds ON dbo.UserClassifieds.ClassifiedID = dbo.Classifieds.ID
	
WHERE dbo.Classifieds.ID=@ID

--GRAB TOWN DATA

SELECT     

dbo.Towns.ID, 
dbo.Towns.CountryId, 
dbo.Towns.Name, 

dbo.Towns.Created

FROM         dbo.Towns INNER JOIN
                      dbo.ClassifiedsTowns ON dbo.Towns.ID = dbo.ClassifiedsTowns.TownID

WHERE

 dbo.ClassifiedsTowns.ClassifiedID = @ID

--GRAB STYLE DATA

SELECT     

dbo.Styles.ID, 
dbo.Styles.Name, 
dbo.Styles.Description


FROM         dbo.Styles INNER JOIN
                      dbo.ClassifiedsStyles ON dbo.Styles.ID = dbo.ClassifiedsStyles.StyleID

WHERE

 dbo.ClassifiedsStyles.ClassifiedID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserIdentity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*this Stored Proc will expect a miniumum of a username or a useridentity*/

CREATE PROCEDURE [dbo].[GetUserIdentity]
(
@UserIdentityID uniqueidentifier,
@Username varchar(50),
@Password varchar(50),
@EmailAddress varchar(50)
)
As 


if @UserIdentityID =null and  @Username=null and @Password=null and @EmailAddress=null

begin


return 
end 

DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)

SET @ParamDef =''@UserIdentityID as uniqueidentifier, @Username as varchar(50), @Password as varchar(50), @EmailAddress as varchar(50) ''


SET @NStatements=0
SET @SqlString =''''
SET @SqlString = @SqlString + 

''
SELECT ID, Username, Password, Forename, Surname, Profile, EmailAddress, TownID, AlternativeLocation, AvatarImageID,Created, IsUserValidated, RecievesNewsletter
From Users where ''
/*
if @UserIdentityID <> null or @Username<> null or @Password <> null
begin
  set @SqlString = @SqlString + '' where ''
end
*/


/* FILTER BY ID  */

if @UserIdentityID <> null

begin

SET @SqlString = @SqlString + '' ID = @UserIdentityID ''
SET @NStatements=1
end



/*USERNAME SEARCH*/


if @Username <> null

begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Username = @Username ''
SET @NStatements=1
end


if @EmailAddress <> null

begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' EmailAddress = @EmailAddress ''
SET @NStatements=1
end


/*PASSWORD SEARCH*/


if @Password <> null

begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Password = @Password ''
end


print @SqlString


Exec  sp_executesql 
@SqlString, 
@ParamDef,
@UserIdentityID =@UserIdentityID, @Username = @Username,@Password=@Password, @EmailAddress=@EmailAddress



if @UserIdentityID <> null

	Begin
		SELECT     dbo.Styles.ID, dbo.Styles.Name, dbo.Styles.Description
		FROM         dbo.Styles INNER JOIN
		                      dbo.UsersPreferredStyles ON dbo.Styles.ID = dbo.UsersPreferredStyles.StyleID where dbo.UsersPreferredStyles.UserID = @UserIdentityID
		
		return
	end

else

	begin
	
		if @Username <> null
			
			begin
			
				
				SELECT     dbo.Styles.ID, dbo.Styles.Name, dbo.Styles.Description
				FROM         dbo.Styles INNER JOIN
				                      dbo.UsersPreferredStyles ON dbo.Styles.ID = dbo.UsersPreferredStyles.StyleID INNER JOIN
				                      dbo.Users ON dbo.UsersPreferredStyles.UserID = dbo.Users.ID
				
				
				where dbo.Users.Username = @Username
				
				return
			
			end

		if @EmailAddress <> null
			
			begin
			
				
				SELECT     dbo.Styles.ID, dbo.Styles.Name, dbo.Styles.Description
				FROM         dbo.Styles INNER JOIN
				                      dbo.UsersPreferredStyles ON dbo.Styles.ID = dbo.UsersPreferredStyles.StyleID INNER JOIN
				                      dbo.Users ON dbo.UsersPreferredStyles.UserID = dbo.Users.ID
				
				
				where dbo.Users.EmailAddress = @EmailAddress
				
				return
			
			end




	end' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStyle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetStyle]
(
@ID uniqueidentifier
)

as

SELECT     dbo.Styles.ID, dbo.Styles.Name, dbo.Styles.Description
FROM         dbo.Styles
WHERE   dbo.Styles.ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStyleList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetStyleList]

as

SELECT     dbo.Styles.ID, dbo.Styles.Name, dbo.Styles.Description
FROM         dbo.Styles order by Name
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[addUsersPreferredStyles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[addUsersPreferredStyles]
(
@UserID uniqueidentifier,
@StyleID uniqueidentifier


)

as

insert into dbo.UsersPreferredStyles

(UserID,StyleID) 

values 

(@UserID,@StyleID)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deleteUsersPreferredStyles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[deleteUsersPreferredStyles]
(
@UserID uniqueidentifier


)

as

delete  from dbo.UsersPreferredStyles

where UserID=@UserID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddVenue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[AddVenue]
(
@ID uniqueidentifier,
@Name varchar(50),
@Description text,
@TownID uniqueidentifier,
@Address varchar(200),
@Telephone varchar(50),
@Website varchar(50),
@Capacity int,
@ImageID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Created datetime						
)
as

insert into Venues
(
ID,
Name,
Description,
Address, 
Telephone,
Website,
Capacity,
ImageID,
UserID,
TownID,
Created
) 

values 

(
@ID,
@Name,
@Description,
@Address, 
@Telephone,
@Website,
@Capacity,
@ImageID,
@OwnerUserID,
@TownID,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVenue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetVenue]
(
@ID uniqueidentifier
)

as


SELECT     dbo.Venues.ID, dbo.Venues.Name, dbo.Venues.Description,  dbo.Venues.TownID, dbo.Venues.Address, dbo.Venues.Telephone, dbo.Venues.WebSite,  dbo.Venues.Capacity, dbo.Venues.ImageID , dbo.Venues.UserID as OwnerUserID, dbo.Venues.Created
FROM        
                      dbo.Venues
WHERE   dbo.Venues.ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateVenue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[UpdateVenue]
(
@ID uniqueidentifier,
@Name varchar(50),
@Description text,
@TownID uniqueidentifier,
@Address varchar(200),
@Telephone varchar(50),
@Website varchar(50),
@Capacity int,
@ImageID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Created datetime						
)
as

update   Venues

set


ID = @ID,
Name =@Name,
Description = @Description,
Address =@Address, 
Telephone =@Telephone,
Website = @Website,
Capacity = @Capacity,
ImageID=@ImageID,
UserID=@OwnerUserID,
TownID=@TownID,
Created=@Created


where ID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_GigReviewsDetailed]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_GigReviewsDetailed]
AS
SELECT     dbo.Reviews.ID, dbo.Reviews.UserID, dbo.Reviews.Name, dbo.Reviews.Description, dbo.Reviews.PublishDate, dbo.Reviews.ExpiryDate, 
                      dbo.Reviews.ImageID, dbo.Reviews.SubjectListenToTypeID, dbo.Reviews.SubjectListenToType, Images_1.filename, dbo.Reviews.IsSuspended, 
                      dbo.Reviews.IsPublished, dbo.Acts.Name AS ArtistName, dbo.Acts.ArtistID, dbo.Venues.ID AS VenueID, dbo.Venues.Name AS VenueName, 
                      dbo.Ratings.Score, dbo.Users.Username, dbo.Venues.TownID
FROM         dbo.Gigs INNER JOIN
                      dbo.Reviews ON dbo.Gigs.ID = dbo.Reviews.SubjectListenToTypeID INNER JOIN
                      dbo.Venues ON dbo.Gigs.VenueID = dbo.Venues.ID INNER JOIN
                      dbo.Acts ON dbo.Gigs.ID = dbo.Acts.GigID INNER JOIN
                      dbo.Ratings ON dbo.Reviews.RatingID = dbo.Ratings.ID INNER JOIN
                      dbo.Users ON dbo.Reviews.UserID = dbo.Users.ID LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Reviews.ImageID = Images_2.ID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_VenueReviews]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_VenueReviews]
AS
SELECT     dbo.Reviews.ID, dbo.Reviews.UserID, dbo.Reviews.Name, dbo.Reviews.Description, dbo.Reviews.PublishDate, dbo.Reviews.ExpiryDate, 
                      dbo.Reviews.ImageID, dbo.Reviews.SubjectListenToTypeID, dbo.Reviews.SubjectListenToType, dbo.Users.Username, Images_1.filename, 
                      dbo.Reviews.IsPublished, dbo.Reviews.IsSuspended, dbo.Ratings.Score, dbo.Venues.TownID
FROM         dbo.Ratings INNER JOIN
                      dbo.Reviews INNER JOIN
                      dbo.Venues ON dbo.Reviews.SubjectListenToTypeID = dbo.Venues.ID INNER JOIN
                      dbo.Users ON dbo.Reviews.UserID = dbo.Users.ID ON dbo.Ratings.ID = dbo.Reviews.RatingID LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Reviews.ImageID = Images_2.ID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_GigReviews]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_GigReviews]
AS
SELECT     dbo.Reviews.ID, dbo.Reviews.UserID, dbo.Reviews.Name, dbo.Reviews.Description, dbo.Reviews.PublishDate, dbo.Reviews.ExpiryDate, 
                      dbo.Reviews.SubjectListenToTypeID, dbo.Reviews.SubjectListenToType, dbo.Users.Username, Images_1.filename, dbo.Reviews.IsSuspended, 
                      dbo.Reviews.IsPublished, dbo.Ratings.Score, dbo.Reviews.ImageID, dbo.Venues.TownID
FROM         dbo.Users INNER JOIN
                      dbo.Gigs INNER JOIN
                      dbo.Reviews ON dbo.Gigs.ID = dbo.Reviews.SubjectListenToTypeID INNER JOIN
                      dbo.Venues ON dbo.Gigs.VenueID = dbo.Venues.ID INNER JOIN
                      dbo.Ratings ON dbo.Reviews.RatingID = dbo.Ratings.ID ON dbo.Users.ID = dbo.Reviews.UserID LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Reviews.ImageID = Images_2.ID
' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateGig]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateGig]
(
@ID uniqueidentifier,
@Name varchar(50),
@Date DateTime,
@Description varchar(1000),
@VenueID uniqueidentifier,
@TicketPrice varchar(50),
@UserID uniqueidentifier,
@ImageID uniqueidentifier,
@Created DateTime
)

as

update Gigs

set

Name=@Name,
Date=@Date,
description=@Description,
VenueID=@VenueID,
TicketPrice =@TicketPrice,
UserID=@UserID,
ImageID=@ImageID,
Created=@Created

where ID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateArticle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateArticle]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(50),
@Description varchar(200),
@Body text,
@Created DateTime,
@PublishDate DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit



)

as

Update  Article

set

UserID =@OwnerUserID,
Name = @Name,
Description =@Description,
Body=@Body,
PublishDate=@PublishDate,
ImageID=@ImageID,
IsPublished = @IsPublished,
IsSuspended = @IsSuspended
where

ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddArticle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddArticle]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(50),
@Description varchar(200),
@Body text,
@Created DateTime,
@PublishDate DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit

)

as

insert into Article
(
ID,
UserID,
Name,
Description,
Body,
Created,
PublishDate,
ImageID,
IsPublished,
IsSuspended
)

values 
(

@ID,
@OwnerUserID,
@Name,
@Description,
@Body,
@Created,
@PublishDate,
@ImageID,
@IsPublished,
@IsSuspended
)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_BandClassifieds]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_BandClassifieds]
AS
SELECT     dbo.Classifieds.ID, dbo.Classifieds.Title, dbo.Classifieds.Body, dbo.Classifieds.Type AS ListenToClassifiedType, dbo.Classifieds.IsActive, 
                      dbo.Classifieds.OwnerUserID, dbo.BandClassifieds.ArtistID AS SourceID, dbo.BandClassifieds.ArtistName AS SourceName, 
                      dbo.Images.filename AS SourceImageFilename, dbo.Classifieds.Created, dbo.Classifieds.FirstPublished, dbo.Classifieds.IsPublished, 
                      dbo.Classifieds.IsSuspended, dbo.ClassifiedsTowns.TownID, dbo.BandClassifieds.InstrumentID, dbo.BandClassifieds.StyleID
FROM         dbo.Images RIGHT OUTER JOIN
                      dbo.Classifieds INNER JOIN
                      dbo.ClassifiedsTowns ON dbo.Classifieds.ID = dbo.ClassifiedsTowns.ClassifiedID ON dbo.Images.ID = dbo.Classifieds.ImageID LEFT OUTER JOIN
                      dbo.BandClassifieds RIGHT OUTER JOIN
                      dbo.Artists ON dbo.BandClassifieds.ArtistID = dbo.Artists.ID ON dbo.Classifieds.ID = dbo.BandClassifieds.ClassifiedID
WHERE     (dbo.Classifieds.Type = ''MusicianWanted'')

' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateBandClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateBandClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier,

	-- Band Data

	@ArtistID uniqueidentifier,
	@ArtistName varchar(50),
	@StyleID uniqueidentifier,
	@InstrumentID uniqueidentifier
	
	
)
AS

-- Add the Classifieds info

update  dbo.Classifieds


set 

dbo.Classifieds.Title = @Title,
dbo.Classifieds.Body = @Body,
dbo.Classifieds.IsActive = @IsActive,
dbo.Classifieds.Type = @Type,
dbo.Classifieds.OwnerUserID = @OwnerUserID,
dbo.Classifieds.ImageID = @ImageID,
dbo.Classifieds.FirstPublished =	@FirstPublished ,
dbo.Classifieds.IsPublished = @IsPublished,
dbo.Classifieds.IsSuspended = @IsSuspended 

where 

dbo.Classifieds.ID = @ID

--Add the BandClassifieds info

update  dbo.BandClassifieds

set 

ArtistID = @ArtistID,
ArtistName = @ArtistName,
StyleID = @StyleID,
InstrumentID = @InstrumentID

where ClassifiedID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddBandClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddBandClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier,

	-- Band Data

	@ArtistID uniqueidentifier,
	@ArtistName varchar(50),
	@StyleID uniqueidentifier,
	@InstrumentID uniqueidentifier
	
	
)
AS

-- Add the Classifieds info

Insert into dbo.Classifieds

(
dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID,
dbo.Classifieds.FirstPublished, 
dbo.Classifieds.IsPublished, 
dbo.Classifieds.IsSuspended,
dbo.Classifieds.ImageID
)

Values

(
@ID, 
@Title, 
@Body, 
@Created, 
@IsActive, 
@Type, 
@OwnerUserID,
@FirstPublished,
@IsPublished,
@IsSuspended,
@ImageID


)


--Add the BandClassifieds info


Insert  into dbo.BandClassifieds


(
ClassifiedID,
ArtistID,
ArtistName,
StyleID,
InstrumentID
)


Values
(
@ID,
@ArtistID, 
@ArtistName,
@StyleID, 
@InstrumentID 
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBandClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetBandClassified]
(
	@ID uniqueidentifier
)
AS

SELECT    

dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.IsPublished, 
dbo.Classifieds.IsSuspended,
dbo.Classifieds.FirstPublished,  
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID, 
dbo.Classifieds.ImageID, 
dbo.BandClassifieds.InstrumentID, 
dbo.BandClassifieds.StyleID, 
dbo.BandClassifieds.ArtistID, 
dbo.BandClassifieds.ArtistName 

FROM         

dbo.BandClassifieds INNER JOIN  dbo.Classifieds ON dbo.BandClassifieds.ClassifiedID = dbo.Classifieds.ID
	
WHERE dbo.Classifieds.ID=@ID

--GRAB TOWN DATA


SELECT     

dbo.Towns.ID, 
dbo.Towns.CountryId, 
dbo.Towns.Name, 

dbo.Towns.Created

FROM         dbo.Towns INNER JOIN
                      dbo.ClassifiedsTowns ON dbo.Towns.ID = dbo.ClassifiedsTowns.TownID

WHERE

 dbo.ClassifiedsTowns.ClassifiedID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddClassifiedsStyles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddClassifiedsStyles]
(
@ClassifiedID uniqueidentifier,
@StyleID uniqueidentifier
)

as

insert into dbo.ClassifiedsStyles
(
ClassifiedID,
StyleID
) 

values 

(
@ClassifiedID,
@StyleID
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteClassifiedsStyles]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteClassifiedsStyles]
(
@ClassifiedID uniqueidentifier


)

as

delete  from dbo.ClassifiedsStyles

where ClassifiedID=@ClassifiedID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_UserClassifieds]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_UserClassifieds]
AS
SELECT     dbo.Classifieds.ID, dbo.Classifieds.Title, dbo.Classifieds.Body, dbo.Classifieds.Type AS ListenToClassifiedType, dbo.Classifieds.IsActive, 
                      dbo.Classifieds.OwnerUserID, dbo.Users.ID AS SourceID, dbo.Users.Username AS SourceName, Images_1.filename AS SourceImageFilename, 
                      dbo.Classifieds.Created, dbo.Classifieds.FirstPublished, dbo.Classifieds.IsPublished, dbo.Classifieds.IsSuspended, dbo.ClassifiedsTowns.TownID, 
                      dbo.UserClassifieds.InstrumentID, dbo.ClassifiedsStyles.StyleID
FROM         dbo.ClassifiedsTowns RIGHT OUTER JOIN
                      dbo.Classifieds LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Classifieds.ImageID = Images_2.ID LEFT OUTER JOIN
                      dbo.Users ON dbo.Classifieds.OwnerUserID = dbo.Users.ID LEFT OUTER JOIN
                      dbo.ClassifiedsStyles ON dbo.Classifieds.ID = dbo.ClassifiedsStyles.ClassifiedID LEFT OUTER JOIN
                      dbo.UserClassifieds ON dbo.Classifieds.ID = dbo.UserClassifieds.ClassifiedID ON dbo.ClassifiedsTowns.ClassifiedID = dbo.Classifieds.ID
WHERE     (dbo.Classifieds.Type = ''MusicianAvailable'')

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_GeneralClassifieds]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_GeneralClassifieds]
AS
SELECT     dbo.Classifieds.ID, dbo.Classifieds.Title, dbo.Classifieds.Body, dbo.Classifieds.Type AS ListenToClassifiedType, dbo.Classifieds.IsActive, 
                      dbo.Classifieds.OwnerUserID, dbo.Users.ID AS SourceID, dbo.Users.Username AS SourceName, Images_1.filename AS SourceImageFilename, 
                      dbo.Classifieds.Created, dbo.Classifieds.FirstPublished, dbo.Classifieds.IsPublished, dbo.Classifieds.IsSuspended, dbo.ClassifiedsTowns.TownID, 
                      dbo.UserClassifieds.InstrumentID
FROM         dbo.ClassifiedsTowns RIGHT OUTER JOIN
                      dbo.Classifieds LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Classifieds.ImageID = Images_2.ID LEFT OUTER JOIN
                      dbo.Users ON dbo.Classifieds.OwnerUserID = dbo.Users.ID LEFT OUTER JOIN
                      dbo.UserClassifieds ON dbo.Classifieds.ID = dbo.UserClassifieds.ClassifiedID ON dbo.ClassifiedsTowns.ClassifiedID = dbo.Classifieds.ID
WHERE     (dbo.Classifieds.Type = ''General'')

' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGeneralClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetGeneralClassified]
(
	@ID uniqueidentifier
)
AS

SELECT    

dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.IsPublished,
dbo.Classifieds.IsSuspended,
dbo.Classifieds.FirstPublished, 
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID, 
dbo.Classifieds.ImageID


FROM         

dbo.Classifieds
	
WHERE dbo.Classifieds.ID=@ID

--GRAB TOWN DATA

SELECT     

dbo.Towns.ID, 
dbo.Towns.CountryId, 
dbo.Towns.Name, 

dbo.Towns.Created

FROM         dbo.Towns INNER JOIN
                      dbo.ClassifiedsTowns ON dbo.Towns.ID = dbo.ClassifiedsTowns.TownID

WHERE

 dbo.ClassifiedsTowns.ClassifiedID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddClassifiedsTowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddClassifiedsTowns]
(
@ClassifiedID uniqueidentifier,
@TownID uniqueidentifier
)

as

insert into dbo.ClassifiedsTowns

(
ClassifiedID,
TownID
) 

values 

(
@ClassifiedID,
@TownID
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteClassifiedsTowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeleteClassifiedsTowns]
(
@ClassifiedID uniqueidentifier


)

as

delete  from dbo.ClassifiedsTowns

where ClassifiedID=@ClassifiedID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInstrument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInstrument]
(
	@ID uniqueidentifier

)
As 


	SELECT ID,name,performer,  Created
	FROM Instruments  where ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddInstrument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddInstrument]
(
@ID uniqueidentifier,
@Name VarChar(50),
@Performer VarChar(50),
@Created datetime
)
AS




	insert into Instruments ( id, Name,Performer,created) values (@ID,@Name,@Performer,@Created)

	RETURN' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateInstrument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateInstrument]
(
@ID uniqueidentifier,
@Name varchar(50),
@Performer varchar(50)




)

as

Update  Instruments set

Name = @Name,
Performer = @Performer


where ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateUserClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateUserClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier,

	-- User Data

	@InstrumentID uniqueidentifier
	
	
)
AS





-- Add the Classifieds info

update  dbo.Classifieds


set 

dbo.Classifieds.Title = @Title,
dbo.Classifieds.Body = @Body,
dbo.Classifieds.IsActive = @IsActive,
dbo.Classifieds.Type = @Type,
dbo.Classifieds.OwnerUserID = @OwnerUserID,

dbo.Classifieds.FirstPublished =	@FirstPublished ,
dbo.Classifieds.IsPublished = @IsPublished,
dbo.Classifieds.IsSuspended = @IsSuspended,
dbo.Classifieds.ImageID = @ImageID

where 

dbo.Classifieds.ID = @ID

--Update the UserClassifieds info

update  dbo.UserClassifieds

set 

InstrumentID = @InstrumentID

where ClassifiedID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddUserClassified]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddUserClassified]
(

	-- Classifieds Data

	@ID uniqueidentifier,
	@Title varchar(50),
	@Body varchar(3000),
	@Created datetime,
	@IsActive bit,
	@Type varchar(50),
	@OwnerUserID uniqueidentifier,
	@FirstPublished DateTime,
	@IsPublished bit,
	@IsSuspended bit,
	@ImageID uniqueidentifier,

	-- User Data

	@InstrumentID uniqueidentifier
	
	
)
AS

-- Add the Classifieds info

Insert into dbo.Classifieds

(
dbo.Classifieds.ID, 
dbo.Classifieds.Title, 
dbo.Classifieds.Body, 
dbo.Classifieds.Created, 
dbo.Classifieds.IsActive, 
dbo.Classifieds.Type, 
dbo.Classifieds.OwnerUserID,
dbo.Classifieds.FirstPublished,
dbo.Classifieds.IsPublished,
dbo.Classifieds.IsSuspended,
dbo.Classifieds.ImageID
)

Values

(
@ID, 
@Title, 
@Body, 
@Created, 
@IsActive, 
@Type, 
@OwnerUserID,
@FirstPublished,
@IsPublished,
@IsSuspended,
@ImageID
)




--Add the BandClassifieds info


Insert  into dbo.UserClassifieds
(
ClassifiedID,
InstrumentID
)


Values
(
@ID,
@InstrumentID 
)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_generateansiname]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
create procedure [dbo].[dt_generateansiname](@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = ''MSDT-A-'' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = ''DIAGRAM'' 
	goto Leave 
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_adduserobject]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Add an object to the dtproperties table
*/
create procedure [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES (''DtgSchemaOBJECT'')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property=''DtgSchemaOBJECT''
	commit
	return @@identity
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getpropertiesbyid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Retrieve properties by id''s
**
**	dt_getproperties objid, null or '''' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
create procedure [dbo].[dt_getpropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '''')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_setpropertybyid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
create procedure [dbo].[dt_setpropertybyid]
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getobjwithprop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Retrieve the owner object(s) of a given property
*/
create procedure [dbo].[dt_getobjwithprop]
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '''')
	begin
		raiserror(''Must specify a property name.'',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_dropuserobjectbyid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Drop an object from the dbo.dtproperties table
*/
create procedure [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getobjwithprop_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Retrieve the owner object(s) of a given property
*/
create procedure [dbo].[dt_getobjwithprop_u]
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '''')
	begin
		raiserror(''Must specify a property name.'',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getpropertiesbyid_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Retrieve properties by id''s
**
**	dt_getproperties objid, null or '''' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
create procedure [dbo].[dt_getpropertiesbyid_u]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '''')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getpropertiesbyid_vcs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[dt_getpropertiesbyid_vcs]
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_droppropertiesbyid]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '''' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
create procedure [dbo].[dt_droppropertiesbyid]
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '''')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_adduserobject_vcs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[dt_adduserobject_vcs]
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** Create the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn


' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateMessage]
(
@ID uniqueidentifier,
@Subject VarChar(50),
@Body text,
@IsRead bit,
@ParentMessageID uniqueidentifier,
@ClassifiedId uniqueidentifier,
@FromUserId uniqueidentifier,
@ToUserId uniqueidentifier,
@OwnerUserID  uniqueidentifier
)
AS




UPDATE  Messages set  

Subject = @Subject, 
Body=@Body, 
IsRead = @IsRead, 
ParentMessageID=@ParentMessageID, 
ClassifiedId=@ClassifiedId, 
FromUserId=@FromUserId,
ToUserId=@ToUserId, 
OwnerUserID=@OwnerUserID 

WHERE

ID = @ID

	RETURN' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddMessage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddMessage]
(
@ID uniqueidentifier,
@Subject VarChar(50),
@Body text,
@ToUserId uniqueidentifier,
@FromUserId uniqueidentifier,
@OwnerUserId uniqueidentifier,
@ClassifiedId uniqueidentifier,
@ParentMessageID uniqueidentifier,
@IsRead bit,
@Created datetime
)
AS




	insert into Messages ( id, Subject, Body,  ToUserID, FromUserID, OwnerUserID, ClassifiedID, ParentMessageID, IsRead, Created) values (@ID,@Subject,@Body,@ToUserId,@FromUserId,@OwnerUserId,@ClassifiedId, @ParentMessageID, @IsRead, @Created)

	RETURN' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPodcast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPodcast]

@ID uniqueidentifier





as

SELECT id,Title,Description, FirstPublished, IsPublished, IsSuspended,created, userID as owneruserID
FROM  Podcast
WHERE ID =  @ID


	SELECT id, IP, UserID as OwnerUserID ,TrackID,Created
	FROM plays
	WHERE TrackID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_AssertionTotalOpinions]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_AssertionTotalOpinions]
AS
SELECT     AssertionID, COUNT(Created) AS TotalOpinions
FROM         dbo.Opinions
GROUP BY AssertionID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_OpinionsView]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_OpinionsView]
AS
SELECT     dbo.Users.Username AS OwnerUsername, dbo.Opinions.OwnerUserID, dbo.Opinions.Created, dbo.Assertions.Name AS AssertionName, 
                      dbo.Opinions.AssertionID, dbo.Opinions.ID, dbo.Opinions.Body
FROM         dbo.Opinions INNER JOIN
                      dbo.Users ON dbo.Opinions.OwnerUserID = dbo.Users.ID INNER JOIN
                      dbo.Assertions ON dbo.Opinions.AssertionID = dbo.Assertions.ID
' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[GetAssertion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [transparent].[GetAssertion]
(
		@ID uniqueidentifier
)
AS
	SELECT ID,OwnerUserID,name,description,body,Created,FirstPublished,  ImageID, IsPublished, IsSuspended,IsActive
	FROM Assertions 
	WHERE ID=@ID



/*Grab Site Data*/

SELECT    

dbo.Sites.ID,  
dbo.Sites.LocationID, 
dbo.Sites.URL, 
dbo.Sites.Name, 
dbo.Sites.Description
FROM        
dbo.Sites

CROSS JOIN
                      
dbo.AssertionTargetSites

Where   

dbo.AssertionTargetSites.AssertionID=@ID



select  

ID,
Body,
OwnerUserID,
AssertionID,
Created

from Opinions

where AssertionID =@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddOpinion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddOpinion]
(
@ID uniqueidentifier,
@Body as text,
@OwnerUserID uniqueidentifier,
@AssertionID uniqueidentifier,
@Created datetime

)

as

insert into Opinions
(
ID,
Body,
OwnerUserID,
AssertionID,
Created
)

values 
(

@ID,
@Body,
@OwnerUserID,
@AssertionID,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateOpinion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateOpinion]
(
@ID uniqueidentifier,
@Body as text,
@OwnerUserID uniqueidentifier,
@AssertionID uniqueidentifier,
@Created datetime

)

as

update Opinions

set

Body = @Body,
OwnerUserID = @OwnerUserID,
AssertionID = @AssertionID,
Created =@Created


where ID = @ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deleteAssertionTargetSites]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[deleteAssertionTargetSites]
(
@AssertionID uniqueidentifier


)

as

delete  from dbo.AssertionTargetSites

where AssertionID=@AssertionID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddAssertionTargetSites]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddAssertionTargetSites]
(
@AssertionID uniqueidentifier,
@SiteID uniqueidentifier
)

as

insert into dbo.AssertionTargetSites

(
AssertionID,
SiteID
) 

values 

(
@AssertionID,
@SiteID
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChartsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[GetChartsView]
@FirstRecord int,
@LastRecord int,
@FromDate as DateTime,
@StyleID as uniqueidentifier,
@TownIDs as varchar(500),
@OrderByLatest as bit



as


DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)
DECLARE @EndDate datetime

SET @ParamDef =''@StyleID as uniqueidentifier, @TownIDs as varchar(500) ''
SET @NStatements=0

/*******************************************************************************************************/
/*  BUILD AND POPULATE  CHART SCORES TABLE                                                    */
/*******************************************************************************************************/

set @EndDate =  DATEADD(m,-1,@FromDate)
CREATE TABLE #Chart
(
TrackID uniqueidentifier,
TotalScore int,
NumRatings int
)

CREATE TABLE #TChart1
(
TrackID uniqueidentifier,
TotalRatings int,
NumRatings int
)

CREATE TABLE #TChart2
(
TrackID uniqueidentifier,
PlaysThisMonth int

)

/******************************/
/* SUMMING MODEL     */
/******************************/

/*THIS  ACCOUNTS FOR POSITIVE AND NEGATIVE OPINION - BUT A TRACK 
THAT MOST PEOPLE THINK IS SHIT COULD REACH THE TOP OF THE CHARTS!
*/

/*
INSERT INTO #Chart(TrackID, TotalScore,NumRatings)

SELECT    SubjectListenToTypeID AS TrackID,  Sum(Score) AS TotalScore, COUNT(Score) AS NumRatings
FROM         dbo.Ratings
where created between  @EndDate and @FromDate
GROUP BY SubjectListenToTypeID 
*/

/******************************/
/* THUMBS UP MODEL*/
/******************************/

/*IF A TRACK SCORES MORE THAN  3 IT IS CONSIDERED A THUMBS UP AND EFFECTS THE CHART*/

/* THIS APPROACH DOESN''T ACCOUNT FOR NEGATIVE OPINION*/

/*
INSERT INTO #Chart(TrackID, TotalScore,NumRatings)

SELECT    SubjectListenToTypeID AS TrackID,  Count(Score) AS TotalScore, COUNT(Score) AS NumRatings
FROM         dbo.Ratings
where created between  @EndDate and @FromDate and Score >=3
GROUP BY SubjectListenToTypeID 

*/

/***************************************/
/* THUMBS UP/DOWN MODEL*/
/***************************************/

/*
INSERT INTO #Chart(TrackID, TotalScore,NumRatings)

SELECT    SubjectListenToTypeID AS TrackID,  Sum(Score)   AS TotalScore, COUNT(Score) AS NumRatings
FROM         vw_ChartsThumbsUp
where created between  @EndDate and @FromDate 
GROUP BY SubjectListenToTypeID 

INSERT INTO #Chart(TrackID, TotalScore,NumRatings)
*/


--GET THE RATINGS

INSERT INTO #TChart1(TrackID, TotalRatings, NumRatings)

SELECT 

dbo.vw_Chart_Ratings.SubjectListenToTypeID AS TrackID, 
dbo.vw_Chart_Ratings.TotalScore as TotalRatings,
dbo.vw_Chart_Ratings.NumRatings AS NumRatings

FROM    dbo.vw_Chart_Ratings


--GET THE NUMBER OF PLAYS IN THE LAST MONTH

INSERT INTO #TChart2(TrackID, PlaysThisMonth)

SELECT     
dbo.Plays.TrackID,
COUNT(dbo.Plays.IP) AS PlaysThisMonth
FROM     
dbo.Plays
WHERE     (dbo.Plays.created between  @EndDate and @FromDate )

Group by dbo.Plays.TrackID


INSERT INTO #Chart(TrackID, TotalScore, NumRatings)


SELECT    

dbo.Tracks.ID,
ISNULL(dbo.#TChart2.PlaysThisMonth, 0) + ISNULL(dbo.#TChart1.TotalRatings, 0),
dbo.#TChart1.NumRatings

FROM         dbo.Tracks INNER JOIN
                   dbo.#TChart1 ON dbo.Tracks.ID = dbo.#TChart1.TrackID LEFT OUTER JOIN
                     dbo.#TChart2  ON dbo.Tracks.ID = dbo.#TChart2.TrackID






/*
SELECT     TOP 100 PERCENT dbo.vw_Chart_Ratings.SubjectListenToTypeID AS TrackID, dbo.vw_Chart_Ratings.TotalScore + COUNT(dbo.Plays.IP) AS TotalScore, 
                      dbo.vw_Chart_Ratings.NumRatings AS NumRatings
FROM         dbo.vw_Chart_Ratings INNER JOIN
                      dbo.Plays ON dbo.vw_Chart_Ratings.SubjectListenToTypeID = dbo.Plays.TrackID
WHERE     (dbo.Plays.created between  @EndDate and @FromDate )
GROUP BY dbo.vw_Chart_Ratings.SubjectListenToTypeID, dbo.vw_Chart_Ratings.TotalScore, dbo.vw_Chart_Ratings.NumRatings
ORDER BY dbo.vw_Chart_Ratings.TotalScore DESC

*/
/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlString =  ''

SELECT      

dbo.#Chart.TrackID, 
dbo.vw_TrackTotalPlays.TotalPlays, 
dbo.#Chart.TotalScore ,  
dbo.#Chart.NumRatings, 
dbo.Tracks.StyleID, 
dbo.Tracks.ArtistID, 
dbo.Tracks.ArtistName, 
dbo.Tracks.Title AS TrackName, 
dbo.Styles.Name AS StyleName,
dbo.Artists.TownID, 
dbo.Artists.ProfileAddress as ArtistProfileAddress



FROM         dbo.#Chart INNER JOIN
                      dbo.vw_TrackTotalPlays ON dbo.#Chart.TrackID = dbo.vw_TrackTotalPlays.TrackID INNER JOIN
                      dbo.Tracks ON dbo.#Chart.TrackID = dbo.Tracks.ID INNER JOIN
                      dbo.Styles ON dbo.Tracks.StyleID = dbo.Styles.ID INNER JOIN
                      dbo.Artists ON dbo.Tracks.ArtistID = dbo.Artists.ID


where Tracks.IsPublished = 1



''




/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @StyleID <> null   or @TownIDs <> null 

	begin
		  set @SqlString = @SqlString + ''  AND  ''
	end


/*******************************************************************************************************/
/* STYLEID    SEARCH                                                                                                    */
/*******************************************************************************************************/

if @StyleID <> null

	begin

		/*if @NStatements <> 0
		
			begin
		
				SET @SqlString = @SqlString + '' and ''
			end
*/



		SET @SqlString = @SqlString  +  '' StyleID = @StyleID ''
		SET @NStatements=1
	end


/*******************************************************************************************************/
/* TOWNID  SEARCH                                                                                                    */
/*******************************************************************************************************/

if @TownIDs <> null

begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlString = @SqlString + '' and ''
			end

SELECT *
INTO #tblTowns
FROM fnSplitter(@TownIDs)

SET @SqlString = @SqlString + '' dbo.Artists.TownID in (select id from #tblTowns) ''
SET @NStatements=1
end



SET @SqlString = @SqlString + ''order by totalscore desc''



/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
TrackID uniqueidentifier,  
TotalPlays int, 
TotalScore int,  
NumRatings int, 
StyleID uniqueidentifier, 
ArtistID uniqueidentifier, 
ArtistName varchar(50), 
TrackName varchar(50), 
StyleName varchar(50),
TownID uniqueidentifier, 
ArtistProfileAddress varchar(50)





)



INSERT INTO #TempItems (TrackID, TotalPlays, TotalScore, NumRatings, StyleID, ArtistID, ArtistName, TrackName,  StyleName, TownID, ArtistProfileAddress)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
@StyleID =@StyleID,  @TownIDs =@TownIDs





/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 
			nId,
			TrackID ,  
			TotalPlays , 
			TotalScore ,  
			NumRatings , 
			StyleID , 
			ArtistID , 
			ArtistName , 
			TrackName , 
			StyleName ,
			TownID ,
			ArtistProfileAddress


		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 
			nId,
			TrackID ,  
			TotalPlays , 
			TotalScore ,  
			NumRatings , 
			StyleID , 
			ArtistID , 
			ArtistName , 
			TrackName , 
			StyleName ,
			TownID ,
			ArtistProfileAddress


		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetReviewsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a ReviewsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/


CREATE PROCEDURE [dbo].[GetReviewsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@PublishedBefore as datetime,
@PublishedAfter as datetime,
@TownIds as varchar(500),
@OwnerUserID as uniqueidentifier,
@PublicationStatus as varchar(10),
@SubjectListenToType as varchar(10),
@SubjectListenToTypeID as uniqueidentifier

as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''

DECLARE  @GigByArtistSQLString NVARCHAR(4000)
SET @GigByArtistSQLString =''  ''

DECLARE  @GigSQLString NVARCHAR(4000)
SET @GigSQLString =''  ''

DECLARE  @VenueSQLString NVARCHAR(4000)
SET @VenueSQLString =''  ''

DECLARE  @TrackSQLString NVARCHAR(4000)
SET @TrackSQLString =''  ''

DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@TownIds as varchar(500), @OwnerUserID as uniqueidentifier, @SubjectListenToTypeID  as uniqueidentifier, @PublishedBefore as datetime, @PublishedAfter as datetime ''


/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED 					    */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Username,
UserID, 
Name,
Description, 
PublishDate,
ExpiryDate, 
ImageID,
Filename, 
SubjectListenToTypeID, 
SubjectListenToType,
TownID,
IsSuspended,
IsPublished,
Score


FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @TownIds <> null  or @OwnerUserID <> null or @SubjectListenToTypeID <>  null or @PublicationStatus <> '''' or @PublishedBefore <> null or @PublishedAfter <> null
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @SubjectListenToTypeID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  SubjectListenToTypeID = @SubjectListenToTypeID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* LOCATION SEARCH                                                                                                    */
/*******************************************************************************************************/

if @TownIds <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblTownIds FROM fnSplitter(@TownIds)

		SET @SqlFilterString = @SqlFilterString  + ''TownID  in (select id from #tblTownIds) ''
		
		SET @NStatements=1
	end




/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  UserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and  ''

		end

		SET @SqlFilterString = @SqlFilterString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  PublishDate >  @PublishedAfter and  PublishDate <   @PublishedBefore ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @GigSQLString = @SqlSelectString + ''vw_GigReviews'' + @SqlFilterString
set @VenueSQLString =  @SqlSelectString + ''vw_VenueReviews'' + @SqlFilterString
set @TrackSQLString =  @SqlSelectString + ''vw_TrackReviews'' + @SqlFilterString

/*******************************************************************************************************/
/*  DETERMINE WHICH TYPES ARE REQUIRED                                                         */
/*******************************************************************************************************/


if @SubjectListenToType= ''All''

	begin

	/*ONLY GENERIC SEARCH IS PERFORMED HERE*/

	SET @SqlString  = @GigSQLString + ''  UNION '' +  @VenueSQLString   + ''  UNION '' +  @TrackSQLString 
	
	end



	if @SubjectListenToType= ''Gig''
	
	begin


	SET @SqlString  = @GigSQLString  
	end



	if @SubjectListenToType= ''Venue''

	begin
	SET @SqlString  = @VenueSQLString
	end


	if @SubjectListenToType= ''Track''

	begin
	SET @SqlString  = @TrackSQLString
	end




/*******************************************************************************************************/
/* ORDERING                                                                                             	  	    */
/*******************************************************************************************************/


if @OrderByLatest <> null

	begin

		SET @SqlString = @SqlString + '' order by  PublishDate desc, Name''

	end
else


	begin



		SET @SqlString = @SqlString + '' order by  Name''


	end







/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/


CREATE TABLE #TempItems
(
nID INT IDENTITY,
ID uniqueidentifier, 
Username  varchar(50),
UserID uniqueidentifier, 
Name varchar(50),
Description varchar(200), 
PublishDate datetime,
ExpiryDate datetime, 
ImageID uniqueidentifier,
Filename  varchar(200), 
SubjectListenToTypeID uniqueidentifier, 
SubjectListenToType  varchar(20), 
TownID uniqueidentifier,
IsSuspended bit,
IsPublished bit,
Score integer


)



INSERT INTO #TempItems (ID,Username, UserID, Name, Description, PublishDate, ExpiryDate, ImageID, Filename,SubjectListenToTypeID, SubjectListenToType, TownId ,IsSuspended, IsPublished, Score)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
 @TownIds = @TownIds,  @OwnerUserID =@OwnerUserID, @SubjectListenToTypeID = @SubjectListenToTypeID, @PublishedBefore= @PublishedBefore, @PublishedAfter=@PublishedAfter


/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/


if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		ExpiryDate, 
		ImageID,
		Filename, 
		SubjectListenToTypeID, 
		SubjectListenToType,
		TownID,
		IsSuspended,
		IsPublished ,
		Score 

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end



else
 
	begin

		SELECT 

		ID, 
		Username,
		UserID, 
		Name,
		Description, 
		PublishDate,
		ExpiryDate, 
		ImageID,
		Filename, 
		SubjectListenToTypeID, 
		SubjectListenToType,
		TownID,
		IsSuspended,
		IsPublished ,
		Score 

		FROM #TempItems

	end



/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/



Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGigsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[GetGigsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@TownIds as varchar(500),
@BeforeDate as DateTime,
@OnDate as DateTime,
@AfterDate as DateTime,
@VenueID as uniqueidentifier,
@ArtistID as uniqueidentifier,
@ActName as varchar(100)


as


DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@TownIds as varchar(500),
@BeforeDate as DateTime,
@OnDate as DateTime,
@AfterDate as DateTime,
@VenueID as uniqueidentifier,
@ActName as varchar(100),
@ArtistID as uniqueidentifier''


/* TOP n */
/*
if @Count <> null
begin
SET ROWCOUNT @Count 
end
*/

SET @NStatements=0
SET @SqlString =''''
SET @SqlString = @SqlString + 




''SELECT DISTINCT 
                      dbo.Gigs.ID, dbo.Gigs.Name, dbo.Venues.ID AS VenueID, dbo.Venues.Name AS VenueName, dbo.Gigs.Date, 
                      Images_1.filename AS ThumbnailFilename
FROM         dbo.Images Images_1 RIGHT OUTER JOIN
                      dbo.Images ON Images_1.ID = dbo.Images.ThumbnailID RIGHT OUTER JOIN
                      dbo.Venues INNER JOIN
                      dbo.Gigs ON dbo.Venues.ID = dbo.Gigs.VenueID INNER JOIN
                      dbo.Acts ON dbo.Gigs.ID = dbo.Acts.GigID ON dbo.Images.ID = dbo.Gigs.ImageID''


if @TownIds <> null or @BeforeDate <> null or @OnDate <> null   or @AfterDate <> null or @VenueID <> null or @ActName<> null or @ArtistID <> null
begin
  set @SqlString = @SqlString + '' where ''
end

/* LOCATION SEARCH */

if @TownIds <> null

begin

SELECT *
INTO #tblTowns
FROM fnSplitter(@TownIds)

SET @SqlString = @SqlString + ''TownID in (select id from #tblTowns) ''
SET @NStatements=1
end

/*DATE SEARCH */


if @BeforeDate <> null and @AfterDate <> null

begin

/*BETWEEN DATES*/

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''(Date  BETWEEN @AfterDate AND @BeforeDate) ''

SET @NStatements=1
end


/*BEFORE DATE */

if @BeforeDate <> null and @AfterDate = null

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Date  < = @BeforeDate ''


SET @NStatements=1
end

/*AFTER DATE */

if @BeforeDate = null and @AfterDate <> null

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' Date >= @AfterDate ''


SET @NStatements=1
end

/*ON DATE */

if @OnDate <> null 

begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''    DATEDIFF(Day, Date,  @OnDate)=0  ''

/*
SET @SqlString = @SqlString + '' Date = @OnDate ''
*/


SET @NStatements=1
end




/*VENUE SEARCH*/

if @VenueID <> null

begin


if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''((@VenueID is null) or (VenueID =  @VenueID))''
SET @NStatements=1
end	

/*NAME SEARCH*/

if @ActName <> null
begin

if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' ((@ActName is null) or (dbo.Acts.Name like  @ActName))''
SET @NStatements=1
end
print @SqlString



/*VENUE SEARCH*/

if @ArtistID <> null

begin


if @NStatements=1
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + ''  (dbo.Acts.ArtistID =  @ArtistID)''
SET @NStatements=1
end	



/*ORDER*/

if(@OrderByLatest=0)

begin

SET @SqlString = @SqlString + ''  order by dbo.Gigs.Name ''
end

else
begin
SET @SqlString = @SqlString + ''  order by dbo.Gigs.Date ''
end

/*
Exec  sp_executesql 
@SqlString, 
@ParamDef,
@LocationIDs =@LocationIDs,
@StartDate =@StartDate,
@EndDate =@EndDate,
@VenueID = @VenueID,
@ActName = @ActName,
@ArtistID=@ArtistID
*/









/*PLACE IN TEMP TABLE*/









--Create a temporary table
CREATE TABLE #TempItems
(
	nID INT IDENTITY,
	ID uniqueidentifier,
	Name varchar(50),

	VenueID uniqueidentifier,
	VenueName varchar(50),
	Date datetime,
	ThumbFilename varchar(50)

)


-- Insert
INSERT INTO #TempItems (ID,NAME,VenueID,VenueName,Date,ThumbFilename)

        
Exec  sp_executesql 
@SqlString, 
@ParamDef,
@TownIds =@TownIds,
@BeforeDate =@BeforeDate,
@OnDate =@OnDate,
@AfterDate =@AfterDate,
@VenueID = @VenueID,
@ActName = @ActName,
@ArtistID=@ArtistID




/*PAGIN*/

if( @FirstRecord<>null)
begin


-- Now, return the set of paged records
SELECT 

	ID,
	Name,
	VenueID,
	VenueName,
	Date datetime,
	ThumbFilename

FROM #TempItems
WHERE nID >= @FirstRecord AND nID <= @LastRecord


/*Return total number of results*/

end



else 
begin

SELECT 

	ID,
	Name,
	VenueID,
	VenueName,
	Date datetime,
	ThumbFilename

FROM #TempItems


end

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetArtistList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetArtistList]

@TownIDs as varchar(2000),
@NameList as varchar(500),
@ProfileAddress as varchar(200),
@OwnerUserID as uniqueidentifier
as


DECLARE  @SQLString NVARCHAR(500)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @NStatements bit

SET @SqlString =''''
SET @SqlString = @SqlString + ''SELECT   dbo.Artists.ID, dbo.Artists.Name from  dbo.Artists''
SET @ParmDefinition =''@TownIDs as varchar(500), @NameList as varchar(500),@ProfileAddress as varchar(200) ,@OwnerUserID as uniqueidentifier''
SET @NStatements=0


if @NameList <> null or @TownIDs <> null or @ProfileAddress <> null or @OwnerUserID<> null
begin
  set @SqlString = @SqlString + '' where ''
end

if @NameList <> null

begin

SELECT *
INTO #tblNames
FROM fnStringSplitter(@NameList)

SET @SqlString = @SqlString + '' dbo.Artists.Name in (select string from #tblNames) ''

Set @NStatements=1

end



if @TownIDs <> null

begin




if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end


SELECT *
INTO #tblTownIDs
FROM fnSplitter(@TownIDs)

SET @SqlString = @SqlString + '' dbo.Artists.TownID in (select ID from #tblTownIDs) ''

end



if @ProfileAddress <> null

begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' dbo.Artists.ProfileAddress  = @ProfileAddress''

end


if @OwnerUserID <> null

begin

if @NStatements <> 0
begin
SET @SqlString = @SqlString + '' and ''
end

SET @SqlString = @SqlString + '' dbo.Artists.UserID  = @OwnerUserID''

end

Set @SqlString = @SqlString + '' order by dbo.Artists.Name ''

 Exec  sp_executesql @SqlString,@ParmDefinition,@TownIDS,@NameList, @ProfileAddress,@OwnerUserID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClassifiedsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetClassifiedsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@PublishedBefore as datetime,
@PublishedAfter as datetime,
@TownIds as varchar(800),
@OwnerUserID as uniqueidentifier,
@PublicationStatus as varchar(10),
@ListenToClassifiedType as varchar(20),
@InstrumentID as uniqueidentifier,
@StyleID as uniqueidentifier,
@ID as uniqueidentifier
as


/*******************************************************************************************************/
/*DECLARE VARIABLES */
/*******************************************************************************************************/

DECLARE @SqlString   NVARCHAR(4000)
SET @SqlString =''  ''

DECLARE @OrderSQLString  NVARCHAR(4000)
SET @OrderSQLString =''  ''

DECLARE  @SqlSelectString NVARCHAR(4000)
SET @SqlSelectString =''  ''

DECLARE  @SqlFilterString NVARCHAR(4000)
SET @SqlFilterString =''  ''

DECLARE  @BandSQLString NVARCHAR(4000)
SET @BandSQLString =''  ''

DECLARE  @UserSQLString NVARCHAR(4000)
SET @UserSQLString =''  ''

DECLARE  @GeneralSQLString NVARCHAR(4000)
SET @GeneralSQLString =''  ''

DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)

SET @ParamDef =''
@OwnerUserID as uniqueidentifier, 
@PublishedBefore as datetime, 
@PublishedAfter as datetime, 
@InstrumentID as uniqueidentifier,
@StyleID as uniqueidentifier,
@ID as uniqueidentifier
''

/*******************************************************************************************************/
/* DETERMINE IF ROW COUNT IS REQUIRED */
/*******************************************************************************************************/


SET @NStatements=0


/*******************************************************************************************************/
/* BUILD THE STANDARD SELECT STATEMENT*/
/*******************************************************************************************************/

SET @SqlSelectString =  ''
SELECT     

ID, 
Title,
Body, 
Created,
FirstPublished,
OwnerUserID, 
ListenToClassifiedType,
IsActive,
IsSuspended,
IsPublished,
SourceID,
SourceName,
SourceImageFilename

FROM
''

/*******************************************************************************************************/
/* DETERMINE IF WHERE STATEMENT IF REQUIRED IN  FILTER STATEMENT     */
/*******************************************************************************************************/

if  @TownIds <> null  or 
	@OwnerUserID <> null or 
	@ListenToClassifiedType <>  null or 
	@PublicationStatus <> '''' or 
	@PublishedBefore <> null or 
	@PublishedAfter <> null or
	@InstrumentID <> null or 
	@StyleID <> null or
	@ID <> null
	
	begin
		  set @SqlFilterString = @SqlFilterString + '' where ''
	end


/*******************************************************************************************************/
/* BUILD ID  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @ID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  ID = @ID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* BUILD INSTRUMENT  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @InstrumentID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  InstrumentID = @InstrumentID ''

		SET @NStatements=1

end


/*******************************************************************************************************/
/* BUILD STYLE  BASED TYPE SEARCH                                                                               */
/*******************************************************************************************************/

if @StyleID <> null

	begin

		if @NStatements <> 0
		
			begin
				
				SET @SqlFilterString = @SqlFilterString + '' and ''
			
			end

		SET @SqlFilterString = @SqlFilterString + ''  StyleID = @StyleID ''

		SET @NStatements=1

end

/*******************************************************************************************************/
/* LOCATION SEARCH                                                                                                    */
/*******************************************************************************************************/

if @TownIds <> null

	begin

		if @NStatements <> 0
		
			begin
		
				SET @SqlFilterString = @SqlFilterString + '' and ''
			end


		SELECT * INTO #tblTownIds FROM fnSplitter(@TownIds)

		SET @SqlFilterString = @SqlFilterString  + ''TownID  in (select id from #tblTownIds) ''
		
		SET @NStatements=1
	end




/*******************************************************************************************************/
/* OWNER SEARCH                                                                                                        */
/*******************************************************************************************************/


if @OwnerUserID <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  OwnerUserID = @OwnerUserID ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/* PUBLICATION STATUS                                                                                               */
/*******************************************************************************************************/


if @PublicationStatus =''Published''

	begin

		if @NStatements <> 0
		
		begin

		SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 and IsSuspended=0 ''

		SET @NStatements = 1

	end

if @PublicationStatus =''Hidden''

	begin

		if @NStatements <> 0

		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and ''

		end


		SET @SqlFilterString = @SqlFilterString + ''  IsPublished=1 or IsSuspended=1 ''

		SET @NStatements = 1
	end

if @PublicationStatus =''Suspended''

	begin

		if @NStatements <> 0
		
		begin
		
			SET @SqlFilterString = @SqlFilterString + '' and  ''

		end

		SET @SqlFilterString = @SqlFilterString + ''  IsSuspended=1''

		SET @NStatements = 1
	end


/*******************************************************************************************************/
/* PUBLICATION DATE SEARCH                                                                                   */
/*******************************************************************************************************/



if @PublishedBefore <> null and @PublishedAfter = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  FirstPublished <  @PublishedBefore ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore = null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  FirstPublished >  @PublishedAfter ''

		SET @NStatements = 1
		
	end

if @PublishedAfter <> null and @PublishedBefore <> null

	begin

		if @NStatements <> 0

		begin
			SET @SqlFilterString = @SqlFilterString + '' and ''
		end

		SET @SqlFilterString = @SqlFilterString + ''  FirstPublished >  @PublishedAfter and  FirstPublished <   @PublishedBefore ''

		SET @NStatements = 1
		
	end



/*******************************************************************************************************/
/*  BUILD STANDARD SQL                                                                                             */
/*******************************************************************************************************/

set @BandSQLString = @SqlSelectString + ''vw_BandClassifieds'' + @SqlFilterString
set @UserSQLString =  @SqlSelectString + ''vw_UserClassifieds'' + @SqlFilterString
set @GeneralSQLString =  @SqlSelectString + ''vw_GeneralClassifieds'' + @SqlFilterString


/*******************************************************************************************************/
/*  BUILD Temporary Table SQL                                                                                             */
/*******************************************************************************************************/

	CREATE TABLE #TempClassifieds
	(
	
	ID uniqueidentifier, 
	Title  varchar(150),
	Body  varchar(6000),
	Created datetime,
	FirstPublished DateTime, 
	OwnerUserID uniqueidentifier, 
	ListenToClassifiedType  varchar(20),
	IsActive bit,
	IsSuspended bit,
	IsPublished bit,
	SourceID uniqueidentifier, 
	SourceName varchar(200), 
	SourceImageFilename varchar(50), 
	
	)

/*******************************************************************************************************/
/*  DETERMINE WHICH TYPES ARE REQUIRED                                                         */
/*******************************************************************************************************/


if @ListenToClassifiedType= ''All''

	begin

		/*ONLY GENERIC SEARCH IS PERFORMED HERE*/
		
		SET @SqlString = @BandSQLString + '' union '' + @UserSQLString + '' union '' + @GeneralSQLString
		
	end



if @ListenToClassifiedType= ''MusicianWanted''
	
	begin

		SET @SqlString = @BandSQLString

	end



if @ListenToClassifiedType= ''MusicianAvailable''

	begin

		SET @SqlString = @UserSQLString

	end


if @ListenToClassifiedType= ''General''

	begin


		SET @SqlString = @GeneralSQLString


	end





/*******************************************************************************************************/
/* Place in a Temporary Table                                                                                             	  	    */
/*******************************************************************************************************/

	INSERT INTO #TempClassifieds 
	(
		ID,
		Title, 
		Body,
		Created,
		FirstPublished,
		OwnerUserID, 
		ListenToClassifiedType, 
		IsActive, 
		IsSuspended, 
		IsPublished,
		SourceID, 
		SourceName, 
		SourceImageFilename
	)
	
			
	exec  sp_executesql 
	
	@SqlString, 
	@ParamDef, 
	@OwnerUserID = @OwnerUserID,
	@InstrumentID = @InstrumentID,
	@StyleID = @StyleID,
	@PublishedBefore= @PublishedBefore,
	@PublishedAfter=@PublishedAfter,
	@ID=@ID

/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE WITH DISTINCT DATA                                                  */
/*******************************************************************************************************/

	Set @OrderSQLString = 

	''
	SELECT distinct (ID)    
		ID, 
		Title,
		Body, 
		Created,
		FirstPublished,
		OwnerUserID, 
		ListenToClassifiedType,
		IsActive,
		IsSuspended,
		IsPublished,
		SourceID,
		SourceName,
		SourceImageFilename
	
	from #TempClassifieds
	
	order by FirstPublished desc
	
	''

	CREATE TABLE #TempItems
	(
		nID INT IDENTITY,
		ID uniqueidentifier, 
		Title  varchar(150),
		Body  varchar(6000),
		Created datetime,
		FirstPublished DateTime, 
		OwnerUserID uniqueidentifier, 
		ListenToClassifiedType  varchar(20),
		IsActive bit,
		IsSuspended bit,
		IsPublished bit,
		SourceID uniqueidentifier, 
		SourceName varchar(200), 
		SourceImageFilename varchar(50)
	)


	INSERT INTO #TempItems 
	(
		ID,
		Title, 
		Body,
		Created,
		FirstPublished,
		OwnerUserID, 
		ListenToClassifiedType, 
		IsActive, 
		IsSuspended, 
		IsPublished,
		SourceID, 
		SourceName, 
		SourceImageFilename
	)
	
			
	exec  sp_executesql @OrderSQLString

/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID,
		Title, 
		Body,
		Created,
		FirstPublished,
		OwnerUserID, 
		ListenToClassifiedType, 
		IsActive, 
		IsSuspended, 
		IsPublished,
		SourceID, 
		SourceName, 
		SourceImageFilename

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end

else
 
	begin

		SELECT 

		ID,
		Title, 
		Body,
		Created,
		FirstPublished,
		OwnerUserID, 
		ListenToClassifiedType, 
		IsActive, 
		IsSuspended, 
		IsPublished,
		SourceID, 
		SourceName, 
		SourceImageFilename

		FROM #TempItems

	end



/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/



Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetArtistsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[GetArtistsView]
@FirstRecord as int,
@LastRecord as int,
@OrderByLatest as bit,
@TownID as uniqueidentifier,
@TownIDs as varchar(500),
@StyleID as uniqueidentifier,
@OwnerUserID as uniqueidentifier,
@ID as uniqueidentifier,
@Keywords as varchar(500)

as

DECLARE  @SQLString NVARCHAR(4000)
DECLARE @NStatements bit
DECLARE @ParamDef NVARCHAR(500)


SET @ParamDef =''@TownIDs as varchar(500), @StyleID as uniqueidentifier,@TownID as uniqueidentifier,@OwnerUserID as uniqueidentifier, @ID as uniqueidentifier, @Keywords as varchar(500)''

SET @NStatements=0
SET @SqlString =''''
SET @SqlString = @SqlString + 

''
SELECT    

dbo.Artists.ID, 
dbo.Artists.Name, 
dbo.Artists.StyleID, 
dbo.Styles.Name AS StyleName,
dbo.Artists.TownID, 
dbo.Towns.Name ASTownName, 
dbo.Artists.ProfileAddress, 
Images_1.filename AS logoThumbnailFilename,
dbo.Artists.Created,
dbo.Artists.UserID

FROM       

dbo.Images Images_1 RIGHT OUTER JOIN
dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID RIGHT OUTER JOIN
dbo.Artists INNER JOIN
dbo.Styles ON dbo.Artists.StyleID = dbo.Styles.ID INNER JOIN
dbo.Towns ON dbo.Artists.TownID = dbo.Towns.ID ON Images_2.ID = dbo.Artists.LogoImageID
''

if @TownIDs <> null or @StyleID<> null or @TownID <> null or @ID <> null or @OwnerUserID<> null or @Keywords <> null
begin
  set @SqlString = @SqlString + '' where ''
end

/*******************************************************************************************************/
/* KEYWORD SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @Keywords <> null

	begin
	
		SET @SqlString = @SqlString + ''dbo.Artists.Name like ''''%'' + Replace(@keywords,'','', ''%'''' or dbo.Artists.Name like ''''%'') + ''%'''' ''
		SET @NStatements=1

	end



/*******************************************************************************************************/
/* TOWN SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @TownIDs <> null

	begin

		if @NStatements <> 0
			begin
			SET @SqlString = @SqlString + '' and ''
			end
	
		SELECT *
		INTO #tblTowns
		FROM fnSplitter(@TownIDs)
		
		SET @SqlString = @SqlString + ''TownID in (select id from #tblTowns) ''
		SET @NStatements=1
	end

else

	begin
		if @TownID <> null

			begin

				if @NStatements <> 0
				begin
				SET @SqlString = @SqlString + '' and ''
				end

				SET @SqlString = @SqlString + '' TownID = @TownID ''
				SET @NStatements=1
			end
	end

/*******************************************************************************************************/
/* STYLE SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @StyleID <> null
	begin
	
		if @NStatements <> 0
			begin
			SET @SqlString = @SqlString + '' and ''
			end
		
			SET @SqlString = @SqlString + ''  dbo.Artists.StyleID = @StyleID ''
	end

/*******************************************************************************************************/
/* OWNER SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @OwnerUserID <> null
	begin
	
		if @NStatements <> 0
			begin
				SET @SqlString = @SqlString + '' and ''
			end
		
			SET @SqlString = @SqlString + ''  dbo.Artists.UserID = @OwnerUserID ''
	end

/*******************************************************************************************************/
/* ARTIST SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @ID <> null
	begin
	
		if @NStatements <> 0
			begin
				SET @SqlString = @SqlString + '' and ''
			end
			
			SET @SqlString = @SqlString + ''  dbo.Artists.ID = @ID ''
	end


/*******************************************************************************************************/
/* ORDER  SEARCH	                                                                                                 */
/*******************************************************************************************************/

if @OrderByLatest = 1
	begin
		SET @SqlString = @SqlString + ''  order by dbo.Artists.Created desc, dbo.Artists.Name  ''
	end
	else
	begin
		
		SET @SqlString = @SqlString + ''  order by dbo.Artists.Name  ''
	end

print @SqlString
/*******************************************************************************************************/
/*  BUILD AND POPULATE  TEMP TABLE                                                                     */
/*******************************************************************************************************/

CREATE TABLE #TempItems
(
	nID INT IDENTITY,
	ID uniqueidentifier, 
	Name varchar(200),
	StyleID uniqueidentifier, 
	StyleName varchar(50), 
	TownID  uniqueidentifier,
	TownName varchar(200), 
	ProfileAddress varchar(200),
	logoThumbnailFilename  varchar(50), 
	Created datetime,
	UserID uniqueidentifier
)

INSERT INTO #TempItems (
	ID, 
	Name, 
	StyleID, 
	StyleName, 
	TownID, 
	TownName, 
	ProfileAddress, 
	logoThumbnailFilename,
	Created,
	UserID
)

        
exec  sp_executesql 
@SqlString, 
@ParamDef, 
@TownIDs =@TownIDs, @StyleID=@StyleID,@TownID=@TownID,@OwnerUserID=@OwnerUserID, @ID=@ID, @Keywords=@Keywords

/*******************************************************************************************************/
/* START PAGING  */
/*******************************************************************************************************/

if( @FirstRecord<>null)

	begin

		SELECT 

		ID, 
		Name, 
		StyleID, 
		StyleName, 
		TownID, 
		TownName, 
		ProfileAddress, 
		logoThumbnailFilename,
		Created,
		UserID

		FROM #TempItems
	
		WHERE nID >= @FirstRecord AND nID <= @LastRecord

	end

else
 
	begin

		SELECT 

		ID, 
		Name, 
		StyleID, 
		StyleName, 
		TownID, 
		TownName, 
		ProfileAddress, 
		logoThumbnailFilename,
		Created,
		UserID


		FROM #TempItems

	end

/*******************************************************************************************************/
/* RETURN THE NUMBER OF RESULTS */
/*******************************************************************************************************/

Select max(nID)  from #TempItems' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddArtist]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddArtist]
(
@ID uniqueidentifier,
@StyleID uniqueidentifier,
@TownID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name varchar(50),
@Profile varchar(3000),
@Created datetime,
@Formed datetime,
@LogoImageID uniqueidentifier,
@OfficalWebsiteURL varchar(200),
@EmailAddress varchar(50),
@ProfileAddress varchar(50)

)

as

insert into Artists
(ID,StyleID,TownID, UserID,Name, Profile, Created, Formed,LogoImageID,OfficalWebsiteURL,EmailAddress,ProfileAddress) values (@ID,@StyleID,@TownID,@OwnerUserID,@Name,@Profile,@Created,@Formed,@LogoImageID,@OfficalWebsiteURL,@EmailAddress,@ProfileAddress)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateArtist]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateArtist]
(
@ID uniqueidentifier,
@StyleID uniqueidentifier,
@TownID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name varchar(50),
@Profile varchar(3000),
@Created datetime,
@Formed datetime,
@LogoImageID uniqueidentifier,
@OfficalWebsiteURL varchar(200),
@EmailAddress varchar(50),
@ProfileAddress varchar(50)

)

as

update  Artists
set

ID=@ID,
StyleID =@StyleID,
TownID = @TownID,
 UserID=@OwnerUserID,
Name=@Name,
 Profile=@Profile,
 Created=@Created,
 Formed=@Formed,
LogoImageID=@LogoImageID,
OfficalWebsiteURL=@OfficalWebsiteURL,
EmailAddress=@EmailAddress,
ProfileAddress=@ProfileAddress

where ID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_LatestArtists]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_LatestArtists]
AS
SELECT     TOP 100 PERCENT Created, ID, Name
FROM         dbo.Artists
ORDER BY Created DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Artists (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 284
               Right = 404
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 4
         Width = 284
         Width = 3120
         Width = 4035
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestArtists'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestArtists'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetActsView]

@GigIDs as varchar(5000)

as


if @GigIDs is  null


SELECT        dbo.Acts.ID, dbo.Acts.GigID,dbo.Acts.ArtistID, dbo.Acts.Name, dbo.Acts.Thumbnail, dbo.Artists.ProfileAddress
FROM         dbo.Acts LEFT OUTER JOIN
                      dbo.Artists ON dbo.Acts.ArtistID = dbo.Artists.ID
                     
else

SELECT        dbo.Acts.ID, dbo.Acts.GigID,dbo.Acts.ArtistID, dbo.Acts.Name, dbo.Acts.Thumbnail, dbo.Artists.ProfileAddress
FROM         dbo.Acts LEFT OUTER JOIN
                      dbo.Artists ON dbo.Acts.ArtistID = dbo.Artists.ID


WHERE GigID in (select ID from fnSplitter(@GigIDs))
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetArtist]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[GetArtist]

@ID uniqueidentifier,
@Name varchar(50),
@ProfileAddress varchar(50)

as

SELECT id,StyleID,TownID,UserID, Name, Profile, Created, Formed,LogoImageID,OfficalWebsiteURL,EmailAddress,ProfileAddress
FROM  Artists
WHERE ((@ID is null) or (ID like @ID)) and  ((@Name is null) or (Name like @Name))  and  ((@ProfileAddress is null) or (ProfileAddress like @ProfileAddress))' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_TracksPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_TracksPerUser]
AS
SELECT     TOP 100 PERCENT COUNT(dbo.Tracks.Title) AS NumberOfTracks, dbo.Users.ID
FROM         dbo.Tracks RIGHT OUTER JOIN
                      dbo.Artists ON dbo.Tracks.ArtistID = dbo.Artists.ID RIGHT OUTER JOIN
                      dbo.Users ON dbo.Artists.UserID = dbo.Users.ID
GROUP BY dbo.Users.ID
ORDER BY NumberOfTracks DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Tracks (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 195
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Artists (dbo)"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 436
               Bottom = 121
               Right = 610
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_TracksPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_TracksPerUser'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_EmailAddresses]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_EmailAddresses]
AS
SELECT DISTINCT EmailAddress
FROM         (SELECT     EmailAddress
                       FROM          dbo.Users
                       WHERE      recievesNewsletter = 1
                       UNION
                       SELECT     EmailAddress
                       FROM         artists) DERIVEDTBL
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DERIVEDTBL"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 76
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 2
         Width = 284
         Width = 5055
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_EmailAddresses'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_EmailAddresses'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TrackReviews]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_TrackReviews]
AS
SELECT     dbo.Ratings.Score, dbo.Reviews.ID, dbo.Reviews.UserID, dbo.Reviews.Name, dbo.Reviews.Description, dbo.Reviews.PublishDate, 
                      dbo.Reviews.ExpiryDate, dbo.Reviews.ImageID, dbo.Reviews.SubjectListenToType, dbo.Reviews.IsPublished, dbo.Reviews.IsSuspended, 
                      dbo.Users.Username, Images_1.filename, dbo.Reviews.SubjectListenToTypeID, dbo.Artists.TownID
FROM         dbo.Ratings INNER JOIN
                      dbo.Tracks INNER JOIN
                      dbo.Reviews ON dbo.Tracks.ID = dbo.Reviews.SubjectListenToTypeID INNER JOIN
                      dbo.Users ON dbo.Reviews.UserID = dbo.Users.ID INNER JOIN
                      dbo.Artists ON dbo.Tracks.ArtistID = dbo.Artists.ID ON dbo.Ratings.ID = dbo.Reviews.RatingID LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Reviews.ImageID = Images_2.ID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_ArtistsPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_ArtistsPerUser]
AS
SELECT     TOP 100 PERCENT COUNT(dbo.Artists.Name) AS NumberOfBands, dbo.Users.ID
FROM         dbo.Artists RIGHT OUTER JOIN
                      dbo.Users ON dbo.Artists.UserID = dbo.Users.ID
GROUP BY dbo.Users.ID
ORDER BY NumberOfBands DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Artists (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 195
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 121
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ArtistsPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ArtistsPerUser'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_LatestComments]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_LatestComments]
AS
SELECT     TOP 100 PERCENT dbo.Comments.TargetListenToType, dbo.Users.Username, dbo.Comments.Body, dbo.Comments.Created, 
                      dbo.Comments.TargetListenToTypeID
FROM         dbo.Users LEFT OUTER JOIN
                      dbo.Comments ON dbo.Users.ID = dbo.Comments.UserID
ORDER BY dbo.Comments.Created DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Comments (dbo)"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 121
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 6
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3030
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestComments'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestComments'

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddComment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddComment]
(
@ID uniqueidentifier,
@Body as text,
@OwnerUserID uniqueidentifier,
@TargetListenToType varchar(15),
@TargetListenToTypeID uniqueidentifier,
@Created datetime

)

as

insert into Comments
(
ID,
Body,
UserID,
TargetListenToType,
TargetListenToTypeID,
Created
)

values 
(

@ID,
@Body,
@OwnerUserID,
@TargetListenToType,
@TargetListenToTypeID,
@Created
)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_CommentsPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_CommentsPerUser]
AS
SELECT     TOP 100 PERCENT COUNT(dbo.Comments.Created) AS NumberOfComments, dbo.Users.ID
FROM         dbo.Comments RIGHT OUTER JOIN
                      dbo.Users ON dbo.Comments.UserID = dbo.Users.ID
GROUP BY dbo.Users.ID
ORDER BY NumberOfComments DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Comments (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 182
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 195
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_CommentsPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_CommentsPerUser'

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateAssertion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateAssertion]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(200),
@Description varchar(200),
@Body varchar(6000),
@Created DateTime,
@FirstPublished DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit,
@IsActive bit

)

as

update  Assertions

set

OwnerUserID=@OwnerUserID,
Name=@Name,
Description=@Description,
Body=@Body,
Created=@Created,
FirstPublished=@FirstPublished,
ImageID=@ImageID,
IsPublished=@IsPublished,
IsSuspended=@IsSuspended,
IsActive=@IsActive


where ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddAssertion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddAssertion]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Name  varchar(200),
@Description varchar(200),
@Body varchar(6000),
@Created DateTime,
@FirstPublished DateTime,
@ImageID uniqueidentifier,
@IsPublished bit,
@IsSuspended bit,
@IsActive bit

)

as

insert into Assertions
(
ID,
OwnerUserID,
Name,
Description,
Body,
Created,
FirstPublished,
ImageID,
IsPublished,
IsSuspended,
IsActive
)

values 
(

@ID,
@OwnerUserID,
@Name,
@Description,
@Body,
@Created,
@FirstPublished,
@ImageID,
@IsPublished,
@IsSuspended,
@IsActive
)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_RatingsStatistics]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_RatingsStatistics]
AS
SELECT     COUNT(Created) AS NumVotes, SUM(Score) AS TotalRating, SubjectListenToTypeID, SubjectListenToType
FROM         dbo.Ratings
GROUP BY SubjectListenToTypeID, SubjectListenToType
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TestChart]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_TestChart]
AS
SELECT     COUNT(Score) AS TotalScore, SubjectListenToTypeID AS TrackID
FROM         dbo.Ratings
GROUP BY SubjectListenToTypeID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetReview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetReview]
(
		@ID uniqueidentifier
)
AS
	SELECT ID,UserID as OwnerUserID, name,description,body,Created,PublishDate, expiryDate,  ImageID, SubjectListenToType, SubjectListenToTypeID,IsPublished, IsSuspended
	FROM Reviews
	WHERE ID=@ID


Declare @RatingID as  uniqueidentifier

Set @RatingID = (Select RatingID from Reviews where ID=@ID)


Select  ID, Score, UserID as OwnerUserID, SubjectListenToType, SubjectListenToTypeID, Created
from Ratings where ID = @RatingID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddRating]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddRating]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Score  int,
@SubjectListenToType varchar(15),
@SubjectListenToTypeID uniqueidentifier,
@Created datetime

)

as

insert into Ratings
(
ID,
UserID,
Score,
SubjectListenToType,
SubjectListenToTypeID,
Created
)

values 
(

@ID,
@OwnerUserID,
@Score,
@SubjectListenToType,
@SubjectListenToTypeID,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateRating]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateRating]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@Score  int,
@SubjectListenToType varchar(15),
@SubjectListenToTypeID uniqueidentifier,
@Created datetime

)

as

Update  Ratings

set

UserID = @OwnerUserID,
Score = @Score,
SubjectListenToType = @SubjectListenToType,
SubjectListenToTypeID =@SubjectListenToTypeID,
Created = @Created

where 

ID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Ratings]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_Ratings]
AS
SELECT     dbo.Ratings.ID, dbo.Ratings.Score, dbo.Ratings.SubjectListenToType, dbo.Ratings.SubjectListenToTypeID, dbo.Ratings.Created, 
                      dbo.Users.Username AS OwnerUsername, dbo.Ratings.UserID AS OwnerUserId
FROM         dbo.Ratings INNER JOIN
                      dbo.Users ON dbo.Ratings.UserID = dbo.Users.ID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ChartsThumbsUp]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_ChartsThumbsUp]
AS
SELECT     SubjectListenToTypeID, 
                      CASE Score WHEN 5 THEN 5  WHEN 4 THEN 3 WHEN 3 THEN 1 WHEN 2 THEN -1 WHEN 1 THEN -3 END AS Score, Created
FROM         dbo.Ratings



' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Ratings (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 190
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 4
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_ChartsThumbsUp'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_ChartsThumbsUp'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_RatingsPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_RatingsPerUser]
AS
SELECT     TOP 100 PERCENT dbo.Users.ID, COUNT(dbo.Ratings.Score) AS NumberOfRatings
FROM         dbo.Ratings RIGHT OUTER JOIN
                      dbo.Users ON dbo.Ratings.UserID = dbo.Users.ID
GROUP BY dbo.Users.ID
ORDER BY NumberOfRatings DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Ratings (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 13
               Left = 518
               Bottom = 128
               Right = 692
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_RatingsPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_RatingsPerUser'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_ReviewsPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_ReviewsPerUser]
AS
SELECT     TOP 100 PERCENT dbo.Users.ID, COUNT(dbo.Reviews.Name) AS NumberOfReviews
FROM         dbo.Users LEFT OUTER JOIN
                      dbo.Reviews ON dbo.Users.ID = dbo.Reviews.UserID
GROUP BY dbo.Users.ID
ORDER BY NumberOfReviews DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reviews (dbo)"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 121
               Right = 442
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ReviewsPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ReviewsPerUser'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_ArticlesPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_ArticlesPerUser]
AS
SELECT     TOP 100 PERCENT dbo.Users.ID, COUNT(dbo.Article.Name) AS NumberOfArticles
FROM         dbo.Article RIGHT OUTER JOIN
                      dbo.Users ON dbo.Article.UserID = dbo.Users.ID
GROUP BY dbo.Users.ID
ORDER BY NumberOfArticles DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Article (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 0
               Left = 400
               Bottom = 115
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ArticlesPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ArticlesPerUser'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_ListensPerUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_ListensPerUser]
AS
SELECT     TOP 100 PERCENT dbo.Users.Username, COUNT(dbo.Plays.IP) AS NumberOfListens
FROM         dbo.Plays INNER JOIN
                      dbo.Users ON dbo.Plays.UserID = dbo.Users.ID
GROUP BY dbo.Users.Username
ORDER BY COUNT(dbo.Plays.IP) DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Plays (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 402
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 3
         Width = 284
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ListensPerUser'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_ListensPerUser'

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddUserIdentity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddUserIdentity]
(
@ID uniqueidentifier,
@Username varchar(50),
@Password varchar(50),

@Forename varchar(50),
@Surname varchar(50),
@Profile varchar(200),
@EmailAddress varchar(50),

@TownID uniqueidentifier,
@AlternativeLocation varchar(200),

@AvatarImageID uniqueidentifier,

@Created datetime,

@IsUserValidated bit,
@RecievesNewsletter bit


)

as

insert into Users
(ID,Username, Password, Forename, Surname, Profile, EmailAddress,TownID, AlternativeLocation, AvatarImageID,Created,IsUserValidated, RecievesNewsletter) values 

(

@ID,
@Username,
@Password,

@Forename,
@Surname,
@Profile ,
@EmailAddress ,

@TownID ,
@AlternativeLocation,
@AvatarImageID,

@Created ,

@IsUserValidated,
@RecievesNewsletter

)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Messages]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_Messages]
AS
SELECT     Users_1.Username AS ToUsername, Users_2.Username AS FromUsername, dbo.Messages.IsRead, dbo.Messages.Created, dbo.Messages.Subject, 
                      dbo.Messages.FromUserId, dbo.Messages.ToUserId, dbo.Messages.ClassifiedId, dbo.Messages.ID, dbo.Messages.OwnerUserId
FROM         dbo.Messages INNER JOIN
                      dbo.Users Users_1 ON dbo.Messages.ToUserId = Users_1.ID INNER JOIN
                      dbo.Users Users_2 ON dbo.Messages.FromUserId = Users_2.ID

' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateUserIdentity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateUserIdentity]
(
@ID uniqueidentifier,
@Username varchar(50),
@Password varchar(50),

@Forename varchar(50),
@Surname varchar(50),
@Profile varchar(200),
@EmailAddress varchar(50),

@TownID uniqueidentifier,
@AlternativeLocation as varchar(200),
@AvatarImageID uniqueidentifier,

@Created datetime,

@IsUserValidated bit,
@RecievesNewsletter bit


)

as

update   Users set

username= @Username,
password = @Password,

forename=@Forename,
surname=@Surname,
profile=@Profile ,
emailAddress=@EmailAddress ,

TownID=@TownID ,
AlternativeLocation = @AlternativeLocation,
AvatarImageID=@AvatarImageID,

Created=@Created ,

IsUserValidated= @IsUserValidated,
RecievesNewsletter=@RecievesNewsletter

where ID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_LatestUsers]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_LatestUsers]
AS
SELECT     TOP 100 PERCENT dbo.Users.*
FROM         dbo.Users
ORDER BY Created DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 134
               Right = 523
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 14
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestUsers'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestUsers'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_UserIdentity]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_UserIdentity]
AS
SELECT     ID, Username, Password, Forename, Surname, Profile, EmailAddress, TownID, AlternativeLocation, AvatarImageID, Created, IsUserValidated
FROM         dbo.Users
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_displayoaerror_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dt_displayoaerror_u]
    @iObject int,
    @iresult int
as
	-- This procedure should no longer be called;  dt_displayoaerror should be called instead.
	-- Calls are forwarded to dt_displayoaerror to maintain backward compatibility.
	set nocount on
	exec dbo.dt_displayoaerror
		@iObject,
		@iresult


' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPlay]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddPlay]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@TrackID   uniqueidentifier,
@IP varchar(15),
@Created datetime

)

as

insert into Plays
(
ID,
UserID,
IP,
TrackID,
Created
)

values 
(

@ID,
@OwnerUserID,
@IP,
@TrackID,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePlay]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdatePlay]
(
@ID uniqueidentifier,
@OwnerUserID uniqueidentifier,
@TrackID   uniqueidentifier,
@IP varchar(15),
@Created datetime

)

as

Update  Plays set

UserID = @OwnerUserID,
IP = @IP,
TrackID = @TrackID,
Created = @Created
where ID=@ID' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TrackTotalPlays]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_TrackTotalPlays]
AS
SELECT     TrackID, COUNT(IP) AS TotalPlays
FROM         dbo.Plays
GROUP BY TrackID


' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTrack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetTrack]

@ID uniqueidentifier





as

SELECT id,StyleID,ArtistID,ArtistName,Title,Description,Length,Studio,Producer,Engineer, FirstPublished, IsPublished, IsSuspended,created, userID as owneruserID
FROM  Tracks
WHERE ID =  @ID


	SELECT id, IP, UserID as OwnerUserID ,TrackID,Created
	FROM plays
	WHERE TrackID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddTrack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddTrack]
(

@ID uniqueidentifier,
@ArtistID uniqueidentifier,
@ArtistName varchar(50),
@Title varchar(50),
@Description varchar(1000),
@FirstPublished datetime,
@IsPublished as bit,
@IsSuspended as bit,
@OwnerUserID as uniqueidentifier,
@StyleID uniqueidentifier,
@Studio varchar(50),
@Producer varchar(50),
@Engineer varchar(50),
@Created datetime
)

as

insert into Tracks

(
ID,
ArtistID,
ArtistName ,
Title,
Description ,
FirstPublished,
IsPublished,
IsSuspended,
UserID,
StyleID,
Studio ,
Producer ,
Engineer,
Created
) 

values 

(
@ID,
@ArtistID,
@ArtistName ,
@Title,
@Description ,
@FirstPublished,
@IsPublished,
@IsSuspended,
@OwnerUserID,
@StyleID,
@Studio,
@Producer ,
@Engineer,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateTrack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdateTrack]
(

@ID uniqueidentifier,
@ArtistID uniqueidentifier,
@ArtistName varchar(50),
@Title varchar(50),
@Description varchar(1000),

@FirstPublished datetime,
@IsPublished as bit,
@IsSuspended as bit,
@OwnerUserID as uniqueidentifier,
@StyleID uniqueidentifier,
@Studio varchar(50),
@Producer varchar(50),
@Engineer varchar(50),
@Created datetime
)

as

Update Tracks

set

ArtistID = @ArtistID,
ArtistName =@ArtistName ,
Title = @Title,
Description =@Description ,
FirstPublished =@FirstPublished,
IsPublished =@IsPublished,
IsSuspended =@IsSuspended,
UserID =@OwnerUserID,
StyleID =@StyleID,
Studio =@Studio,
Producer =@Producer ,
Engineer =@Engineer,
Created =@Created

where ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPodcast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AddPodcast]
(

@ID uniqueidentifier,

@Title varchar(50),
@Description varchar(1000),
@FirstPublished datetime,
@IsPublished as bit,
@IsSuspended as bit,
@OwnerUserID as uniqueidentifier,
@Created datetime
)

as

insert into Tracks

(
ID,
Title,
Description ,
FirstPublished,
IsPublished,
IsSuspended,
UserID,
Created
) 

values 

(
@ID,
@Title,
@Description ,
@FirstPublished,
@IsPublished,
@IsSuspended,
@OwnerUserID,
@Created
)' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePodcast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdatePodcast]

(
@ID uniqueidentifier,
@Title varchar(50),
@Description varchar(1000),
@FirstPublished datetime,
@IsPublished as bit,
@IsSuspended as bit,
@OwnerUserID as uniqueidentifier,
@Created datetime
)

as

Update Tracks

set

Title = @Title,
Description =@Description ,
FirstPublished =@FirstPublished,
IsPublished =@IsPublished,
IsSuspended =@IsSuspended,
UserID =@OwnerUserID,
Created =@Created

where ID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGigActsView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************************************/
/* Created 30/11/2005                                                                                                     */
/* This is a simple SP that returns a GigActsView based upon the criteria passed.          */
/* More specific searches within each type of Review are handled elsewhere                 */
/*******************************************************************************************************/

CREATE PROCEDURE [dbo].[GetGigActsView]

@GigIDs as varchar(500)

as


if @GigIDs is  null


SELECT        dbo.Acts.ID, dbo.Acts.GigID,dbo.Acts.ArtistID, dbo.Acts.Name, dbo.Acts.Thumbnail, dbo.Artists.ProfileAddress
FROM         dbo.Acts LEFT OUTER JOIN
                      dbo.Artists ON dbo.Acts.ArtistID = dbo.Artists.ID
                     
else

SELECT        dbo.Acts.ID, dbo.Acts.GigID,dbo.Acts.ArtistID, dbo.Acts.Name, dbo.Acts.Thumbnail, dbo.Artists.ProfileAddress
FROM         dbo.Acts LEFT OUTER JOIN
                      dbo.Artists ON dbo.Acts.ArtistID = dbo.Artists.ID


WHERE GigID in (select ID from fnSplitter(@GigIDs))' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetGig]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*this Stored Proc will expect a miniumum of a username or a useridentity*/

CREATE PROCEDURE [dbo].[GetGig]
(
	@ID uniqueidentifier,
	@VenueID uniqueidentifier,
	@Date datetime
)
As 


if @VenueID<>null and @Date <> null

Begin

set @ID = (select ID from dbo.gigs where venueID = @VenueID and Date = @Date)



End



	SELECT ID,name,description,date,venueid,ticketPrice,UserID, ImageID,Created
	FROM Gigs  where ID=@ID


	SELECT id, gigID, artistID,name,stageTime, SetLength,Thumbnail
	FROM acts
	WHERE gigID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[AddAct]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [transparent].[AddAct]
(
@ID uniqueidentifier,
@GigID uniqueidentifier,
@ArtistID uniqueidentifier,
@Name VarChar(50)
/*@StageTime DateTime,
@SetLength varchar(100),
@Thumbnail varchar(100)*/
)
AS


	/*insert into acts ( id, gigID, artistID,name, stageTime, SetLength,Thumbnail) values (@ID,@GigID,@ArtistID,@Name,@StageTime,@SetLength,@Thumbnail)*/

	insert into acts ( id, gigID, artistID,name) values (@ID,@GigID,@ArtistID,@Name)

	RETURN
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteAct]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteAct]
(
@ID uniqueidentifier


)

as

delete  from dbo.Acts

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteSiteTowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteSiteTowns]
(
@SiteId uniqueidentifier


)

as

delete  from dbo.SiteTowns

where siteID=@SiteId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TownsView]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_TownsView]
AS
SELECT     dbo.SiteTowns.SiteId, dbo.Towns.ID, dbo.Towns.Name, dbo.Towns.Created, dbo.Towns.CountryId
FROM         dbo.Towns LEFT OUTER JOIN
                      dbo.SiteTowns ON dbo.Towns.ID = dbo.SiteTowns.TownId

' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddSiteTowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddSiteTowns]
(
@SiteId uniqueidentifier,
@TownId uniqueidentifier


)

as

insert into dbo.SiteTowns

(SiteId, TownId) 

values 

(@SiteId,@TownId)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[AddCountry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [transparent].[AddCountry]
(
@ID uniqueidentifier,
@Name VarChar(50),
@Created datetime
)
AS

	insert into Countries ( id, Name,Created) values (@ID,@Name, @Created)

	RETURN
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[UpdateCountry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [transparent].[UpdateCountry]
(
@ID uniqueidentifier,
@Name VarChar(50)
)
AS

	Update  Countries set  Name=@Name where Id = @ID

	RETURN
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCountry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*this Stored Proc will expect a miniumum of a username or a useridentity*/

CREATE PROCEDURE [dbo].[GetCountry]
(
	@ID uniqueidentifier

)
As 


	SELECT ID,name,Created
	FROM Countries  where ID=@ID


	SELECT id, Name, CountryId,Created
	FROM Towns
	WHERE countryID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteCountry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteCountry]
(
@ID uniqueidentifier


)

as

delete  from dbo.Countries

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[addArticlesTargetSites]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[addArticlesTargetSites]
(
@ArticleID uniqueidentifier,
@SiteID uniqueidentifier
)

as

insert into dbo.ArticlesTargetSites

(
ArticleID,
SiteID
) 

values 

(
@ArticleID,
@SiteID
)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deleteArticlesTargetSites]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[deleteArticlesTargetSites]
(
@ArticleID uniqueidentifier


)

as

delete  from dbo.ArticlesTargetSites

where ArticleID=@ArticleID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[GetArticle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [transparent].[GetArticle]
(
		@ID uniqueidentifier
)
AS
	SELECT ID,UserID,name,description,body,Created,PublishDate, expiryDate,  ImageID, IsPublished, IsSuspended
	FROM Article 
	WHERE ID=@ID



/*Grab Site Data*/

SELECT    

dbo.Sites.ID,  
dbo.Sites.LocationID, 
dbo.Sites.URL, 
dbo.Sites.Name, 
dbo.Sites.Description
FROM        
dbo.Sites

CROSS JOIN
                      
dbo.ArticlesTargetSites

Where   

dbo.ArticlesTargetSites.ArticleID=@ID' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateTown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateTown]
(
@ID uniqueidentifier,
@Name varchar(50),
@CountryId   uniqueidentifier



)

as

Update  Towns set

Name = @Name,
CountryId = @CountryId

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateCountries]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateCountries]
(
@ID uniqueidentifier,
@Name varchar(50),
@Created datetime


)

as

Update  Towns set

Name = @Name,
Created = @Created

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*this Stored Proc will expect a miniumum of a username or a useridentity*/

CREATE PROCEDURE [dbo].[GetTown]
(
	@ID uniqueidentifier

)
As 


	SELECT ID,name,CountryId,Created
	FROM Towns  where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[AddTown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [transparent].[AddTown]
(
@ID uniqueidentifier,
@Name VarChar(50),
@CountryId uniqueidentifier,
@Created datetime
)
AS




	insert into Towns ( id, Name, countryId,created) values (@ID,@Name,@CountryId,@Created)

	RETURN
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteTown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteTown]
(
@ID uniqueidentifier


)

as

delete  from dbo.Towns

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteImage]
(
@ID uniqueidentifier


)

as

delete  from dbo.Images

where ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddImage]
(
@ID uniqueidentifier,
@OwnerID uniqueidentifier,
@ThumbnailID uniqueidentifier,
@Filename  varchar(50),
@Width int,
@Height int,
@Description varchar(50),
@OwnerType varchar(10),
@OwnerUserID uniqueidentifier

)

as

insert into  Images (
 ID,
ownerID,
ThumbnailID,
Filename,
Width,
Height,
description,
OwnerType,
OwnerUserID
)
values

(
@ID,
@OwnerID,
@ThumbnailID,
@Filename,
@Width,
@Height,
@Description,
@OwnerType,
@OwnerUserID
)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateImage]
(
@ID uniqueidentifier,
@OwnerID uniqueidentifier,
@ThumbnailID uniqueidentifier,
@Filename  varchar(50),
@Width int,
@Height int,
@Description varchar(50),
@OwnerType varchar(10),
@OwnerUserID uniqueidentifier

)

as

update  Images set 
ownerID = @OwnerID,
ThumbnailID= @ThumbnailID,
Filename =  @Filename,
Width = @Width,
Height = @Height,
description = @Description,
OwnerType = @OwnerType,
OwnerUserID= @OwnerUserID
where ID =  @ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[transparent].[GetImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [transparent].[GetImage]
	(
		@ID uniqueidentifier
	)
AS
	SELECT ID,ownerID, ThumbnailID, filename, width, height,description,OwnerType,OwnerUserID
	FROM Images 
	WHERE ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetImagesView]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*DateEnding and Date Beginning define a range of dates that the gig can fall within*/


CREATE PROCEDURE [dbo].[GetImagesView]

@OwnerType as VarChar(10),
@OwnerID as uniqueidentifier,
@OwnerIDs as varchar(500),
@ImageID as uniqueidentifier

as



if (@OwnerIDs is null)
begin


	SELECT  dbo.Images.ID, dbo.Images.Filename, dbo.Images.Width, dbo.Images.Height, dbo.Images.description  from  dbo.Images
where

 ((@OwnerType is null) or (OwnerType =  @OwnerType))

and

 ((@OwnerID is null) or (OwnerID =  @OwnerID))


and

 ((@ImageID is null) or (dbo.Images.ID =  @ImageID))
end

else
begin

SELECT  dbo.Images.ID, dbo.Images.Filename, dbo.Images.Width, dbo.Images.Height, dbo.Images.description  from  dbo.Images
where

 ((@OwnerType is null) or (OwnerType =  @OwnerType))

and

 ((@OwnerID is null) or (OwnerID =  @OwnerID))


and


		( @OwnerIDs is  null) 
		or 
 		( OwnerID in (select ID from fnSplitter(@OwnerIDs) ))
and

 ((@ImageID is null) or (dbo.Images.ID =  @ImageID))
end
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLocationList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetLocationList]

@ParentID uniqueidentifier


as

if @ParentID is  null


Select id,name from Locations  order by name

else



/*GET ALL THE DESCENDENTS OF THE PARENT*/
Select ChildLocation.ID, ChildLocation.Name 
From Locations as ChildLocation, Locations as ParentLocation
Where ParentLocation.lft <= ChildLocation.lft and ParentLocation.rgt >= ChildLocation.rgt
and ParentLocation.ID=@ParentID
Order by ChildLocation.Name
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetRegion]
(
@ID uniqueidentifier
)

as

SELECT    dbo.Regions.ID, dbo.Regions.Name, dbo.Regions.ParentID
FROM          dbo.Regions

WHERE   dbo.Regions.ID=@ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[AddRegion]
(
@ID uniqueidentifier,
@Name varchar(50),
@ParentID uniqueidentifier

)

as

insert into Regions
(ID,Name,ParentID) values (@ID,@Name,@ParentID)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TracksView]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_TracksView]
AS
SELECT     dbo.Tracks.ID, dbo.Tracks.ArtistID, dbo.Tracks.StyleID, dbo.Tracks.ArtistName, dbo.Styles.Name AS StyleName, dbo.Tracks.Title AS Name, 
                      dbo.Tracks.Description, dbo.Tracks.UserID, dbo.Tracks.firstPublished, dbo.Tracks.IsSuspended, dbo.Tracks.IsPublished, dbo.Tracks.created, 
                      dbo.vw_RatingsStatistics.NumVotes, dbo.vw_RatingsStatistics.TotalRating, dbo.Users.Username, dbo.vw_TrackTotalPlays.TotalPlays, 
                      dbo.Artists.ProfileAddress AS ArtistProfileAddress, dbo.Artists.TownID
FROM         dbo.Tracks INNER JOIN
                      dbo.Styles ON dbo.Tracks.StyleID = dbo.Styles.ID INNER JOIN
                      dbo.Users ON dbo.Tracks.UserID = dbo.Users.ID INNER JOIN
                      dbo.Artists ON dbo.Tracks.ArtistID = dbo.Artists.ID LEFT OUTER JOIN
                      dbo.vw_TrackTotalPlays ON dbo.Tracks.ID = dbo.vw_TrackTotalPlays.TrackID LEFT OUTER JOIN
                      dbo.vw_RatingsStatistics ON dbo.Tracks.ID = dbo.vw_RatingsStatistics.SubjectListenToTypeID

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_UserStats]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_UserStats]
AS
SELECT     dbo.Users.ID, dbo.Users.Username, dbo.rpt_RatingsPerUser.NumberOfRatings, dbo.rpt_ReviewsPerUser.NumberOfReviews, 
                      dbo.rpt_CommentsPerUser.NumberOfComments, dbo.rpt_TracksPerUser.NumberOfTracks, dbo.rpt_ArtistsPerUser.NumberOfBands, 
                      dbo.rpt_ArticlesPerUser.NumberOfArticles
FROM         dbo.rpt_RatingsPerUser INNER JOIN
                      dbo.Users ON dbo.rpt_RatingsPerUser.ID = dbo.Users.ID INNER JOIN
                      dbo.rpt_ReviewsPerUser ON dbo.Users.ID = dbo.rpt_ReviewsPerUser.ID INNER JOIN
                      dbo.rpt_CommentsPerUser ON dbo.Users.ID = dbo.rpt_CommentsPerUser.ID INNER JOIN
                      dbo.rpt_TracksPerUser ON dbo.Users.ID = dbo.rpt_TracksPerUser.ID INNER JOIN
                      dbo.rpt_ArtistsPerUser ON dbo.Users.ID = dbo.rpt_ArtistsPerUser.ID INNER JOIN
                      dbo.rpt_ArticlesPerUser ON dbo.Users.ID = dbo.rpt_ArticlesPerUser.ID
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "rpt_RatingsPerUser (dbo)"
            Begin Extent = 
               Top = 229
               Left = 113
               Bottom = 314
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt_ReviewsPerUser (dbo)"
            Begin Extent = 
               Top = 9
               Left = 152
               Bottom = 94
               Right = 322
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt_TracksPerUser (dbo)"
            Begin Extent = 
               Top = 6
               Left = 662
               Bottom = 91
               Right = 823
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt_ArticlesPerUser (dbo)"
            Begin Extent = 
               Top = 6
               Left = 861
               Bottom = 91
               Right = 1026
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt_ArtistsPerUser (dbo)"
            Begin Extent = 
               Top = 158
               Left = 705
               Bottom = 243
               Right = 864
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt_CommentsPerUser (dbo)"
            Begin Extent = 
               Top = 96
               Left = 447
               Bottom = 181
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 188
               Left = 422
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_UserStats'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'               Bottom = 303
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 9
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_UserStats'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_UserStats'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Chart_Ratings]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_Chart_Ratings]
AS
SELECT     TOP 100 PERCENT SubjectListenToTypeID, SUM(Score) AS TotalScore, COUNT(Score) AS NumRatings
FROM         dbo.vw_ChartsThumbsUp
GROUP BY SubjectListenToTypeID
ORDER BY SUM(Score) DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_ChartsThumbsUp (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 106
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 4
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_Chart_Ratings'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_Chart_Ratings'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_whocheckedout]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_whocheckedout]
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = ''SQLVersionControl.VCS_SQL''

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSProject'',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSourceSafeINI'', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLServer'',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLDatabase'',   @vchDatabaseName  OUT

    if @chObjectType = ''PROC''
    begin
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''''

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												''WhoCheckedOut'',
												@vchReturnValue OUT,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_validateloginparams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_validateloginparams]
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = ''SQLVersionControl.VCS_SQL''

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSourceSafeINI'', @vchSourceSafeINI OUT

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											''ValidateLoginParams'',
											NULL,
											@sSourceSafeINI = @vchSourceSafeINI,
											@sLoginName = @vchLoginName,
											@sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_isundersourcecontrol]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_isundersourcecontrol]
    @vchLoginName varchar(255) = '''',
    @vchPassword  varchar(255) = '''',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID varchar(100)
	select @VSSGUID = ''SQLVersionControl.VCS_SQL''

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSProject'',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSourceSafeINI'', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLServer'',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLDatabase'',   @vchDatabaseName  OUT

    if (@vchProjectName = '''')	set @vchProjectName		= null
    if (@vchSourceSafeINI = '''') set @vchSourceSafeINI	= null
    if (@vchServerName = '''')	set @vchServerName		= null
    if (@vchDatabaseName = '''')	set @vchDatabaseName	= null
    
    if (@vchProjectName is null) or (@vchSourceSafeINI is null) or (@vchServerName is null) or (@vchDatabaseName is null)
    begin
        RAISERROR(''Not Under Source Control'',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												''GetListOfObjects'',
												NULL,
												@vchProjectName,
												@vchSourceSafeINI,
												@vchServerName,
												@vchDatabaseName,
												@vchLoginName,
												@vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, ''GetStreamObject'', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = ''STUB''
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, ''GetStream'', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '''') set @vchTempText = null
            if (@vchTempText is not null) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_checkoutobject]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_checkoutobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId =0

	declare @VSSGUID varchar(100)
	select @VSSGUID = ''SQLVersionControl.VCS_SQL''

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @vchTempText varchar(255)

	/* this is for our strings */
	declare @iStreamObjectId int
	select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSProject'',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSourceSafeINI'', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLServer'',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLDatabase'',   @vchDatabaseName  OUT

    if @chObjectType = ''PROC''
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
												''CheckOut_StoredProcedure'',
												NULL,
												@sProjectName = @vchProjectName,
												@sSourceSafeINI = @vchSourceSafeINI,
												@sObjectName = @vchObjectName,
												@sServerName = @vchServerName,
												@sDatabaseName = @vchDatabaseName,
												@sComment = @vchComment,
												@sLoginName = @vchLoginName,
												@sPassword = @vchPassword,
												@iVCSFlags = @iVCSFlags,
												@iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, ''GetStreamObject'', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = ''STUB''
        while @vchTempText is not null
        begin
            exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, ''GetStream'', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError
            
            if (@vchTempText = '''') set @vchTempText = null
            if (@vchTempText is not null) insert into #commenttext (sourcecode) select @vchTempText
        end

        select ''VCS''=sourcecode from #commenttext order by id
        select ''SQL''=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_checkinobject]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_checkinobject]
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='''',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='''',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '''', /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '''', /* create stream */
    @txStream3     Text = ''''  /* grant stream  */


as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0
	declare @iStreamObjectId int

	declare @VSSGUID varchar(100)
	select @VSSGUID = ''SQLVersionControl.VCS_SQL''

	declare @iPropertyObjectId int
	select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    declare @iReturnValue	  int
    declare @pos			  int
    declare @vchProcLinePiece varchar(255)

    
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSProject'',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSourceSafeINI'', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLServer'',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, ''VCSSQLDatabase'',   @vchDatabaseName  OUT

    if @chObjectType = ''PROC''
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = master.dbo.sp_OAGetProperty @iObjectId, ''GetStreamObject'', @iStreamObjectId OUT
        if @iReturn <> 0 GOTO E_OAError
        
        if @iActionFlag = 1
        begin
            
            declare @iStreamLength int
			
			select @pos=1
			select @iStreamLength = datalength(@txStream2)
			
			if @iStreamLength > 0
			begin
			
				while @pos < @iStreamLength
				begin
						
					select @vchProcLinePiece = substring(@txStream2, @pos, 255)
					
					exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, ''AddStream'', @iReturnValue OUT, @vchProcLinePiece
            		if @iReturn <> 0 GOTO E_OAError
            		
					select @pos = @pos + 255
					
				end
            
				exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
														''CheckIn_StoredProcedure'',
														NULL,
														@sProjectName = @vchProjectName,
														@sSourceSafeINI = @vchSourceSafeINI,
														@sServerName = @vchServerName,
														@sDatabaseName = @vchDatabaseName,
														@sObjectName = @vchObjectName,
														@sComment = @vchComment,
														@sLoginName = @vchLoginName,
														@sPassword = @vchPassword,
														@iVCSFlags = @iVCSFlags,
														@iActionFlag = @iActionFlag,
														@sStream = ''''
                                        
			end
        end
        else
        begin
        
            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin                
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = master.dbo.sp_OAMethod @iStreamObjectId, ''AddStream'', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255                  
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
													''CheckIn_StoredProcedure'',
													NULL,
													@sProjectName = @vchProjectName,
													@sSourceSafeINI = @vchSourceSafeINI,
													@sServerName = @vchServerName,
													@sDatabaseName = @vchDatabaseName,
													@sObjectName = @vchObjectName,
													@sComment = @vchComment,
													@sLoginName = @vchLoginName,
													@sPassword = @vchPassword,
													@iVCSFlags = @iVCSFlags,
													@iActionFlag = @iActionFlag,
													@sStream = ''''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
	return

E_Compile_Fail:
	declare @lerror int
	select @lerror = @@error
	rollback tran compile_all
	RAISERROR (@lerror,16,-1)
	goto CleanUp

E_OAError:
	if @iActionFlag = 1 rollback tran compile_all
	exec dbo.dt_displayoaerror @iObjectId, @iReturn
	goto CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_removefromsourcecontrol]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[dt_removefromsourcecontrol]

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = ''VCSProjectID'')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_setpropertybyid_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
create procedure [dbo].[dt_setpropertybyid_u]
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if ''DtgSchemaNAME'' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_AssertionsView]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_AssertionsView]
AS
SELECT     dbo.Assertions.ID, dbo.Assertions.Name, dbo.Assertions.Description, dbo.Assertions.OwnerUserID, dbo.Users.Username AS OwnerUsername, 
                      Images_1.filename AS ThumbnailFilename, dbo.Assertions.Created, dbo.vw_AssertionTotalOpinions.TotalOpinions AS NumberOfOpinions, 
                      dbo.Assertions.FirstPublished, dbo.Assertions.IsPublished, dbo.Assertions.IsSuspended, dbo.Assertions.IsActive, 
                      dbo.AssertionTargetSites.SiteID
FROM         dbo.AssertionTargetSites INNER JOIN
                      dbo.Assertions INNER JOIN
                      dbo.Users ON dbo.Assertions.OwnerUserID = dbo.Users.ID ON dbo.AssertionTargetSites.AssertionID = dbo.Assertions.ID LEFT OUTER JOIN
                      dbo.Images Images_1 INNER JOIN
                      dbo.Images Images_2 ON Images_1.ID = Images_2.ThumbnailID ON dbo.Assertions.ImageID = Images_2.ID LEFT OUTER JOIN
                      dbo.vw_AssertionTotalOpinions ON dbo.Assertions.ID = dbo.vw_AssertionTotalOpinions.AssertionID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_PopularTracks]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_PopularTracks]
AS
SELECT     TOP 100 PERCENT dbo.vw_TrackTotalPlays.TotalPlays, dbo.Tracks.Title, dbo.Tracks.ArtistName, dbo.Users.Username, 
                      dbo.vw_TrackTotalPlays.TrackID
FROM         dbo.Users RIGHT OUTER JOIN
                      dbo.Tracks ON dbo.Users.ID = dbo.Tracks.UserID LEFT OUTER JOIN
                      dbo.vw_TrackTotalPlays ON dbo.Tracks.ID = dbo.vw_TrackTotalPlays.TrackID
ORDER BY dbo.vw_TrackTotalPlays.TotalPlays DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users (dbo)"
            Begin Extent = 
               Top = 6
               Left = 418
               Bottom = 121
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Tracks (dbo)"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 326
               Right = 380
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_TrackTotalPlays (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 297
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 6
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_PopularTracks'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_PopularTracks'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_addtosourcecontrol]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_addtosourcecontrol]
    @vchSourceSafeINI varchar(255) = '''',
    @vchProjectName   varchar(255) ='''',
    @vchComment       varchar(255) ='''',
    @vchLoginName     varchar(255) ='''',
    @vchPassword      varchar(255) =''''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = ''SQLVersionControl.VCS_SQL''

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = master.dbo.sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = master.dbo.sp_OAMethod @iObjectId,
											''AddProjectToSourceSafe'',
											NULL,
											@vchSourceSafeINI,
											@vchProjectName output,
											@@SERVERNAME,
											@vchDatabaseName,
											@vchLoginName,
											@vchPassword,
											@vchComment


    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs ''VCSProjectID''

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, ''VCSProjectID'', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, ''VCSProject'' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, ''VCSSourceSafeINI'' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, ''VCSSQLServer'', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, ''VCSSQLDatabase'', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties
    
    select @iObjectCount = 0;

CleanUp:
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_getpropertiesbyid_vcs_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[dt_getpropertiesbyid_vcs_u]
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    -- This procedure should no longer be called;  dt_getpropertiesbyid_vcsshould be called instead.
	-- Calls are forwarded to dt_getpropertiesbyid_vcs to maintain backward compatibility.
	set nocount on
    exec dbo.dt_getpropertiesbyid_vcs
		@id,
		@property,
		@value output

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_LatestRatings]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_LatestRatings]
AS
SELECT     TOP 100 PERCENT *
FROM         dbo.vw_Ratings
ORDER BY Created DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_Ratings (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 8
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestRatings'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_LatestRatings'

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSite]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetSite]

@ID uniqueidentifier,
@URL varchar (100)

as



if @ID = null

begin

set @ID = (select  id from Sites where url=@URL)

end


Select id,LocationID,URL, name,description from Sites  where ((@URL is null) or (URL like @URL))



SELECT    ID, Name, CountryId, Created
FROM         vw_TownsView

where SiteId = @ID order by Name' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[rpt_TrackStats]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[rpt_TrackStats]
AS
SELECT     dbo.rpt_PopularTracks.TotalPlays, dbo.rpt_PopularTracks.Title, dbo.rpt_PopularTracks.ArtistName, dbo.vw_RatingsStatistics.NumVotes
FROM         dbo.rpt_PopularTracks INNER JOIN
                      dbo.vw_RatingsStatistics ON dbo.rpt_PopularTracks.TrackID = dbo.vw_RatingsStatistics.SubjectListenToTypeID
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "rpt_PopularTracks (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_RatingsStatistics (dbo)"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 5
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_TrackStats'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'rpt_TrackStats'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Chart]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vw_Chart]
AS
SELECT     TOP 100 PERCENT dbo.vw_Chart_Ratings.SubjectListenToTypeID, dbo.vw_Chart_Ratings.TotalScore + COUNT(dbo.Plays.IP) AS TotalScore, 
                      dbo.vw_Chart_Ratings.NumRatings
FROM         dbo.vw_Chart_Ratings INNER JOIN
                      dbo.Plays ON dbo.vw_Chart_Ratings.SubjectListenToTypeID = dbo.Plays.TrackID
WHERE     (dbo.Plays.Created > CONVERT(DATETIME, ''2005-08-08 00:00:00'', 102))
GROUP BY dbo.vw_Chart_Ratings.SubjectListenToTypeID, dbo.vw_Chart_Ratings.TotalScore, dbo.vw_Chart_Ratings.NumRatings
ORDER BY dbo.vw_Chart_Ratings.TotalScore DESC
' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_Chart_Ratings (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 183
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Plays (dbo)"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 219
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
      Begin ColumnWidths = 4
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_Chart'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vw_Chart'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_addtosourcecontrol_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_addtosourcecontrol_u]
    @vchSourceSafeINI nvarchar(255) = '''',
    @vchProjectName   nvarchar(255) ='''',
    @vchComment       nvarchar(255) ='''',
    @vchLoginName     nvarchar(255) ='''',
    @vchPassword      nvarchar(255) =''''

as
	-- This procedure should no longer be called;  dt_addtosourcecontrol should be called instead.
	-- Calls are forwarded to dt_addtosourcecontrol to maintain backward compatibility
	set nocount on
	exec dbo.dt_addtosourcecontrol 
		@vchSourceSafeINI, 
		@vchProjectName, 
		@vchComment, 
		@vchLoginName, 
		@vchPassword


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_checkinobject_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_checkinobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='''',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='''',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     text = '''',  /* drop stream   */ /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     text = '''',  /* create stream */
    @txStream3     text = ''''   /* grant stream  */

as	
	-- This procedure should no longer be called;  dt_checkinobject should be called instead.
	-- Calls are forwarded to dt_checkinobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkinobject
		@chObjectType,
		@vchObjectName,
		@vchComment,
		@vchLoginName,
		@vchPassword,
		@iVCSFlags,
		@iActionFlag,   
		@txStream1,		
		@txStream2,		
		@txStream3		


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_checkoutobject_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_checkoutobject_u]
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

	-- This procedure should no longer be called;  dt_checkoutobject should be called instead.
	-- Calls are forwarded to dt_checkoutobject to maintain backward compatibility.
	set nocount on
	exec dbo.dt_checkoutobject
		@chObjectType,  
		@vchObjectName, 
		@vchComment,    
		@vchLoginName,  
		@vchPassword,  
		@iVCSFlags,    
		@iActionFlag 


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_isundersourcecontrol_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_isundersourcecontrol_u]
    @vchLoginName nvarchar(255) = '''',
    @vchPassword  nvarchar(255) = '''',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as
	-- This procedure should no longer be called;  dt_isundersourcecontrol should be called instead.
	-- Calls are forwarded to dt_isundersourcecontrol to maintain backward compatibility.
	set nocount on
	exec dbo.dt_isundersourcecontrol
		@vchLoginName,
		@vchPassword,
		@iWhoToo 


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_validateloginparams_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_validateloginparams_u]
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

	-- This procedure should no longer be called;  dt_validateloginparams should be called instead.
	-- Calls are forwarded to dt_validateloginparams to maintain backward compatibility.
	set nocount on
	exec dbo.dt_validateloginparams
		@vchLoginName,
		@vchPassword 


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dt_whocheckedout_u]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[dt_whocheckedout_u]
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

	-- This procedure should no longer be called;  dt_whocheckedout should be called instead.
	-- Calls are forwarded to dt_whocheckedout to maintain backward compatibility.
	set nocount on
	exec dbo.dt_whocheckedout
		@chObjectType, 
		@vchObjectName,
		@vchLoginName, 
		@vchPassword  


' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UsersPreferredStyles_Styles]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersPreferredStyles]'))
ALTER TABLE [dbo].[UsersPreferredStyles]  WITH CHECK ADD  CONSTRAINT [FK_UsersPreferredStyles_Styles] FOREIGN KEY([StyleID])
REFERENCES [dbo].[Styles] ([ID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UsersPreferredStyles_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersPreferredStyles]'))
ALTER TABLE [dbo].[UsersPreferredStyles]  WITH NOCHECK ADD  CONSTRAINT [FK_UsersPreferredStyles_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[UsersPreferredStyles] CHECK CONSTRAINT [FK_UsersPreferredStyles_Users]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Acts_Gigs]') AND parent_object_id = OBJECT_ID(N'[dbo].[Acts]'))
ALTER TABLE [dbo].[Acts]  WITH NOCHECK ADD  CONSTRAINT [FK_Acts_Gigs] FOREIGN KEY([GigID])
REFERENCES [dbo].[Gigs] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Acts] CHECK CONSTRAINT [FK_Acts_Gigs]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Comments_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Comments]'))
ALTER TABLE [dbo].[Comments]  WITH NOCHECK ADD  CONSTRAINT [FK_Comments_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Users]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Artists_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Artists]'))
ALTER TABLE [dbo].[Artists]  WITH NOCHECK ADD  CONSTRAINT [FK_Artists_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Artists] CHECK CONSTRAINT [FK_Artists_Users]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Towns_Countries]') AND parent_object_id = OBJECT_ID(N'[dbo].[Towns]'))
ALTER TABLE [dbo].[Towns]  WITH CHECK ADD  CONSTRAINT [FK_Towns_Countries] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Countries] ([ID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Sites_Locations]') AND parent_object_id = OBJECT_ID(N'[dbo].[Sites]'))
ALTER TABLE [dbo].[Sites]  WITH NOCHECK ADD  CONSTRAINT [FK_Sites_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([ID])
GO
ALTER TABLE [dbo].[Sites] CHECK CONSTRAINT [FK_Sites_Locations]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Venues_Locations]') AND parent_object_id = OBJECT_ID(N'[dbo].[Venues]'))
ALTER TABLE [dbo].[Venues]  WITH NOCHECK ADD  CONSTRAINT [FK_Venues_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Venues] CHECK CONSTRAINT [FK_Venues_Locations]
