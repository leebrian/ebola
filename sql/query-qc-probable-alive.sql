use EbolaQC

/*
check for probable cases where the final status is alive. this should never occur
*/
select ID, FinalStatus
 from DBExtractView
 where epicasedef = 2
	and finalstatus = 2