-------------------------------------------------------------------------------------------------
-- AGE_RESTRICTIONS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'AGE_RESTRICTIONS') BEGIN
	PRINT N'❌ TABLE [AGE_RESTRICTIONS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
        [AGE_REST].[UID],
        [AGE_REST].[AGE]
	FROM [AGE_RESTRICTIONS] [AGE_REST]
	ORDER BY [AGE_REST].[AGE];
END;
