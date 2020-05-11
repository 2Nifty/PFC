set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '017888' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C17888.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '018169' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C18169.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '024951' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C24951.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '061811' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C61811.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '084722' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C84722.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '086161' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C86161.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '090901' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C90901.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '045110' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C45110.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '010600' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C10600.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT replace(ItemNo,'-','') AS ItemNo, '          ' AS FILL1, AliasItemNo, '          ' AS FILL2, AliasWhseNo, '                                                ' AS FILL3 FROM ItemAlias (Nolock) WHERE OrganizationNo = '084401' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\C84401.xrf
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c

set _cmd=SELECT Left(replace(ItemNo,'-',''),12) as ItemNo, Left(AliasItemNo,7) as UPC, Substring(AliasItemNo,3,5) as UPCCODE, Left(AliasWhseNo,2) AS HEADMK FROM	ItemAlias (Nolock) WHERE OrganizationNo = '061811' and isnull(DeleteDt,'') = '' ORDER BY ItemNo
set _file=\\Pfcsqlp\pwwcnv\CrossRef\NEWELL.PC
bcp "%_cmd%" queryout "%_file%" -U pfcnormal -P pfcnormal -c