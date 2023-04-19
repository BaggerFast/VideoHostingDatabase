-------------------------------------------------------------------------------------------------
-- REACTIONS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'REACTIONS') BEGIN
	PRINT N'❌ TABLE [REACTIONS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[REACTION].[UID],
        [REACTION].[IS_LIKED],
        [USER].[USERNAME] [USER],
        [VIDEO].[TITLE] [VIDEO TITLE],
        [REACTION].[CREATED_DT]
	FROM [REACTIONS] [REACTION]
    LEFT JOIN [USERS] [USER] ON [REACTION].[USER_UID]=[USER].[UID]
    LEFT JOIN [VIDEOS] [VIDEO] ON [REACTION].[VIDEO_UID]=[VIDEO].[UID]
	ORDER BY [REACTION].[CREATED_DT];
END;
