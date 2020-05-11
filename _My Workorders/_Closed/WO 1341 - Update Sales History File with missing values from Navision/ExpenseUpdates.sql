SELECT	COUNT(ExpenseDesc) as ExpenseDesc 	FROM SOExpenseHist WHERE ExpenseDesc  is not null
SELECT	COUNT(ChangeDt ) as ChangeDate 		FROM SOExpenseHist WHERE ChangeDt  is not null
SELECT	COUNT(ChangeID ) as ChangeID 		FROM SOExpenseHist WHERE ChangeID  is not null
