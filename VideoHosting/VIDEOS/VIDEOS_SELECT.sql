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
		[VIDEO].[UID],
        [VIDEO].[TITLE],
        [VIDEO].[DESCRIPTION],
        [USERS].[USERNAME] [USER],
        [AGE_REST].[AGE] [AGE_RESTRICTIONS],
        [ACCESS].[TITLE] [ACCESS],
        [VIDEO].[CREATED_DT] [CREATED_DT]
	FROM [VIDEOS] [VIDEO]
    LEFT JOIN [USERS] [USERS] ON [VIDEO].[USER_UID]=[USERS].[UID]
	LEFT JOIN [AGE_RESTRICTIONS] [AGE_REST] ON [VIDEO].[AGE_RESTRICTIONS_UID]=[AGE_REST].[UID]
    LEFT JOIN [ACCESS_LEVELS] [ACCESS] ON [VIDEO].[ACCESS_UID]=[ACCESS].[UID]
	ORDER BY [VIDEO].[CREATED_DT];
END;
