-------------------------------------------------------------------------------------------------
-- COMMENTS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'COMMENTS') BEGIN
	PRINT N'❌ TABLE [COMMENTS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[COMMENT].[UID],
        [COMMENT].[TEXT],
        [USER].[USERNAME] [USER],
        [VIDEO].[TITLE] [VIDEO TITLE],
        [COMMENT].[CREATED_DT]
	FROM [COMMENTS] [COMMENT]
    LEFT JOIN [USERS] [USER] ON [COMMENT].[USER_UID]=[USER].[UID]
    LEFT JOIN [VIDEOS] [VIDEO] ON [COMMENT].[VIDEO_UID]=[VIDEO].[UID]
	ORDER BY [USER].[USERNAME];
END;
