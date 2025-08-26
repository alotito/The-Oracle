SELECT Concat( left(vccf.[User_Defined_Field_Value], 4) , '-', substring(vccf.[User_Defined_Field_Value], 5,2) , '-', right(vccf.[User_Defined_Field_Value], 2) ) as 'Transition Date' -- dateof onboarding/transition
	,[company_recid] --index into v_rpt_company to find company name
FROM [cwwebapp_globaltsllc].[dbo].[v_rpt_CompanyCustomFields] vccf 
Where vccf.User_Defined_Field_RecID = 8
		