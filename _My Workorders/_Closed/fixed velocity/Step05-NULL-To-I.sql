--Update any remaining BLANK items in Porteous$Item with an "I" code and Carson Sales Velocity Code <> N
UPDATE    Porteous$Item
SET              Porteous$Item.[Corp Fixed Velocity Code] = 'I'
FROM         [Porteous$Stockkeeping Unit] INNER JOIN
                      Porteous$Item ON [Porteous$Stockkeeping Unit].[Item No_] = Porteous$Item.No_
WHERE     (Porteous$Item.[Corp Fixed Velocity Code] = '' AND [Porteous$Stockkeeping Unit].[Sales Velocity Code] <> 'N' AND 
                      [Porteous$Stockkeeping Unit].[Location Code] = '01')