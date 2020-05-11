select * 
from [Porteous$Actual Usage Entry]
--from tAUEBackup 
where [Item No_]='00170-2510-500' or [Item No_]='00170-2503-500' or [Item No_]='00170-2512-501' or [Item No_]='00170-3403-501'
and [Usage Location]<>''
--where [Item No_]='00170-2510-020' or [Item No_]='00170-2503-020' or [Item No_]='00170-2512-021' or [Item No_]='00170-3403-021'
--order by [Entry No_]
order by [Item No_], [Usage Location]



where 
[Entry No_]='1709919' or
[Entry No_]='1709920' or
[Entry No_]='1709950' or
[Entry No_]='1709955' or
[Entry No_]='1709966' or
[Entry No_]='1709972' or
[Entry No_]='5865698' or
[Entry No_]='6631046' or
[Entry No_]='6892659' or
[Entry No_]='7361105' or
[Entry No_]='7670337' or
[Entry No_]='7948914' or
[Entry No_]='9268830' or
[Entry No_]='9328465' or
[Entry No_]='9366811' or
[Entry No_]='9414945' or
[Entry No_]='9736078' or
[Entry No_]='9807262' or
[Entry No_]='9848473' or
[Entry No_]='9938483' or
[Entry No_]='10019638' or
[Entry No_]='10125727' or
[Entry No_]='10306915' or
[Entry No_]='10307996' or
[Entry No_]='10309069' or
[Entry No_]='10313172' or
[Entry No_]='10314578' or
[Entry No_]='10315216' or
[Entry No_]='10316104' or
[Entry No_]='10317247' or
[Entry No_]='10320784' or
[Entry No_]='10322231' or
[Entry No_]='10324873' or
[Entry No_]='10325120' or
[Entry No_]='10328623' or
[Entry No_]='10330861' or
[Entry No_]='10338196' or
[Entry No_]='10339196' or
[Entry No_]='10340483' or
[Entry No_]='10341530' or
[Entry No_]='10345980' or
[Entry No_]='10347257' or
[Entry No_]='10352521' or
[Entry No_]='10352607' or
[Entry No_]='10352867' or
[Entry No_]='10354613' or
[Entry No_]='10356665' or
[Entry No_]='10378005' or
[Entry No_]='10404134' or
[Entry No_]='10406569' or
[Entry No_]='10408388' or
[Entry No_]='10416787' or
[Entry No_]='10430044' or
[Entry No_]='10430943' or
[Entry No_]='10432949' or
[Entry No_]='10445794' or
[Entry No_]='10447368' or
[Entry No_]='10456795' or
[Entry No_]='10459601' or
[Entry No_]='10471428' or
[Entry No_]='10474990' or
[Entry No_]='10475235' or
[Entry No_]='10480609' or
[Entry No_]='10503865' or
[Entry No_]='10507388' or
[Entry No_]='10507979' or
[Entry No_]='10513708' or
[Entry No_]='10518058' or
[Entry No_]='10520307' or
[Entry No_]='10522155' or
[Entry No_]='10522246' or
[Entry No_]='10527174'

order by [Entry No_]






select * from [Porteous$Stockkeeping Unit]
where
([Item No_]='00170-2503-020' and [Location Code]='11') or 
([Item No_]='00170-2512-021' and [Location Code]='11') or 
([Item No_]='00170-3403-021' and [Location Code]='11') or
([Item No_]='00170-3403-021' and [Location Code]='13') or
([Item No_]='00170-3403-021' and [Location Code]='19') or 
([Item No_]='00170-3403-021' and [Location Code]='20') or 
([Item No_]='00170-3403-021' and [Location Code]='21') or 
([Item No_]='00170-3403-5011' and [Location Code]='13')

select * from tRodItems
order by [Item No_], [Location Code]


select * from tRodFactor
order by Item








--SELECT Items for update
SELECT	OldSKU.[Item No_], OldSKU.[Location Code]
--INTO	tRodItems
FROM	[Porteous$Stockkeeping Unit] NewSKU
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem50) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN [Porteous$Item] Item
ON	Item.[No_]=NewSKU.[Item No_]
INNER JOIN tRodFactor RodFactor
ON	OldSKU.[Item No_]=RodFactor.Item
where	(LEFT(NewSKU.[Item No_],5)='00170' or LEFT(NewSKU.[Item No_],5)='00171' or LEFT(NewSKU.[Item No_],5)='04170' or
	 LEFT(NewSKU.[Item No_],5)='04171' or LEFT(NewSKU.[Item No_],5)='04172') and SUBSTRING(NewSKU.[Item No_],12,2)='02'
order by OldSKU.[Item No_], OldSKU.[Location Code]