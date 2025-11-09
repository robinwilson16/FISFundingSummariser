CREATE VIEW [dbo].[VW_FIS_CourseHours]
AS
	SELECT
		AcademicYear = CAST ( NULL AS NVARCHAR(50) ),
		ProvSpecValue = CAST ( NULL AS NVARCHAR(50) ),
		CourseCode = CAST ( NULL AS NVARCHAR(50) ),
		PlannedHours = 0,
		EEPHours = 0,
		TLevelHours = 0