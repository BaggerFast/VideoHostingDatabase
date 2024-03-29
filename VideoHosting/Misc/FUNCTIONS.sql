-------------------------------------------------------------------------------------------------
-- FUNCTIONS_STRUCTURE
-------------------------------------------------------------------------------------------------
USE VideoHosting;

PRINT N'➕ FUNCTION JOB IS STARTED';

GO
CREATE or ALTER FUNCTION dbo.GET_USER_FOLLOWERS_COUNT(@USER_NAME NVARCHAR(32))
RETURNS INTEGER AS
BEGIN
    RETURN (SELECT COUNT(*) FROM [SUBSCRIPTIONS] WHERE [TO_USER_UID] = (SELECT [USERS].[UID] FROM [USERS] WHERE [USERNAME] = @USER_NAME))
END
GO
PRINT N'➕ GET_USER_FOLLOWERS_COUNT WAS CREATED';


GO
CREATE or ALTER FUNCTION dbo.GET_VIDEO_REACTION_PERCENT(@VIDEO_TITLE NVARCHAR(100))
RETURNS INTEGER AS
BEGIN
    DECLARE @REACTION_PERCENT INTEGER = 0;
    DECLARE @REACTION_LIKED INTEGER = 0;
    DECLARE @ALL_REACTIONS INTEGER = 0;

    SET @REACTION_LIKED = (SELECT COUNT(*) FROM [REACTIONS]
        WHERE [IS_LIKED] = 1 AND [VIDEO_UID] = (SELECT [VIDEOS].[UID] FROM [VIDEOS] WHERE [TITLE] = @VIDEO_TITLE))
    SET @ALL_REACTIONS = (SELECT COUNT(*) FROM [REACTIONS] 
        WHERE [VIDEO_UID] = (SELECT [VIDEOS].[UID] FROM [VIDEOS] WHERE [TITLE] = @VIDEO_TITLE))
    IF (@ALL_REACTIONS = 0)
        RETURN 0;
    SET @REACTION_PERCENT = CAST(@REACTION_LIKED AS FLOAT)  / @ALL_REACTIONS * 100;
    RETURN @REACTION_PERCENT;
END
GO
PRINT N'➕ GET_VIDEO_REACTION_PERCENT WAS CREATED';