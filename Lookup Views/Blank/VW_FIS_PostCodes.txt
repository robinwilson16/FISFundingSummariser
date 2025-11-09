CREATE VIEW [dbo].[VW_FIS_PostCodes]
AS
	SELECT
		PostCode = PCW.pcd8,
		WardCode = PCW.wd11cd,
		WardName = PCW.wd11nm,
		DistrictCode = PCW.par11cd,
		DistrictName = PCW.par11nm,
		LEACode = PCW.lad11cd,
		LEAName = PCW.lad11nm,
		SourceOfFunding = PCU.SofCOde,
		DisadvUplift = COALESCE ( CAST ( PCU.DisadvantageFactor AS DECIMAL(6, 5) ), 1 )
	FROM PostCodeWard PCW
	LEFT JOIN PostCodeDisadvUplift PCU
		ON PCU.Postcode = PCW.pcd8