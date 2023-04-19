-------------------------------------------------------------------------------------------------
-- ACCESS_LEVELS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] =  N'ACCESS_LEVELS') BEGIN
	PRINT N'❌ TABLE [ACCESS_LEVELS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
		[ACCESS].[UID],
        [ACCESS].[TITLE]
	FROM [ACCESS_LEVELS] [ACCESS]
	ORDER BY [ACCESS].[TITLE];
END;
