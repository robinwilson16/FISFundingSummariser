CREATE VIEW [dbo].[VW_FIS_CollegeStructure]
AS
	SELECT
		AcademicYear = CAST ( NULL AS VARCHAR(50) ),
		ProvSpecValue = CAST ( NULL AS VARCHAR(50) ),
		CourseCode = CAST ( NULL AS VARCHAR(50) ),
		CourseInstance = CAST ( NULL AS VARCHAR(50) ),
		CourseTitle = CAST ( NULL AS VARCHAR(50) ),
		CollegeLevel1Code = '-',
		CollegeLevel1Name = '-- Unknown --',
		CollegeLevel2Code = '-',
		CollegeLevel2Name = '-- Unknown --',
		CollegeLevel3Code = '-',
		CollegeLevel3Name = '-- Unknown --',
		CollegeLevel4Code = '-',
		CollegeLevel4Name = '-- Unknown --'