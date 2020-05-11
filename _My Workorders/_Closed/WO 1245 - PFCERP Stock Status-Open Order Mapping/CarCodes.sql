UPDATE	SOHeader
SET	OrderCarName = LEFT(Car.[Name],30)
FROM	PFCLIVE.dbo.[Porteous$Shipping Agent] Car
WHERE	OrderCarrier = Car.Code COLLATE SQL_Latin1_General_CP1_CI_AS