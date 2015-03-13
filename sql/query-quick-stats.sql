Use EbolaQC

--display the current day of the import
select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3)
GO

/*
Quick query to review a new day's import
*/
select epicasedef, convert(varchar(10),DateReport,103) as "DateReportF", count(*)
 from DBExtractView
 where epicasedef in (0,1,2,3)
 group by epicasedef, datereport
 order by datereport desc

/*
quick check by district
*/
select epicasedef, districtres, count(*)
 from DBExtractView
 where epicasedef in (1,2,3)
	and datereport = (select max(datereport) from DBExtractView where epicasedef in (1,2,3))
 group by rollup(epicasedef, districtres)
 order by districtres asc