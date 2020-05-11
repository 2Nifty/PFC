--PFCSQLT.PFCReports


select * from ItemBranchUsage

-------------------------------------------------------------------------------------------------------

--Create temp table of existing ItemBranchUsage transactions
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1836ItemBranchUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1836ItemBranchUsage
go

SELECT	*
--INTO	tWO1836ItemBranchUsage
FROM	ItemBranchUsage IBU (NoLock)
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1836_UsageList NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.CurPeriodNo = NewIBU.CurPeriod AND
			IBU.Location = NewIBU.NewUsageLoc)
go






--DELETE existing ItemBranchUsage transactions that were saved
DELETE
FROM	ItemBranchUsage 
WHERE	EXISTS	(SELECT	*
		 FROM	tWO1836_UsageList NewIBU (NoLock)
		 WHERE	IBU.ItemNo = NewIBU.ItemNo AND
			IBU.CurPeriodNo = NewIBU.CurPeriod AND
			IBU.Location = NewIBU.NewUsageLoc)
go




--UPDATE existing ItemBranchUsage 01 transactions to 15
UPDATE	ItemBranchUsage
SET	Location = NewIBU.NewLoc,
	ChangeID = 'WO1836',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	* FROM tWO1836_UsageList (NoLock)) NewIBU
ON	IBU.ItemNo = NewIBU.ItemNo AND
	IBU.Location = NewIBU.OldLoc

