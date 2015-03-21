/*
epi curve from sitrep recreated
epi week #1 for 2014 starts on 12/30/2013, but use 12/28/2013 because of sql not liking Monday start of week
epi week #1 for 2015 starts on 12/29/2014, but use 12/28/2014 because of sql not liking Monday start of week
*/
select (datediff(week, '12/28/2013',dateadd(dd,-1,dateonset))) as EpiWeek, 
	sum(case when isnull(epicasedef,-1) = 1 then 1 else 0 end) as Confirmed,
	sum(case when isnull(epicasedef,-1) = 2 then 1 else 0 end) as Probable,
	sum(case when isnull(epicasedef,-1) = 3 then 1 else 0 end) as Suspect,
	count(*) as Total
from DBExtractView
where epicasedef in (1,2,3)
	and DateOnset > '12/28/2013'
group by  (datediff(week, '12/28/2013',dateadd(dd,-1,dateonset)))
order by EpiWeek asc

/*
percent of confirmed cases that where a contact by epi week (just for 2015)
*/
select (datediff(week, '12/28/2014',dateadd(dd,-1,dateonset))+1) as EpiWeek, 
	sum(case when isnull(epicasedef,-1) = 1 then 1 else 0 end) as Confirmed,
	sum(case when isnull(epicasedef,-1) = 1 and ThisCaseIsAlsoContact = 'True' then 1 else 0 end) as ConfirmedFromContact
from DBExtractView
where epicasedef in (1)
	and DateOnset > '12/28/2014'
group by  (datediff(week, '12/28/2014',dateadd(dd,-1,dateonset))+1)
order by EpiWeek asc
