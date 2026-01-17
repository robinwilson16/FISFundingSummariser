# FIS Funding Summariser

## Summary

The FIS Funding Summariser pulls together information across the FIS database tables and summarises this by enrolment, supporting FIS database formats from 17/18 up to 25/26.

This script transforms a FIS database into one large database table with one row per enrolment, making it easy for reporting teams to produce reports displaying this data.

The database table supports saving many ILR returns into the same table where you would then reference a particular one by the **Academic Year** and **ILR** return enabling the same suite of reports to be run for any year and not need re-designing each time the format of the FIS database changes or having to have a seperate set of reports for each year


## Importing a FIS

Once you have everything set up you can execute the following command to import a FIS ILR database:

	EXEC SPR_Run_FIS_FundingData 'ILR2526', '25/26', 'R05', 1, 'I'

Broken down this is:

| Command | Purpose |
|--|--|
| EXEC SPR_Run_FIS_FundingData | Run the stored procedure |
| 'ILR2526' | Name of the ILR database created by FIS |
| '25/26' | The academic year of the ILR return being imported |
| 'R05' | The ILR return number |
| 1 | If this is the final return for this *RXX* ILR return period as the database can hold multiple datasets for each return |
| 'I' | Whether to add the new data to existing data or clear out the table and start again - [R]eplace/[I]nsert Data |


## Viewing/Validating the Output

Once you have imported your ILR you should now check the totals match the FIS reports.
The easiest way to achieve this is by querying the data, grouping by the funding lines and totaling the **total cash earned column**
If everything matches then all reports based on this output should therefore also match.
This SQL query shows the funding:

~~~~sql
DECLARE @AcademicYear NVARCHAR(5) = '25/26'
DECLARE @ILRReturn NVARCHAR(3) = 'R05'
DECLARE @IsFinalReturn BIT = 1


SELECT
	FD.FundLineCategoryOrder,
	FD.FundLineCategory,
	FD.FundLineSubCategoryOrder,
	FundLineSubCategory,
	FD.FundLine,
	Learners = COUNT ( DISTINCT FD.LearnRefNumber ),
	Enrolments = COUNT ( FD.LearnRefNumber ),
	TotalEarnedCash = SUM ( FD.TotalEarnedCashYearEnd )
FROM FIS_FundingData FD
WHERE
	FD.AcademicYear = @AcademicYear
	AND FD.ILRReturn = @ILRReturn
	AND FD.IsFinalReturn = @IsFinalReturn
	--AND FD.IsFundedStart = 1
GROUP BY
	FD.FundLineCategoryOrder,
	FD.FundLineCategory,
	FD.FundLineSubCategoryOrder,
	FD.FundLineSubCategory,
	FD.FundLine
ORDER BY
	FD.FundLineCategoryOrder,
	FD.FundLineSubCategoryOrder,
	FD.FundLineSubCategory,
	FD.FundLine
~~~~

This should give you output similar to the this:
| Category | Sub Category | Fund Line | Learners | Enrolments | Total Earned Cash
|--|--|--|--|--|--|
16-19 Funding | Study Programmes | 16-19 Students (excluding High Needs Students) | 500 | 500 | £30,000
16-19 Funding | Study Programmes | 19+ Continuing Students (excluding EHCP) | 5 | 5 | £60,000
16-19 Funding | Study Programmes | 19-24 Students with an EHCP | 6 | 6 | £40,000
16-19 Funding | T Levels | 16-19 Students (excluding High Needs Students) | 50 | 50 | £50,000
16-19 Funding | T Levels | 19+ Continuing Students (excluding EHCP) | 5 | 5 | £60,000
16-19 Funding | T Levels | 19-24 Students with an EHCP | 1 | 1 | £10,000
16-19 Funding | T Levels | T Level programme | 55 | 200 | £0
Adult Skills Fund | DFE - ESFA | ESFA Adult Skills Fund core (non-procured) | 3 | 3 | £0
Adult Skills Fund | Devolved - NEMCA | DA/GLA Adult Skills Fund core (non-procured) | 300 | 500 | £40,000
Adult Skills Fund | Devolved - NEMCA | DA/GLA Adult Skills Fund free courses for jobs (non-procured) | 10 | 10 | £40,000
Adult Skills Fund | Devolved - TVCA | DA/GLA Adult Skills Fund core (non-procured) | 34 | 53 | £50,000
Advanced Learner Loan | Advanced Learner Loan | Advanced Learner Loan | 22 | 22 | £0
Apprenticeships | 16-18 Apprenticeships | 16-18 Apprenticeship (Employer on App Service) | 400 | 1,000 | £1,500,000
Apprenticeships | 19+ Apprenticeships | 19+ Apprenticeship (Employer on App Service) | 1,300 | 4,200 | £2,500,000
Higher Education | Higher Education | Higher Education | 500 | 500 | £0
Full Cost | Full Cost | Full Cost - Level 3 and Below | 400 | 600 | £0
Full Cost | Full Cost | Full Cost - Level 4 and Above | 30 | 30 | £0


## Best Practices

By default, when the SQL option is selected, the FIS will create a database called *ILRXXYY*, where XXYY is the academic year.

You may wish to change this name to *ILRXXYY_R04* and *ILRXXYY_R14* as a way to safe each database with the SQL Server database so you would not need to run these back through the FIS if you needed to re-import databases into the FIS Summariser or look back at the previous data yourself.


## Scripts Included In This Repository

The scripts are divided into different folders which are:
- Allocation and Target Tables
	- Contains empty tables for storing targets and overall allocations
- Lookup Views
	- Contains scripts to create views for different systems as lookups to bring in names and discriptions such as for the college structure
- Main Scripts
	- The main script for each academic year which are all slightly different to account for differences in the FIS databases over the years
	- Also contains a generate script which checks/refreshes the table before running and selecting the correct script depending on the year being imported into (based on the academic year parameter)
- Reports
	- Some quick and basic example reports showing how you can quickly check the total funding matches the FIS reports to validate the import was successful.
	- If you find values are too high check your lookup scripts in case a record is matching twice causing records to duplicate
- Run Import
	- Contains the settings script called *SPR_Run_FIS_FundingData* where you can amend various values such as the future achievement weighting factor or reapportioning the funding for FM25 across the various periods etc. See below for all settings that can be amended currently


## Lookup Database Views

| Table | Purpose |
|--|--|
| VW_FIS_CollegeStructure | Creates the college structure to map course codes to college structure for teams and faculties |
| VW_FIS_CourseHours | Contains course codes and the planned hours |
| VW_FIS_DestinationProgressionOutcomes | Contains the lookups for destination codes |
| VW_FIS_Disabilities | Contains the lookup values for disability codes |
| VW_FIS_Employers | Maps EDRS numbers to employer names |
| VW_FIS_Ethnicities | Contains the lookup values for ethnicity codes |
| VW_FIS_Frameworks | Contains the lookup values for apprenticeship framework codes |
| VW_FIS_LearningAims | Contains the learning aim details for learning aim codes |
| VW_FIS_Partners | Maps EDRS numbers to partner names |
| VW_FIS_Pathways | Contains the pathway title for framework codes and programme type codes  |
| VW_FIS_PostCodes | Contains post code uplift and local authority details for post codes |
| VW_FIS_PriorLevels | Contains the lookup values for prior level |
| VW_FIS_Providers | Contains the lookups for provider codes |
| VW_FIS_Standards | Contains the lookups for apprenticeship standard codes |


## Settings

You will see within the *SPR_Run_FIS_FundingData*, there are various more advanced settings that can be configured such as if you wish to adjust the future achievement weighting, reapportion the funding or specify which provider specified monitoring field/s contain the course code.

Each setting has a line of text explaining what it does:
~~~~sql
	/**************************************************
	 * Change/check values each time an import is run *
	 **************************************************/

	-- CHANGE THIS TO CORRECT RETURN
	--DECLARE @ILRReturn NVARCHAR(3) = 'R03' 

	-- IF FINAL RETURN SET THIS TO 1 - ensure only 1 return for each month is set to 1 for accurate year on year reporting
	--DECLARE @IsFinalReturn BIT = 1



	/***********************************************************************************
	 * Change values each year/month such as if ILR database is created as ILR2526_RXX *
	 ***********************************************************************************/

	--Name of the database created by the FIS software (default is ILRXXYY where XXYY is the return year)
	--DECLARE @FISDatabase NVARCHAR(100) = 'ILR2526' 

	--Academic year used for reporting outputs (e.g. XX/YY)
	--DECLARE @AcademicYear NVARCHAR(5) = '25/26' 



	/************************************************************
	 * Once set up values below should generally not be changed *
	 ************************************************************/

	--Split the funding into the 12 periods (default is 0 - 1 or 0)
	DECLARE @Split1619Funding BIT = 0 

	--Reapportion the 16-19 funding by the aim prog weighting factor (default is 0 - 1 or 0)
	DECLARE @Reapportion1619FundingByAimWeighting BIT = 0 

	--Move Apps Funding from Main ZProg to Main Component Aim so aim level fields can be used such as SSA (default is 1 - 1 or 0)
	DECLARE @AppsMoveFundingToMainComponentAim BIT = 1 

	--Deduct this percent from Total Cash Earned for FM25 and assign to ALS column (default is 0 - 1 or 0)
	DECLARE @1619ALSFundingPercent DECIMAL(5,2) = 0 

	--HE Gross Fee is only achieved if at all 3 SLC census points learners remain current (default is 0 - 1 or 0)
	DECLARE @IncludeHEAdvLoanPossibleIncome BIT = 0 

	--Adv Loan bursary income is not income as goes to learners so may want to exclude (default is 0 - 1 or 0)
	DECLARE @IncludeAdvLoanBursaryIncome BIT = 0 

	--Future achievement weighting factor. If 1 then is 100% of all remaining ach monies (default is 0 - decimal value)
	DECLARE @FutureAchievementWeighting DECIMAL(5,2) = 1

	--English and Maths Funding Rates from Allocation Statement
	DECLARE @EnglishMathsFundingHigherRate INT = 418
	DECLARE @EnglishMathsFundingLowerRate INT = 255

	--Core Maths Funding Rate from Allocation Statement
	DECLARE @CoreMathsPremiumFundingRate INT = 900

	--Block 2 Disadvantage Funding Rates for GCSE Maths and English Delivery Costs for Low Attainment Learners from Allocation Statement (Block 1 is Disad Post Codes)
	DECLARE @Block2DisadvFundingTLevelRate INT = 825
	DECLARE @Block2DisadvFundingHigherRate INT = 609
	DECLARE @Block2DisadvFundingLowerRate INT = 371

	--Advanced Maths Premium Funding Rate:
	--List of Quals at: 
	--https://www.gov.uk/guidance/16-to-19-funding-advanced-maths-premium#check-who-is-eligible-for-the-premium
	DECLARE @AdvancedMathsPremiumFundingRate INT = 900

	--Higher Value Course Premium Funding Rate from Allocation Statement
	--List of Quals at: 
	--https://www.gov.uk/government/publications/qualifications-attracting-high-value-courses-premium
	DECLARE @HighValueCoursesPremiumFundingRate INT = 600

	--Conditition of Funding Adjustments Based on Last Year's English and Maths Tolerances Being Hit
	DECLARE @ConditionOfFundingAdjustment INT = 0

	--Industry Placement Full Funding Rate (year 1 and 2)
	DECLARE @IndustryPlacementFullFundingRate INT = 550

	--Large Programme Uplift from Allocation Statement
	DECLARE @LargeProgramme10PercentUpliftNumLearners INT = 0
	DECLARE @LargeProgramme10PercentUpliftAmount INT = 510
	DECLARE @LargeProgramme20PercentUpliftNumLearners INT = 0
	DECLARE @LargeProgramme20PercentUpliftAmount INT = 1021

	--Insert new ILR return data leaving existing data from other imported returns or clear out table and replace (default is I for Insert, R = Replace)
	--DECLARE @Mode NCHAR(1) = 'I' 

	--Database to store the summarised table generated by this script (for a linked server use SERVER.DATABASE.SCHEMA (e.g. missrv.misdb.dbo.))
	DECLARE @FISOutputTableLocation NVARCHAR(200) = 'CollegeReportingDatabase.dbo.' 

	--Table to create/insert data into
	DECLARE @FISOutputTableName NVARCHAR(200) = 'FIS_FundingData'

	--Provider field/s where the course code is stored in your ILR data (if spread across 2 fields enter values for first and second, if stored in 1 leave second NULL)
	DECLARE @ProvSpecDelMonCourseLocation1 NCHAR(1) = 'A'
	DECLARE @ProvSpecDelMonCourseLocation2 NCHAR(1) = 'B'

	--Seperator used between two fields listed above to form the full unique course code (default is blank, only relevant if 2 locations specified for course code)
	DECLARE @ProvSpecDelMonCourseSeperator NVARCHAR(50) = '-'

	--Provider field/s where the parent/programme course is stored to facilitate grouping aims by the programme
	DECLARE @ProvSpecDelMonParentCourseLocation1 NCHAR(1) = NULL
	DECLARE @ProvSpecDelMonParentCourseLocation2 NCHAR(1) = NULL

	--Seperator used between two fields listed above to form the full unique parent/programme course code (default is blank, only relevant if 2 locations specified for parent/programme course code)
	DECLARE @ProvSpecDelMonParentCourseSeperator NVARCHAR(50) = NULL

	--Custom codes for overriding the different levels of structure to move English under that area and out of other curriculum areas
	DECLARE @EnglishCollegeLevel1Code NVARCHAR(50) = NULL
	DECLARE @EnglishCollegeLevel2Code NVARCHAR(50) = NULL
	DECLARE @EnglishCollegeLevel3Code NVARCHAR(50) = NULL
	DECLARE @EnglishCollegeLevel4Code NVARCHAR(50) = NULL

	--Custom codes for overriding the different levels of structure to move Maths under that area and out of other curriculum areas
	DECLARE @MathsCollegeLevel1Code NVARCHAR(50) = NULL
	DECLARE @MathsCollegeLevel2Code NVARCHAR(50) = NULL
	DECLARE @MathsCollegeLevel3Code NVARCHAR(50) = NULL
	DECLARE @MathsCollegeLevel4Code NVARCHAR(50) = NULL

	--Custom codes for overriding the different levels of structure to move franchised out delivery under that area and out of other curriculum areas
	DECLARE @PartnerCollegeLevel1Code NVARCHAR(50) = NULL
	DECLARE @PartnerCollegeLevel2Code NVARCHAR(50) = NULL
	DECLARE @PartnerCollegeLevel3Code NVARCHAR(50) = NULL
	DECLARE @PartnerCollegeLevel4Code NVARCHAR(50) = NULL

	--Calculate which records should be included in QAR measures for each year (replicates what Strata or ProAchieve would do)
	DECLARE @RunQARCalculation BIT = 1 

	--Anonymise ILR data
	DECLARE @AnonymiseData BIT = 0
~~~~