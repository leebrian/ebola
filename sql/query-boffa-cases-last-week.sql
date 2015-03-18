Use EbolaQC

declare @lastDateReport as datetime
set @lastDateReport = (select max(datereport) as 'LatestImport' from DBExtractView where epicasedef in (0,1,2,3))
select @lastDateReport

select count(*), datereport
	from DBExtractView
	where epicasedef in (1,2,3)
		and datereport > (@lastDateReport-7)
	group by datereport

select count(*), districtres
 from DBExtractView
 where epicasedef in (2) and DistrictRes = 'Boffa'
 group by districtres
 order by DistrictRes

select count(*), datereport
	from DBExtractView
	where epicasedef in (1,2,3)
		and datereport > (@lastDateReport-7)
	group by datereport

select * from DBExtractView
