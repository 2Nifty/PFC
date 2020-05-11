SELECT     [Location Code], [Item No_], [Sales Velocity Code], [Reorder Point], [Reorder Pt Change Policy]
FROM         [Porteous$Stockkeeping Unit]
WHERE     ([Reorder Point] = 0) AND ([Sales Velocity Code] = 'A' OR
                      [Sales Velocity Code] = 'B' OR
                      [Sales Velocity Code] = 'C' OR
                      [Sales Velocity Code] = 'D' OR
                      [Sales Velocity Code] = 'E' OR
                      [Sales Velocity Code] = 'F' OR
                      [Sales Velocity Code] = 'G' OR
                      [Sales Velocity Code] = 'H' OR
                      [Sales Velocity Code] = 'I' OR
                      [Sales Velocity Code] = 'J' OR
                      [Sales Velocity Code] = 'K')
ORDER BY [Item No_], [Location Code]