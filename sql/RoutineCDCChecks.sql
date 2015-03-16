Use EbolaQC

/*
Create a 21 day rolling epi curve of counts by confirmed, probable and suspect
*/
declare @lastDateReport as datetime
set @lastDateReport = (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))

/*
select count(*) as CaseCount, epicasedef, DateReport
 from DBExtractView
 where DateReport > @lastDateReport-21
 group by DateReport, epicasedef
 order by DateReport desc
*/

select sum(case when epicasedef = 1 then 1 else 0 end) as ConfirmedCount, 
	sum(case when epicasedef = 2 then 1 else 0 end) as ProbableCount,  
	sum(case when epicasedef = 3 then 1 else 0 end) as SuspectCount, 
	convert(date,DateReport) as DateReport
 from DBExtractView
 where DateReport > @lastDateReport-21
 group by DateReport
 order by DateReport desc