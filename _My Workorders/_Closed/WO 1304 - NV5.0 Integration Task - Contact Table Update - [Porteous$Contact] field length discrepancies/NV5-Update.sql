--[Porteous$Contact]
--Find modified records in NV5.0 based on [Last Modified Date]
SELECT		CBR.[Business Relation Code], CBR.[Contact No_],
		[Contact5.0].*
INTO		[tempERPVendUpdate]
FROM		[Porteous$Contact] [Contact5.0]
INNER JOIN	[Porteous$Contact Business Relation] CBR
ON		[Contact5.0].[No_] = CBR.[Contact No_]
WHERE		CBR.[Business Relation Code] = 'CUST' AND

([Contact5.0].[No_]='CT025968' or 
[Contact5.0].[No_]='CT024283' or 
[Contact5.0].[No_]='CT027839' or 
[Contact5.0].[No_]='CT027849' or 
[Contact5.0].[No_]='CT027850' or 
[Contact5.0].[No_]='CT027851' or 
[Contact5.0].[No_]='CT027852' or 
[Contact5.0].[No_]='CT027804' or 
[Contact5.0].[No_]='CT028483' or 
[Contact5.0].[No_]='CT028756' or 
[Contact5.0].[No_]='CT029846' or 
[Contact5.0].[No_]='CT029848' or 
[Contact5.0].[No_]='CT030483' or 
[Contact5.0].[No_]='CT030484' or 
[Contact5.0].[No_]='CT017324' or 
[Contact5.0].[No_]='CT026357' or 
[Contact5.0].[No_]='CT030218' or 
[Contact5.0].[No_]='CT030344' or 
[Contact5.0].[No_]='CT030557' or 
[Contact5.0].[No_]='CT030559' or 
[Contact5.0].[No_]='CT030562' or 
[Contact5.0].[No_]='CT030694' or 
[Contact5.0].[No_]='CT030695' or 
[Contact5.0].[No_]='CT030803' or 
[Contact5.0].[No_]='CT029133' or 
[Contact5.0].[No_]='CT015666' or 
[Contact5.0].[No_]='CT029824' or 
[Contact5.0].[No_]='CT030546' or 
[Contact5.0].[No_]='CT016052' or 
[Contact5.0].[No_]='CT027858' or 
[Contact5.0].[No_]='CT031556' or 
[Contact5.0].[No_]='CT031557' or 
[Contact5.0].[No_]='CT019155' or 
[Contact5.0].[No_]='CT021135' or 
[Contact5.0].[No_]='CT032093' or 
[Contact5.0].[No_]='CT026026' or 
[Contact5.0].[No_]='CT018448' or 
[Contact5.0].[No_]='CT026885' or 
[Contact5.0].[No_]='CT026887' or 
[Contact5.0].[No_]='CT023310' or 
[Contact5.0].[No_]='CT031317' or 
[Contact5.0].[No_]='CT032896' or 
[Contact5.0].[No_]='CT032692' or 
[Contact5.0].[No_]='CT033716' or 
[Contact5.0].[No_]='CT028058' or 
[Contact5.0].[No_]='CT033991' or 
[Contact5.0].[No_]='CT034061' or 
[Contact5.0].[No_]='CT034062' or 
[Contact5.0].[No_]='CT034144' or 
[Contact5.0].[No_]='CT022719' or 
[Contact5.0].[No_]='CT023999' or 
[Contact5.0].[No_]='CT032394' or 
[Contact5.0].[No_]='CT033380' or 
[Contact5.0].[No_]='CT033381' or 
[Contact5.0].[No_]='CT033382' or 
[Contact5.0].[No_]='CT033383' or 
[Contact5.0].[No_]='CT016309' or 
[Contact5.0].[No_]='CT022973' or 
[Contact5.0].[No_]='CT032100' or 
[Contact5.0].[No_]='CT032459' or 
[Contact5.0].[No_]='CT026124' or 
[Contact5.0].[No_]='CT025751' or 
[Contact5.0].[No_]='CT034537' or 
[Contact5.0].[No_]='CT017741' or 
[Contact5.0].[No_]='CT033990' or 
[Contact5.0].[No_]='CT034408' or 
[Contact5.0].[No_]='CT034989' or 
[Contact5.0].[No_]='CT032730' or 
[Contact5.0].[No_]='CT035050')







--		[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)) --AND
--		DATEPART(yyyy,[Last Update])+DATEPART(mm,[Last Update])+DATEPART(dd,[Last Update])+DATEPART(hh,[Last Update])+DATEPART(mi,[Last Update]) <> DATEPART(yyyy,@LastDate)+DATEPART(mm,@LastDate)+DATEPART(dd,@LastDate)+DATEPART(hh,@LastDate)+DATEPART(mi,@LastDate)
--SELECT * FROM tERPVendUpdate