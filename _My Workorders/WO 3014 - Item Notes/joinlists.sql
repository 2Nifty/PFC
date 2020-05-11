
SELECT	LM.ListName,
		LD.ListValue as NoteType,
		LD.ListdtlDesc as NoteTypeDesc,
		FormType.FormType,
		FormType.FormTypeDesc
FROM	ListMaster LM inner join ListDetail LD on plistmasterid=flistmasterid inner join
(select LM.ListName, LD.ListValue as FormType, LD.ListdtlDesc as FormTypeDesc 
from ListMaster LM inner join ListDetail LD on plistmasterid=flistmasterid 
where Listname ='FormType') FormType on 1=1
where LM.Listname ='ItemNotesCd' --and LD.ListValue='I'
order by NoteType, FormType.FormType

