use EbolaQC

/*
find duplicate IDs, these should not exist
103 code means dd/mm/yyyy - French style
*/
select v2.DuplicateCount, v1.ID, v1.epicasedef, convert(varchar(10),v1.DateReport,103) as DateRep, v1.Surname, v1.OtherNames, v1.Age, v1.Gender
 from DBExtractView v1 INNER JOIN (
	Select count(*) as DuplicateCount, ID from DBExtractView
		Group by ID
		Having count(ID) > 1) v2
 ON v1.ID = v2.ID
 order by v2.DuplicateCount desc, DateReport desc, v1.ID 

 /*
 find duplicates based on name, age, gender, districtres. These need to be investigated.
 */
 select v2.DuplicateCount, v1.ID, v1.epicasedef, convert(varchar(10),v1.DateReport,103) as DateRep, v1.Surname, v1.OtherNames, v1.Age, v1.Gender, v1.DistrictRes
 from DBExtractView v1 INNER JOIN (
	Select count(*) as DuplicateCount, ltrim(rtrim(surname)) as surname, ltrim(rtrim(othernames)) as othernames, age,gender, districtres 
		from DBExtractView
		where epicasedef in (0,1,2,3)--I don't care about exclude and chains of transmission
		group by ltrim(rtrim(surname)), ltrim(rtrim(othernames)), age,gender, districtres
		having count(*) >1) v2
 ON isnull(ltrim(rtrim(v1.surname)),-1) = isnull(v2.surname,-1)
	AND isnull(ltrim(rtrim(v1.othernames)),-1) = isnull(v2.othernames,-1)
	AND isnull(v1.age, -1) = isnull(v2.age,-1)
	AND isnull(v1.gender,-1) = isnull(v2.gender,-1)
	AND isnull(v1.DistrictRes,-1) = isnull(v2.DistrictRes,-1)
	AND v1.epicasedef in (0,1,2,3)
 order by v2.DuplicateCount desc, v1.ID 


--everything below is debugging

--there were 78 groups of dupes on mar 7
Select count(*) as DuplicateCount, surname, othernames, age,gender, districtres 
	from DBExtractView
		where epicasedef in (0,1,2,3)
	group by surname, othernames, age,gender, districtres
	having count(*) >1
	order by DuplicateCount desc

/*
sort IDs by frequency of occurance
*/
select v1.ID, count(*)
 from DBExtractView v1 INNER JOIN (
	Select ID from DBExtractView
		Group by ID
		Having count(ID) > 1) v2
 ON v1.ID = v2.ID
 group by v1.ID
 order by count(*) desc

/*
what about only in Conakry
*/
Select count(*) as DuplicateCount, surname, othernames, age,gender, districtres 
	from DBExtractView
		where epicasedef in (0,1,2,3)
			and districtres = 'Conakry'
	group by surname, othernames, age,gender, districtres
	having count(*) >1
	order by DuplicateCount desc
