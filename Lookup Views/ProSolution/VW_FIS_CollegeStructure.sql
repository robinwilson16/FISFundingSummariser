CREATE OR ALTER VIEW [dbo].[VW_FIS_CollegeStructure]
AS
    SELECT DISTINCT
		AcademicYear = CRS.AcademicYearID,
		ProvSpecValue = CRS.Code,
		CourseCode = CRS.Code,
		CourseInstance = NULL,
		CourseTitle = CRS.Name,
		CampusCode = COALESCE ( STE.Code, '-' ),
		CampusName = COALESCE ( STE.Description, '-- Unknown --' ),
		CollegeLevel1Code = COALESCE ( RTRIM ( COL1.Code ), '-' ),
		CollegeLevel1Name = COALESCE ( COL1.Name, '-- Unknown --' ),
		CollegeLevel2Code = COALESCE ( RTRIM ( COL2.Code ), '-' ),
		CollegeLevel2Name = COALESCE ( COL2.Name, '-- Unknown --' ),
		CollegeLevel3Code = COALESCE ( RTRIM ( COL3.Code ), '-' ),
		CollegeLevel3Name = COALESCE ( COL3.Name, '-- Unknown --' ),
		CollegeLevel4Code = COALESCE ( RTRIM ( COL4.Code ), '-' ),
		CollegeLevel4Name = COALESCE ( COL4.Name, '-- Unknown --' )
	FROM ProSolution.dbo.Offering CRS
	LEFT JOIN ProSolution.dbo.Site STE
		ON STE.SiteID = CRS.SiteID
	LEFT JOIN ProSolution.dbo.CollegeLevel COL4
		ON COL4.SID = CRS.SID
	LEFT JOIN ProSolution.dbo.CollegeLevel COL3
		ON COL3.SID = COL4.ParentSID
	LEFT JOIN ProSolution.dbo.CollegeLevel COL2
		ON COL2.SID = COL3.ParentSID
	LEFT JOIN ProSolution.dbo.CollegeLevel COL1
		ON COL1.SID = COL2.ParentSID