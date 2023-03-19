-------------------------------------------------------------------------------------------------
-- VIEWS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'VIEWS') BEGIN
	PRINT N'❌ TABLE [VIEWS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[VIEW].[UID],
        [VIDEO].[TITLE] [VIDEO TITLE],
        [USER].[USERNAME] [USER],
        [VIEW].[CREATED_DT]
	FROM [VIEWS] [VIEW]
    LEFT JOIN [USERS] [USER] ON [VIEW].[USER_UID]=[USER].[UID]
    LEFT JOIN [VIDEOS] [VIDEO] ON [VIEW].[VIDEO_UID]=[VIDEO].[UID]
	ORDER BY [VIEW].[CREATED_DT];
END;
