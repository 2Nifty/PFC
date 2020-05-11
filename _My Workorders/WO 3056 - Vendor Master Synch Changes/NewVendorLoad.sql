--NV5 - Get pay to vendors
Select      [Pay-to Vendor No_],*
from        [Porteous$Vendor]
Where       [Vendor Posting Group] = 'PRODMAT' and 
            ([Porteous$Vendor].[Pay-to Vendor No_] = [No_] or 
 isnull([Porteous$Vendor].[Pay-to Vendor No_],'') = '')

--NV3 - Get buy from vendors
Select      [Pay-to Vendor No_],*
from        [Porteous$Vendor]
Where       [Vendor Posting Group] = 'PRODMAT' and
[Porteous$Vendor].[Pay-to Vendor No_] <> [No_] and
isnull([Porteous$Vendor].[Pay-to Vendor No_],'') <> ''
