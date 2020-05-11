
ALTER TABLE [dbo].[SODetail] DROP CONSTRAINT [fkfSOHeaderID]
GO

--DROP INDEX [dbo].[SODetail].[idxSODetailfSOHeaderID]
--GO

DROP INDEX [dbo].[SODetail].[idxSODetailItemNo]
GO

DROP INDEX [dbo].[SODetail].[idxSODetailfSOHeaderIDLineNo]
GO

DROP INDEX [dbo].[SODetail].[idxSODetailDeleteDt]
GO




truncate table SOHeader
truncate table SODetail
truncate table SOExpense
truncate table SOComments





ALTER TABLE [dbo].[SODetail]  WITH NOCHECK ADD  CONSTRAINT [fkfSOHeaderID] FOREIGN KEY([fSOHeaderID])
REFERENCES [dbo].[SOHeader] ([pSOHeaderID])
GO
ALTER TABLE [dbo].[SODetail] CHECK CONSTRAINT [fkfSOHeaderID]
GO

--CREATE  INDEX [idxSODetailfSOHeaderID] ON [dbo].[SODetail]([fSOHeaderID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
--GO

CREATE  INDEX [idxSODetailItemNo] ON [dbo].[SODetail]([ItemNo]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  UNIQUE  INDEX [idxSODetailfSOHeaderIDLineNo] ON [dbo].[SODetail]([fSOHeaderID], [LineNumber]) 
WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX [idxSODetailDeleteDt] ON [dbo].[SODetail]([DeleteDt]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO




select * from SOHeader
select * from SODetail
select * from SOExpense
select * from SOComments
