## Summary
The FIS Funding Summariser can be used to transform a FIS database into a single table that is simple and fast to report on that can hold multiple FIS datasets at the same time.

The functionality is contained within 3 stored procedures:
| Stored Procedure | Purpose |
|--|--|
| EXEC SPR_FIS_GenerateFundingData 2021.txt | This executes the procedure that copies data from the FIS into the flat table and where options can be specified such as the return number  |
| SPR_FIS_GenerateFundingData.txt | Called by the exec stored procedure above and responsible for either apending to or creating the FIS_FundingData table where the FIS data is stored
| SPR_FIS_FundingData_XXXX.txt | Called by the stored procedure above (where XXXX is the academic year) and is responsible for outputting the data from the FIS and inserting it into the table created by the stored procedure above


## Setting Up


Firstly create the data tables and views in either **Install/Default Lookup Data** or if you have ProSolution then use **Install/ProSolution Lookup Data** (these scripts may need customising - i.e. depending on the number of levels of college structure)
| Table | Purpose |
|--|--|
| FIS_CollegeStructure | Creates the college structure to map course codes to college structure for teams and faculties |
| FIS_CourseHours | Contains course codes and the planned hours |
| FIS_DestinationProgressionOutcomes | Contains the lookups for destination codes |
| FIS_Disabilities | Contains the lookups for disability codes |
| FIS_Employers | Maps EDRS numbers to employer names |
| FIS_Ethnicities | Contains the lookups for ethnicity codes |
| FIS_Frameworks | Contains the lookups for framework codes |
| FIS_LearningAims | Contains the learning aim details for learning aim codes |
| FIS_Partners | Maps EDRS numbers to partner names |
| FIS_Pathways | Contains the pathway title for framework codes and programme type codes  |
| FIS_PostCodes | Contains post code uplift and local authority details for post codes |
| FIS_Providers | Contains the lookups for provider codes |
| FIS_Standards | Contains the lookups for standard codes |

Next in the main **Install** folder create the stored procedures that use data from the lookups created above, and the uploaded FIS database by running the scripts:
 - SPR_FIS_FundingData_1718
 - SPR_FIS_FundingData_1819
 - SPR_FIS_FundingData_1920
 - SPR_FIS_FundingData_2021
 - SPR_FIS_GenerateFundingData


## Generating an ILR using the ESFA FIS Tool

Run the FIS tool from the ESFA, go into settings ensuring Export to SQL is ticked (prior to 19/20 an MDB ILR needs to be uploaded using the SSMS Import Wizard)
The FIS should create a database called **ILRXXXX** (where XXXX is the academic year) unless you have renamed it (possible from 21/22 onwards).
> If you wish to you could rename the database and data files in order to keep a copy of this database although once imported by the script above there should be no need.


## Running the FIS Funding Summariser

Go to the Run folder and open the EXEC script for the corresponding year (there is more than one example as different colleges require some different calculations).

When run this script will export data from the FIS database and insert it into a new table called **FIS_FundingData** (unless you changed this in the script - not recommended)

This script has a number of parameters where each has a comment to explain what it does. If you are not sure if you need to perform something then it is probably best to set it to No. The scripts without 3 letters on the end are the most generic and probably best to start with.

> You may wish to create an SQL Server Agent job with this EXEC code in which would then mean anyone could run this SQL task in order to import the data.

To confirm data is correct you may wish to validate totals against the funding reports.

An example query to check data could be as follows

--- sql
SELECT
	FD.FundLineSummary,
	FD.FundLineDetail,
	TotFundYrEnd = SUM ( FD.TotFundYrEnd )
FROM FIS_FundingData FD
WHERE
	FD.AcademicYear = '20/21'
	AND FD.ILRReturn = 'R04'
	AND FD.IsFinalReturn = 1
	AND FD.IsFunded = 1
GROUP BY
	FD.FundLineSummary,
	FD.FundLineDetail
ORDER BY
	FD.FundLineSummary,
	FD.FundLineDetail
---