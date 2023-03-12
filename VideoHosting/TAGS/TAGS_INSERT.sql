-------------------------------------------------------------------------------------------------
-- TAGS_INSERT
-------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

DECLARE @DB_NAME VARCHAR(128) = 'VideoHosting';
DECLARE @DB_NAME_CURRENT VARCHAR(128) = NULL;
DECLARE @IS_COMMIT BIT = 0;
-------------------------------------------------------------------------------------------------