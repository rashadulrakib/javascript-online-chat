USE [LinqChat]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Firstname] [varchar](30) NULL,
	[Lastname] [varchar](30) NULL,
	[Username] [varchar](30) NULL,
	[Password] [varchar](30) NULL,
	[Sex] [varchar](1) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Room]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Room](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoggedInUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LoggedInUser](
	[LoggedInUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[RoomID] [int] NULL,
	[UserSessionID] [varchar](50) NULL,
 CONSTRAINT [PK_LoggedInUser] PRIMARY KEY CLUSTERED 
(
	[LoggedInUserID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Message]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Message](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[RoomID] [int] NULL,
	[UserID] [int] NULL,
	[ToUserID] [int] NULL,
	[Text] [varchar](100) NULL,
	[TimeStamp] [datetime] NULL CONSTRAINT [DF_Message_TimeStamp]  DEFAULT (getdate()),
	[Color] [varchar](50) NULL,
	[MessageStatus] [varchar](50) NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LoggedInUser_Room]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoggedInUser]'))
ALTER TABLE [dbo].[LoggedInUser]  WITH CHECK ADD  CONSTRAINT [FK_LoggedInUser_Room] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[LoggedInUser] CHECK CONSTRAINT [FK_LoggedInUser_Room]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LoggedInUser_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoggedInUser]'))
ALTER TABLE [dbo].[LoggedInUser]  WITH CHECK ADD  CONSTRAINT [FK_LoggedInUser_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[LoggedInUser] CHECK CONSTRAINT [FK_LoggedInUser_User]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Message_Room]') AND parent_object_id = OBJECT_ID(N'[dbo].[Message]'))
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Room] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Room]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Message_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[Message]'))
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_User]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Message_User1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Message]'))
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_User1] FOREIGN KEY([ToUserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_User1]
