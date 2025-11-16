CREATE VIEW [dbo].[VW_FIS_Frameworks]
AS
	SELECT DISTINCT
		FrameworkCode = FW.FworkCode,
		FrameworkName = FW.NASTitle
	FROM LARS.dbo.Core_LARS_Framework FW