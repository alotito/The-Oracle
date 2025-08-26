SELECT [Company_RecID] -- Index to Company
      ,[Company_ID] -- Short identifer for company
      ,[Company_Name] --Compnay Name
      ,[Company_Type_Desc] -- commana seperated list of compnay type modifers. active clients will have "Client" as the first item in the list.
      ,[Company_Status_Desc] -- company status as a client ("former client" or "Inactive/Gone" indicates they are no longer clients)
      ,[Market_Desc] --market segment in which the company operates
      ,[PhoneNbr] -- the main phone numbe rfor the company
      ,[Website_URL] -- the company website, if known
      ,[Parent_Company_RecID] -- the index tot v_rpt_company of the parent company. if null then this is a parent company OR a stand alone company
      ,[Delete_Flag] -- indicats the company is marked as deleted and not a client
      ,[Last_Update] --Date time of last update to the company record.
      ,[Custom_Note] --custom notes for this company
      ,[Contact_RecID] --index to v_rpt_contacts for default contact
      ,[Default_Contact_First_Name] -- first name of default contact
      ,[Default_Contact_Last_Name] -- last name of default contact
      ,[Default_Contact_Email] -- default conact email
      ,[Last_Update_UTC] -- utc date time of last update
  FROM [cwwebapp_globaltsllc].[dbo].[v_rpt_Company]
