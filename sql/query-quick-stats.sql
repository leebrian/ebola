Use EbolaQC

--display the current day of the import
select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3)
GO

select count(*) as Total,
	sum(case when epicasedef in (1,2,3) then 1 else 0 end) as TotalConfProbSusp,
	sum(case when epicasedef in (1) then 1 else 0 end) as TotalConfirmed,
	sum(case when epicasedef in (2) then 1 else 0 end) as TotalProbable,
	sum(case when epicasedef in (3) then 1 else 0 end) as TotalSuspect
 from DBExtractView
 where datereport = (select max(datereport) from DBExtractView where epicasedef in (1,2,3))

select DistrictRes,
	count(*) as TotalRecords,
	sum(case when epicasedef in (1,2,3) then 1 else 0 end) as TotalConfProbSusp,
	sum(case when epicasedef in (1) then 1 else 0 end) as TotalConfirmed,
	sum(case when epicasedef in (2) then 1 else 0 end) as TotalProbable,
	sum(case when epicasedef in (3) then 1 else 0 end) as TotalSuspect
 from DBExtractView
 where datereport = (select max(datereport) from DBExtractView where epicasedef in (1,2,3))
 group by DistrictRes
 order by TotalConfProbSusp desc, DistrictRes asc

 select SCRes,
	count(*) as TotalRecords,
	sum(case when epicasedef in (1,2,3) then 1 else 0 end) as TotalConfProbSusp,
	sum(case when epicasedef in (1) then 1 else 0 end) as TotalConfirmed,
	sum(case when epicasedef in (2) then 1 else 0 end) as TotalProbable,
	sum(case when epicasedef in (3) then 1 else 0 end) as TotalSuspect
 from DBExtractView
 where datereport = (select max(datereport) from DBExtractView where epicasedef in (1,2,3))
	and DistrictRes = 'Conakry'
 group by SCRes
 order by TotalConfProbSusp desc, SCRes asc


/*
Quick query to review a new day's import
*/
select epicasedef, convert(varchar(10),DateReport,103) as "DateReportF", count(*)
 from DBExtractView
 where epicasedef in (0,1,2,3)
 group by epicasedef, datereport
 order by datereport desc, epicasedef desc

/*
quick check by district
*/
select epicasedef, districtres, count(*)
 from DBExtractView
 where epicasedef in (1,2,3)
	and datereport = (select max(datereport) from DBExtractView where epicasedef in (1,2,3))
 group by rollup(epicasedef, districtres)
 order by districtres asc