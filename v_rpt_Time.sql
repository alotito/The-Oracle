SELECT [Time_RecID] -- time record index
      ,[member_recid] -- forigen key to v_rpt_member
      ,[member_id] -- member id (v_rpt_member.member_id)
      ,[first_name] -- tech first name
      ,[last_name] -- tech last name
      ,[Company_RecID] -- forigen key to v_rpt_company
      ,[company_name] --company name
      ,[Date_Start] -- date part of time entry start
      ,[time_start] -- time part of time entry start
      ,[time_end] -- time part of time entry end
      ,[date_entered_utc] -- date the time entry (UTC) that the time entry was recorded. if the date entered and the date/time start (adjusted for timezone) is not the same then the time was entered after the fact.
      ,[hours_actual] -- actual hours recorded.
      ,[Billable_Hrs] -- billable hours recorded. billabel is actaul time entires rouded up to the next 15 minutes
      ,[SR_Service_RecID] -- forigen key to v_rpt_service. Also the Ticket Number.
      ,[sr_summary] -- summary of ticket (v_rpt_service.summary)
      ,[sr_status] -- status of ticket	 (v_rpt_service.sr_status)
      ,[Notes] -- ticket note associated to this time entry
      ,[Updated_By] -- member_id of member that updated this record.
      ,[Last_Update] --date time stamp of the last update to this record.
  FROM [cwwebapp_globaltsllc].[dbo].[v_rpt_Time]