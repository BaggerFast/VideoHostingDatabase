-------------------------------------------------------------------------------------------------
-- SUBSCRIPTIONS_SELECT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-------------------------------------------------------------------------------------------------
USE VideoHosting;

IF NOT EXISTS (SELECT 1 FROM [sys].[tables] WHERE [name] = N'SUBSCRIPTIONS') BEGIN
	PRINT N'❌ TABLE [SUBSCRIPTIONS] WAS NOT FOUND';
END ELSE BEGIN
	SELECT
    	[SUBSCRIPTION].[UID],
        [FROM_USER].[USERNAME] [FROM USER],
        [TO_USER].[USERNAME] [TO USER],
        [SUBSCRIPTION].[CREATED_DT]
	FROM [SUBSCRIPTIONS] [SUBSCRIPTION]
    LEFT JOIN [USERS] [TO_USER] ON [SUBSCRIPTION].[TO_USER_UID] = [TO_USER].[UID]
    LEFT JOIN [USERS] [FROM_USER] ON [SUBSCRIPTION].[FROM_USER_UID] = [FROM_USER].[UID]
	ORDER BY [SUBSCRIPTION].[CREATED_DT];
END;
