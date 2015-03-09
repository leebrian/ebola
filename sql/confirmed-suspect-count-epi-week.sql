use EbolaQC

set datefirst 1

select datepart(year,dateonset) as ReportYear, datepart(ww,dateonset) as ReportWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 group by datepart(ww,dateonset), datepart(year,dateonset)
 order by ReportYear desc, ReportWeek desc 

 select datepart(ww,datereport) as ReportWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 and datereport > '9/1/2014'
 group by datepart(ww,datereport)
 order by ReportWeek desc

 select datediff(week, '12/30/2013',dateonset) as EpiWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 group by datediff(week, '12/30/2013',dateonset)
 order by EpiWeek asc


/*
Count of confirmed and probable cases by epi week, using datereport
the dateadd stuff is because sql doesn't respect datefirst of Monday 
epi week #1 starts on 12/30/2013, but we subtract 1 to account for sql
*/
 select (datediff(week, '12/29/2013',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 group by datediff(week, '12/29/2013',dateadd(dd,-1,datereport))
  having datediff(week, '12/29/2013',dateadd(dd,-1,datereport)) >=0
 order by EpiWeek asc

/*
Count of confirmed and probable cases by epi week, using onset
use dateonset, not datereport, the dateadd stuff is because sql doesn't respect datefirst of Monday 
epi week #1 starts on 12/30/2013, but we subtract 1 to account for sql
*/
 select (datediff(week, '12/29/2013',dateadd(dd,-1,dateonset))+1) as EpiWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 group by datediff(week, '12/29/2013',dateadd(dd,-1,dateonset))
  having datediff(week, '12/29/2013',dateadd(dd,-1,dateonset)) >=0
 order by EpiWeek asc

 /*
 determine the top 12 active districts
 */
Select *
INTO #Top12ActiveDistricts
FROM (
select top 12 DistrictRes, count(*) as count
	from DBExtractView
	where epicasedef in (1,2)
	and dateonset > '1/1/2015'
	group by districtres
	order by count(*) desc
) districts

GO

 /*
 Count of suspect and probable cases by epi week, using onset, by district of residence
 Requires #Top12ActiveDistricts created by above query
 */
select DistrictRes,
		(datediff(week, '12/29/2013',dateadd(dd,-1,dateonset))+1) as EpiWeek, 
		count(*) as ConfirmedAndProbableCases
	from DBExtractView
	where epicasedef in (1,2)
		and DistrictRes in (Select DistrictRes from #Top12ActiveDistricts)
	group by datediff(week, '12/29/2013',dateadd(dd,-1,dateonset)), 
		DistrictRes
	having datediff(week, '12/29/2013',dateadd(dd,-1,dateonset)) >=0
	order by DistrictRes,EpiWeek asc

/*
Community deaths
epi week #1 for 2015 starts on 12/29/2014, but use 12/28/2014 because of sql not liking Monday start of week
*/
select PlaceDeath, (datediff(week, '12/28/2014',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
--where DateOnset > '12/29/2014'
group by PlaceDeath, datediff(week, '12/28/2014',dateadd(dd,-1,datereport))
having datediff(week, '12/28/2014',dateadd(dd,-1,datereport)) >=0
and PlaceDeath = '1'
order by EpiWeek asc

select PlaceDeath, (datediff(week, '12/28/2014',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
where sampleinterpret1 in (1,2) or sampleinterpret2 in (1,2)  or sampleinterpret3 in (1,2) or sampleinterpret4 in (1,2)  or sampleinterpret5 in (1,2)  or sampleinterpret6 in (1,2)  or sampleinterpret7 in (1,2) 
	and epicasedef in (1)
group by PlaceDeath, datediff(week, '12/28/2014',dateadd(dd,-1,datereport))
having datediff(week, '12/28/2014',dateadd(dd,-1,datereport)) >=0
and PlaceDeath = '1'
order by EpiWeek asc

/*
probable cases by epi week in 2015
*/
select (datediff(week, '12/28/2014',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
where epicasedef in (2)
group by datediff(week, '12/28/2014',dateadd(dd,-1,datereport))
having datediff(week, '12/28/2014',dateadd(dd,-1,datereport)) >=0
order by EpiWeek asc

/*
total records with lab data
*/
select (datediff(week, '12/28/2014',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
where len(sampleinterpret1) > 0
	or len(sampleinterpret2) > 0
	or len(sampleinterpret3) > 0
	or len(sampleinterpret4) > 0
	or len(sampleinterpret5) > 0
	or len(sampleinterpret6) > 0
	or len(sampleinterpret7) > 0
group by datediff(week, '12/28/2014',dateadd(dd,-1,datereport))
having datediff(week, '12/28/2014',dateadd(dd,-1,datereport)) >=0
order by EpiWeek asc

/*
confirmed cases with lab data
*/
select (datediff(week, '12/28/2014',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
where (len(sampleinterpret1) > 0
	or len(sampleinterpret2) > 0
	or len(sampleinterpret3) > 0
	or len(sampleinterpret4) > 0
	or len(sampleinterpret5) > 0
	or len(sampleinterpret6) > 0
	or len(sampleinterpret7) > 0)
	and epicasedef = 1
group by datediff(week, '12/28/2014',dateadd(dd,-1,datereport))
having datediff(week, '12/28/2014',dateadd(dd,-1,datereport)) >=0
order by EpiWeek asc

select (datediff(week, '12/30/2014',dateadd(dd,1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
where (len(sampleinterpret1) > 0
	or len(sampleinterpret2) > 0
	or len(sampleinterpret3) > 0
	or len(sampleinterpret4) > 0
	or len(sampleinterpret5) > 0
	or len(sampleinterpret6) > 0
	or len(sampleinterpret7) > 0)
	and epicasedef = 1
group by datediff(week, '12/30/2014',dateadd(dd,1,datereport))
having datediff(week, '12/30/2014',dateadd(dd,1,datereport)) >=0
order by EpiWeek asc

select epicasedef,count(*) from DBExtractView
 where datereport > '12/28/2014'
 group by epicasedef
-- and epicasedef in (1,2,3,4,5

/*
Community deaths by epi week
epi week #1 for 2014 starts on 12/30/2013, but use 12/29/2013 because of sql not liking Monday start of week
*/
select PlaceDeath, (datediff(week, '12/29/2013',dateadd(dd,-1,datereport))+1) as EpiWeek, count(*)
from DBExtractView
--where DateOnset > '12/29/2014'
group by PlaceDeath, datediff(week, '12/29/2013',dateadd(dd,-1,datereport))
having datediff(week, '12/29/2013',dateadd(dd,-1,datereport)) >=0
and PlaceDeath = '1'
and (datediff(week, '12/29/2013',dateadd(dd,-1,datereport))+1) > 45
order by EpiWeek asc

/*
Epi curve for Forecariah for 15/2 forward. Asked for my Christine.
By DateReport because recent cases don't have DateOnset yet
Only confirmed, probable and suspect
convert 103 code means dd/mm/yyyy, but still sort by date proper for ordering
*/	
select convert(varchar(10),DateReport, 103) as FormattedDate,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateReport > '02/15/2015'
		and DistrictRes = 'Forecariah'
	group by DateReport
	order by DateReport asc

/*
Epi curve for Forecariah for 15/2 forward. Asked for my Christine.
By DateOnset for comparison
Only confirmed, probable and suspect
convert 103 code means dd/mm/yyyy, but still sort by date proper for ordering
*/	
select convert(varchar(10),DateOnset, 103) as FormattedDate,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateOnset > '02/15/2015'
		and DistrictRes = 'Forecariah'
	group by DateOnset
	order by DateOnset asc

/*
check other districts in the period after 2/15 to see if forecariah misspelled or something
*/
select convert(varchar(10),DateReport, 103) as FormattedDate,
		DistrictRes,
		count(*) as ConfirmedAndProbableAndSuspectCases
	from DBExtractView
	where epicasedef in (1,2,3)
		and DateReport > '02/15/2015'
	group by rollup (DateReport,
		DistrictRes)
	order by DistrictRes asc, 
		DateReport asc

/*
Count of confirmed and probable cases by epi week, using datereport
the dateadd stuff is because sql doesn't respect datefirst of Monday 
epi week #1 starts on 12/30/2013, but we subtract 1 to account for sql
*/
 select (datediff(week, '12/29/2013',dateadd(dd,-1,isnull(dateonset,datereport)))+1) as EpiWeek, count(*) from
 DBExtractView
 where epicasedef in (1,2)
 group by datediff(week, '12/29/2013',dateadd(dd,-1,isnull(dateonset,datereport)))
  having datediff(week, '12/29/2013',dateadd(dd,-1,isnull(dateonset,datereport))) >=0
 order by EpiWeek desc

select datereport,epicasedef, count(*)
 from DBExtractView
 where epicasedef in (0,1,2,3)
 group by datereport, epicasedef
 order by datereport desc, epicasedef