CREATE VIEW [dbo].[VW_FIS_Providers]
AS
	SELECT
		ProviderUKPRN = PRV.UKPRN,
		ProviderName = PRV.VIEW_NAME
	FROM Providers PRV
	WHERE
		LEN ( PRV.UKPRN ) >= 1