Use EbolaQC

/*
To help for padding out counts on days that don't have counts, create a padding table with all the days of interest
You can outer join to this table to make sure tables show up clearly with zero values for days.
*/
drop table DatePad
create table DatePad (DateForPadding date not null)

declare @loopDate as date
declare @startDate as date
declare @endDate as date

set @startDate = '15-Feb-2015'
set @endDate = '31-Dec-2015' --increase this if you need to run past 31-Dec-2015

set @loopDate = @startDate
while @loopDate <= @endDate 
begin
    insert into DatePad values (@loopDate)
    set @loopDate = dateadd(dd,1,@loopDate)
end 



select * from DatePad