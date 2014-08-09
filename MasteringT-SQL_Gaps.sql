-- gaps

CREATE TABLE PO	
(
	PONumber varchar(20)
	, PODate datetime
) ;
go
INSERT INTO PO (PONumber, PODate)
VALUES ('CO1', '2014/2/1')
     , ('CO2', '2014/2/2')
     , ('CA4', '2014/3/2')
     , ('CO4', '2014/3/5')
     , ('CO5', '2014/3/8')
     , ('CA5', '2014/3/9')
     , ('CA7', '2014/3/12')
     , ('CO7', '2014/4/12')
     , ('CA9', '2014/5/12')
-- Gaps, CO3, CO6, CA6, CA8
go

-- Query
;
with  POGaps
        as ( select
                postate = substring(PONumber, 1, 2)
              , curr = cast(substring(PONumber, 3, 20) as int)
              , nxt = lead(cast(substring(PONumber, 3, 20) as int), 1, null) over ( partition by substring(PONumber,
                                                              1, 2) order by cast(substring(PONumber,
                                                              3, 20) as int) )
              from
                PO
           )
  select
      poGaps.postate
    , [StartGap] = POGaps.curr + 1
    , [EndGap] = POGaps.nxt - 1
    from
      POGaps
    where
      POGaps.nxt > POGaps.curr + 1;
go
-- cleaner
;
with  POGaps
        as ( select
                postate = substring(PONumber, 1, 2)
              , curr = cast(substring(PONumber, 3, 20) as int)
              , nxt = lead(cast(substring(PONumber, 3, 20) as int), 1, null) over ( partition by substring(PONumber,
                                                              1, 2) order by cast(substring(PONumber,
                                                              3, 20) as int) )
              from
                PO
           )
  select
      poGaps.postate + 
    , [StartGap] = POGaps.curr + 1
    , [EndGap] = POGaps.nxt - 1
    from
      POGaps
    where
      POGaps.nxt > POGaps.curr + 1;


-- cleanup
-- drop table PO;
