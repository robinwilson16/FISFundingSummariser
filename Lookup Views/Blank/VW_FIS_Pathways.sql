CREATE VIEW [dbo].[VW_FIS_Pathways]
AS
	SELECT
		FrameworkCode = FW.FworkCode,
		ProgType = FW.ProgType,
		PathwayCode = FW.PwayCode,
		PathwayName = FW.PathwayName
	FROM LARS.dbo.Core_LARS_Framework FW