select * from Tables
where TableType='CAR' or 
TableType='CTYP' or 
TableType='EXPD' or 
TableType='FGHT' or 
TableType='FGHTADD' or 
TableType='PRI' or 
TableType='REAS' or 
TableType='RPCL' or 
TableType='SEC' or 
TableType='SHIP' or 
TableType='TRD' or 
TableType='WM' or 
TableType='WebCat'

order by TableType, TableCd



select distinct TableType from Tables
where TableType='CAR' or 
TableType='CTYP' or 
TableType='EXPD' or 
TableType='FGHT' or 
TableType='FGHTADD' or 
TableType='PRI' or 
TableType='REAS' or 
TableType='RPCL' or 
TableType='SEC' or 
TableType='SHIP' or 
TableType='TRD' or 
TableType='WM' or 
TableType='WebCat'