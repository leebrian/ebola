Use EbolaCopy

/*
Lets compare the Geneva lab set to the VHF lab set.
*/

select count(*) as Total from GenevaLab
select count(*) as Total from VHFLabView

select count(*) as ConfirmedCount from VHFLabView 
 where SampleInterpret = 1

select * from GenevaLab

select * from VHFLabView

/*
there's a lot of weird stuff in here
*/
select count(*), interpretation
 from GenevaLab
 group by interpretation
 order by count(*) desc

select count(*), case when interpretation = 'N' then 'NEG' when interpretation = 'P' then 'POS' else 'Other' end as StandardizedInterpretation
 from GenevaLab
 group by interpretation
 order by count(*) desc

--how many results other than positive and negative?
select count(*)
 from GenevaLab
 where isnull(interpretation,'') not in ('N','P')

select count(*), sampleinterpret
 from VHFLabView
 group by sampleinterpret
 order by count(*) desc

select count(*), agelab
	from VHFLabView
	group by agelab
	order by agelab desc

select count(*), age
	from GenevaLab
	group by age
	order by age desc

/*
lets try matching by lab id
*/
select *
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID

/*
matching by name has lots of cartesian coordinates
*/
select LabDataSource, UniqueID, FieldLabSpecID
 from GenevaLab gl, VHFLabView vl
 where gl.Name = vl.LabOtherName
	and gl.Surname = vl.LabSurname


/*
that's restrictive, let's try matching by name and age
*/
select gl.Name, gl.surname, vl.LabSurname, vl.LabOtherName
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID

select *
 from GenevaLab gl, VHFLabView vl
 where gl.Name = vl.LabOtherName
	and gl.Surname = vl.LabSurname
	and convert(varchar,gl.age) = convert(varchar,vl.agelab)

/*
maybe match by name, onsetdate
*/
select convert(date,DateOnset),convert(date,CaseDateOnset), CaseDateOnset, DateOnset,*
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID

select *
 from GenevaLab gl, VHFLabView vl
 where gl.Name = vl.LabOtherName
	and gl.Surname = vl.LabSurname
	and convert(date,gl.DateOnset) = convert(date,vl.CaseDateOnset)

/*
maybe match by name, datesamplecollected
*/
select convert(date,DateCollection) as 'CleanGenevaDateCollected', DateCollection as 'RawGenevaDateCollected', convert(date,DateSampleCollected) as 'CleanVHFDateCollected', DateSampleCollected as 'RawVHFDateCollected',*
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID

select *
 from GenevaLab gl, VHFLabView vl
 where gl.Name = vl.LabOtherName
	and gl.Surname = vl.LabSurname
	and convert(date,DateCollection) = convert(date,DateSampleCollected)

select *
 from GenevaLab gl, VHFLabView vl
 where gl.Name = vl.LabOtherName
	and gl.Surname = vl.LabSurname
	and convert(date,DateTest) = convert(date,DateSampleTested)




/*
Find counts by lab result
*/
select *
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID
	and vl.sampleinterpret = 1

select *
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID
	and vl.sampleinterpret = 3

select *
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID
	and gl.Interpretation = 'P'

	
select *
 from GenevaLab gl, VHFLabView vl
 where gl.UniqueID = vl.FieldLabSpecID
	and gl.Interpretation = 'N'

/*
lets look at it over time
*/
select count(*), 
	datepart(yy, convert(date,datesamplecollected)) as CollectedYear,
	datepart(mm, convert(date,datesamplecollected)) as CollectedMonth
 from VHFLabView
 group by datepart(yy, convert(date,datesamplecollected)),
	datepart(mm, convert(date,datesamplecollected))
 order by CollectedYear asc, CollectedMonth asc

select count(*), 
	datepart(yy, convert(date,isnull(DateCollection,DateReceipt))) as CollectedYear,
	datepart(mm, convert(date,isnull(DateCollection,DateReceipt))) as CollectedMonth
 from GenevaLab
 group by datepart(yy, convert(date,isnull(DateCollection,DateReceipt))),
	datepart(mm, convert(date,isnull(DateCollection,DateReceipt)))
 order by CollectedYear asc, CollectedMonth asc

select *
 from VHFLabView
 order by datesamplecollected

select *
 from GenevaLab
 order by DateCollection