select * from tERPVendInsert
select * from tERPVendDelete
select * from tERPVendUpdate




SELECT     ApplicationCd, AppOptionType, AppOptionValue, AppOptionNumber, AppOptionTypeDesc, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, 
                      pAppPrefID
FROM         AppPref
WHERE     (ApplicationCd = 'AP') AND (AppOptionType = 'LstVendConNV5.0CnvDt' OR
                      AppOptionType = 'LastVendNV5.0CnvDt')


UPDATE    PERP.dbo.AppPref
SET              AppOptionValue = GETDATE() - 1, ChangeID = SYSTEM_USER, ChangeDt = GetDate()
WHERE     ApplicationCd = 'AP' AND AppOptionType = 'LastVendNV5.0CnvDt'



                         UPDATE    PERP.dbo.AppPref
                           SET              AppOptionValue = GETDATE() - 1, ChangeID = SYSTEM_USER, ChangeDt = GetDate()
                           WHERE     ApplicationCd = 'AP' AND AppOptionType = 'LstVendConNV5.0CnvDt'