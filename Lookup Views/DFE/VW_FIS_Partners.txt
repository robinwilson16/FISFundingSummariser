CREATE VIEW [dbo].[VW_FIS_Partners]
AS
	SELECT
		PartnerUKPRN = PRV.UKPRN,
		PartnerName = PRV.VIEW_NAME
	FROM Providers PRV
	WHERE
		LEN ( PRV.UKPRN ) >= 1