CREATE OR ALTER VIEW VW_FIS_Frameworks
AS
	SELECT DISTINCT
		FrameworkCode = FW.Framework_Code,
		FrameworkName = FW.Framework_Desc
	FROM [dbs-mis-02\advanced].ProGeneral.dbo.Frameworks_QSR FW