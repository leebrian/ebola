Use EbolaQC

/*
Create a 21 day rolling epi curve of counts by confirmed, probable and suspect
*/
declare @lastDateReport as datetime
set @lastDateReport = (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
select @lastDateReport

/*
select count(*) as CaseCount, epicasedef, DateReport
 from DBExtractView
 where DateReport > @lastDateReport-21
 group by DateReport, epicasedef
 order by DateReport desc
*/

/*
national 21 day epi curve
*/
select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateReport) as DateReport
 from DBExtractView
 where DateReport > (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21
 group by DateReport
 order by DateReport desc

/*
Macenta 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Macenta', ' Macenta')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

 /*
 Siguiri 21 day epi curve
 */
 Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Siguiri')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

 /*
 Kindia 21 day epi curve
 */
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Kindia')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

 /*
 Forecariah 21 day epi curve
 */
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Forecariah','Forécariah')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

 /*
 Coyah 21 day epi curve
 */
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Coyah')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Dubreka 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Dubreka')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Boffa 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Boffa')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Conakry 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Mali 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Mali')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Yomou 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Yomou')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Conakry Dixinn 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Dixin','Dixinn')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Conakry Kaloum 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Kaloum')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Conakry Matam 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Matam')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc


/*
Conakry Matoto 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Matoto','Matoto/Songoyah')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Conakry Ratoma 21 day epi curve
*/
Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Ratoma')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

/*
Table of all HCW confirmed cases in past 7 days by Active Prefecture and Commune
*/
Select 
	convert(date,DateForPadding) as [DateReport],
	sum(case when DistrictRes in ('Conakry') then 1 else 0 end) as [Conakry], 
	sum(case when DistrictRes in ('Conakry') and SCRes in ('Dixinn','Dixin') then 1 else 0 end) as [Dixinn],  
	sum(case when DistrictRes in ('Conakry') and SCRes in ('Kaloum') then 1 else 0 end) as [Kaloum],  
	sum(case when DistrictRes in ('Conakry') and SCRes in ('Matam') then 1 else 0 end) as [Matam],  
	sum(case when DistrictRes in ('Conakry') and SCRes in ('Matoto') then 1 else 0 end) as [Matoto],  
	sum(case when DistrictRes in ('Conakry') and SCRes in ('Ratoma') then 1 else 0 end) as [Ratoma], 
	sum(case when DistrictRes in ('Forecariah') then 1 else 0 end) as [Forecariah],
	sum(case when DistrictRes in ('Kindia') then 1 else 0 end) as [Kindia], 
	sum(case when DistrictRes in ('Coyah') then 1 else 0 end) as [Coyah], 
	sum(case when DistrictRes in ('Dubreka') then 1 else 0 end) as [Dubreka], 
	sum(case when DistrictRes in ('Macenta') then 1 else 0 end) as [Macenta], 
	sum(case when DistrictRes in ('Boffa') then 1 else 0 end) as [Boffa], 
	sum(case when DistrictRes in ('Siguiri') then 1 else 0 end) as [Siguiri], 
	sum(case when DistrictRes in ('Mali') then 1 else 0 end) as [Mali],
	sum(case when DistrictRes in ('Yomou') then 1 else 0 end) as [Yomou]
 from DatePad dp
 left outer join (select DistrictRes, SCRes, DateReport from DBExtractView where HCW = 'True' and epicasedef in (1)) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-7)
 group by DateForPadding 
 order by DateForPadding desc


 /*
 Most recent 21 days from DatePad
 */ 
 select *
  from DatePad
  where DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)

/*
below this is all debugging
*/

select *
 from DBExtractView
 where HCW = 'True' and epicasedef in (1)
	and DateReport <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and DateReport > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-7)

Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Conakry') and SCRes in ('Dixin','Dixinn','Kaloum','Matam','Matoto','Matoto/Songoyah','Ratoma')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join DBExtractView dbev on dbev.DateReport = dp.DateForPadding
 where dbev.DistrictRes in ('Macenta') and 
 dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc


Select sum(case when epicasedef = 1 then 1 else 0 end) as [Confirmed], 
	sum(case when epicasedef = 2 then 1 else 0 end) as [Probable],  
	sum(case when epicasedef = 3 then 1 else 0 end) as [Suspect], 
	convert(date,DateForPadding) as [DateReport]
 from DatePad dp
 left outer join (select epicasedef, DateReport from DBExtractView where DistrictRes in ('Macenta')) dbev on dbev.DateReport = dp.DateForPadding
 where dp.DateForPadding <= (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
		and dp.DateForPadding > ((select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))-21)
 group by DateForPadding
 order by DateForPadding desc

select *
 from DBExtractView
 where DistrictRes in ('Kindia')
 order by DateReport desc

select count(*), DistrictRes, SCRes
	from DBExtractView
	group by DistrictRes, SCRes
	order by DistrictRes

select count(*), DistrictRes, SCRes
	from DBExtractView
	where DistrictRes = 'Conakry'
	group by DistrictRes, SCRes
	order by DistrictRes

 select sum(case when epicasedef = 1 then 1 else 0 end) as ConfirmedCount, 
	sum(case when epicasedef = 2 then 1 else 0 end) as ProbableCount,  
	sum(case when epicasedef = 3 then 1 else 0 end) as SuspectCount, 
	convert(date,DateReport) as DateReport
 from DBExtractView
 where DateReport > (convert(datetime,'3/15/2001')-21)
 group by DateReport
 order by DateReport desc