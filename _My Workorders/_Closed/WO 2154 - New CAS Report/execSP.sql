	-- ----------------------------------------------------------------------------------------------------------------


				   Command    Period    Loc   Chain   XLS                          List    CustNo  XLS                         List                      FilterCD    Terr    Outside Rep     Inside Rep  UserName
exec pCustActivity 'GetList', '122009', '15', 'WHIT',  '',                         '',      '',     '',                        '',                       'ChainCd',   '',    'Kevin Chavis',  '',        'Tod'
exec pCustActivity 'GetList', '122009', '15',   '',    '',                         '',      '',     '',                        '''001003'',''001811''',  'CustList',  '',    '',              '',        'Tod'
exec pCustActivity 'GetList', '122009', '15',   '',    '',                         '',      '',     'c:\WO2154_CustList.XLS',  '',                       'CustXLS',   '',    '',              '',        'Tod'
exec pCustActivity 'GetList', '122009', '15',   '',    'c:\WO2154_ChainList.XLS',  '',      '',     '',                        '',                       'ChainXLS',  '',    '',              '',        'Tod'


exec pCustActivity 'GetList', '122009', '15',   '',    '\\pfcfiles\UserDB\AppDev\Tod\02-Open\WO 2154 - New CAS Report\Test\WO2154_ChainList.xls',  '',      '',     '',                        '',                       'ChainXLS',  '',    '',              '',        'Tod'



exec pCustActivity 'GetList', '122009', '15',   '',    '\\pfcfiles\userdb\WO2154_CustActivityRpt\ChainList_tod.xls',  '',      '',     '',                        '',                       'ChainXLS',  '',    '',              '',        'Tod'
exec pCustActivity 'GetList', '122009', '15',   '',    '',                         '',      '',     '\\pfcfiles\userdb\WO2154_CustActivityRpt\CustList_tod.xls',  '',                       'CustXLS',   '',    '',              '',        'Tod'


	-- ----------------------------------------------------------------------------------------------------------------




/*
exec pCustActivity	'GetList',		--Command
					'122009',		--Period
					'15', 			--CustShipLocation
					'',		  		--ChainCd
					'',				--ChainXLS
					'Sheet1$',		--ChainSheet
					'',				--ChainList
					'',				--CustNo
					'',				--CustXLS
					'',				--CustSheet
					'',				--CustList
					'NoFilter',		--FilterCd
					'',				--SalesTerritory
					'',				--OutsideRep
					'',				--InsideRep
					'',				--RegionalMgr
					'',				--BuyGroup
					'Tod'			--UserName

exec pCustActivity	'GetList',		--Command
					'122009',		--Period
					'15', 			--CustShipLocation
					'WHIT',  		--ChainCd
					'',				--ChainXLS
					'Sheet1$',		--ChainSheet
					'',				--ChainList
					'',				--CustNo
					'',				--CustXLS
					'',				--CustSheet
					'',				--CustList
					'ChainCd',		--FilterCd
					'',				--SalesTerritory
					'Kevin Chavis',	--OutsideRep
					'',				--InsideRep
					'',				--RegionalMgr
					'',				--BuyGroup
					'Tod'			--UserName

exec pCustActivity	'GetList',					--Command
					'122009',					--Period
					'15', 						--CustShipLocation
					'',	  						--ChainCd
					'',							--ChainXLS
					'',							--ChainSheet
					'',							--ChainList
					'',							--CustNo
					'',							--CustXLS
					'',							--CustSheet
					'''001003'',''001811''',	--CustList
					'CustList',					--FilterCd
					'',							--SalesTerritory
					'',							--OutsideRep
					'',							--InsideRep
					'',							--RegionalMgr
					'',							--BuyGroup
					'Tod'						--UserName

exec pCustActivity	'GetList',														--Command
					'122009',														--Period
					'15', 															--CustShipLocation
					'',	  															--ChainCd
					'\\pfcfiles\userdb\WO2154_CustActivityRpt\ChainList_tod.xls',	--ChainXLS
					'test$',														--ChainSheet
					'',																--ChainList
					'',																--CustNo
					'',																--CustXLS
					'',																--CustSheet
					'',																--CustList
					'ChainXLS',														--FilterCd
					'',																--SalesTerritory
					'',																--OutsideRep
					'',																--InsideRep
					'',																--RegionalMgr
					'',																--BuyGroup
					'Tod'															--UserName

exec pCustActivity	'GetList',														--Command
					'122009',														--Period
					'15', 															--CustShipLocation
					'',	  															--ChainCd
					'',																--ChainXLS
					'',																--ChainSheet
					'',																--ChainList
					'',																--CustNo
					'\\pfcfiles\userdb\WO2154_CustActivityRpt\CustList_tod.xls',	--CustXLS
					'Sheet1$',														--CustSheet
					'',																--CustList
					'CustXLS',														--FilterCd
					'',																--SalesTerritory
					'',																--OutsideRep
					'',																--InsideRep
					'',																--RegionalMgr
					'',																--BuyGroup
					'Tod'															--UserName
*/
