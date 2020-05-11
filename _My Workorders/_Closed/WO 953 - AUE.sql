select [Item No_], [Posting date], [Usage Location], [Sales Location Code], [Location Code]
from [Porteous$Actual Usage Entry]
Where [Usage Location]=21 or [Sales Location Code]=21 or [Location Code]=21



UPDATE	[Porteous$Actual Usage Entry]
SET	[Usage Location]=10,
	[Sales Location Code]=10 
WHERE	[Usage Location]=21 or
	[Sales Location Code]=21 
