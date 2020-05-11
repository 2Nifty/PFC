select [Order No_], Hdr.[No_], [Document No_], Line.[No_], 
Line.[Line No_], [Quantity], CT.Comment, LC.Comment from [Porteous$Sales Invoice Header] Hdr inner join
		[Porteous$Sales Invoice Line] Line on Hdr.[No_]=[Document No_] left outer join
		[Porteous$Sales Comment Line] CT on Line.[No_] = CT.[No_] left outer join
		[Porteous$Sales Line Comment Line] LC on Line.[No_] = LC.[No_]
where
[Order No_]='SO3107798' or
[Order No_]='SO3107799' or
[Order No_]='SO3107800' or
[Order No_]='SO3107809' or
[Order No_]='SO3107816' or
[Order No_]='SO3107820' or
[Order No_]='SO3107833' or
[Order No_]='SO3107834' or
[Order No_]='SO3107835' or
[Order No_]='SO3107836' or
[Order No_]='SO3107837' or
[Order No_]='SO3107838' or
[Order No_]='SO3107840' or
[Order No_]='SO3107841' or
[Order No_]='SO3107842' or
[Order No_]='SO3107844' or
[Order No_]='SO3107886' or
[Order No_]='SO3107888'
order by [Order No_], Line.[Line No_]
