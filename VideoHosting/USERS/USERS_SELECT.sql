-------------------------------------------------------------------------------------------------
-- USERS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'USERS') BEGIN
	PRINT N'❌ TABLE [USERS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[USER].[UID],
        [USER].[USERNAME],
        [USER].[EMAIL],
        [USER].[BIRTHDAY_DT],
        [USER].[CREATED_DT] [REGISTER_DT]
	FROM [USERS] [USER]
	ORDER BY [USER].[USERNAME];
END;
