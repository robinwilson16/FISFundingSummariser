CREATE VIEW [dbo].[VW_FIS_Standards]
AS
	SELECT
		StandardCode = STD.StandardCode,
		StandardName = STD.StandardName
	FROM LARS.dbo.Core_LARS_Standard STD