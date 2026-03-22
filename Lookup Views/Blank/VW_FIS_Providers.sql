CREATE VIEW [dbo].[VW_FIS_Providers]
AS
	SELECT
		ProviderUKPRN = CAST ( NULL AS VARCHAR(50) ),
		ProviderName = CAST ( NULL AS VARCHAR(50) )