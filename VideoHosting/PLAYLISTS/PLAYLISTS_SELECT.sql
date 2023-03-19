-------------------------------------------------------------------------------------------------
-- VIDEOS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'VIDEOS') BEGIN
	PRINT N'❌ TABLE [VIDEOS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[PLAYLIST].[UID],
        [PLAYLIST].[TITLE],
        [PLAYLIST].[DESCRIPTION],
        [USER].[USERNAME] [USER],
        [ACCESS].[TITLE] [ACCESS],
        [PLAYLIST].[CREATED_DT]
	FROM [VIDEOS] [PLAYLIST]
    LEFT JOIN [USERS] [USER] ON [PLAYLIST].[USER_UID]=[USER].[UID]
	LEFT JOIN [ACCESS_LEVELS] [ACCESS] ON [PLAYLIST].[ACCESS_UID]=[ACCESS].[UID]
	ORDER BY [PLAYLIST].[USER_UID];
END;
