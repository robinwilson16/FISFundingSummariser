CREATE VIEW [dbo].[VW_FIS_Standards]
AS
	SELECT
		StandardCode = STD.StandardCode,
		StandardName = STD.StandardName
	FROM besql05.ProGeneral.dbo.Standard_QSR STD