CREATE TABLE v_rpt_Service (
    TicketNbr INT, -- The Service Ticket Number
    Board_Name NVARCHAR(100), -- The Name of the Service board where the ticket exists
    Site_Name NVARCHAR(100), -- The specific site with a location where the ticket/incident occurred
    status_description NVARCHAR(100), -- The current status of the ticket
    Source NVARCHAR(100), -- The source of the ticket
    Closed_Flag BIT, -- Flag indicating the ticket is closed (closed comes after Resolved)
    ClosedDesc VARCHAR(6), -- A text note describing the conditions of the close
    date_closed DATETIME, -- What date it was closed (local time NYC). full date time stamp yyyy-mm-dd hh:mm:ss
    closed_by NVARCHAR(30), -- What closed the tickets (process, workflow, integration, tech, etc)
    ServiceType NVARCHAR(100), -- The call driver of the ticket
    ServiceSubType NVARCHAR(100), -- The structural area where the fix was executed
    ServiceSubTypeItem NVARCHAR(100), -- The specific detail of where the fix was executed
    company_name NVARCHAR(100), -- The company name of the client
    company_recid INT, -- The company record id (v_rpt_company.company_recid)
    contact_name NVARCHAR(62), -- The contact name of the client
    contact_recid INT, -- The contact record id (v_rpt_contact.contact_recid)
    Summary NVARCHAR(200), -- The summary of the ticket
    Detail_Description NVARCHAR(MAX), -- The detailed description of the ticket
    Internal_Analysis NVARCHAR(MAX), -- The internal analysis notes of the ticket
    Resolution NVARCHAR(MAX), -- The resolution notes of the ticket
    agreement_name NVARCHAR(100), -- The agreement name associated with the ticket
    team_name NVARCHAR(60), -- The team name assigned to the ticket
    Territory NVARCHAR(100), -- The territory of the company
    Territory_Manager NVARCHAR(61), -- The manager of the territory
    date_entered DATETIME, -- The date the ticket was entered (local time NYC)
    entered_by NVARCHAR(30), -- Who entered the ticket
    Last_Update DATETIME, -- The last update date of the ticket. full date time stamp yyyy-mm-dd hh:mm:ss
    Date_Required DATETIME, -- The date the ticket is required to be completed by. full date time stamp yyyy-mm-dd hh:mm:ss
    Hours_Actual DECIMAL(10, 2), -- The actual hours worked on the ticket
    Hours_Budget DECIMAL(10, 2), -- The budgeted hours for the ticket
    Hours_Scheduled DECIMAL(10, 2), -- The scheduled hours for the ticket
    Hours_Billable DECIMAL(10, 2), -- The billable hours for the ticket
    Hours_NonBillable DECIMAL(10, 2), -- The non-billable hours for the ticket
    Hours_Invoiced DECIMAL(10, 2), -- The invoiced hours for the ticket
    Hours_Agreement DECIMAL(10, 2), -- The agreement hours for the ticket
    resource_list NVARCHAR(MAX), -- A comma-separated list of resources assigned to the ticket
    Assigned_By_RecID INT, -- Who assigned the ticket last (v_rpt_member.[Member_recid])
    Age DECIMAL(8, 1), -- Days since ticket was created
    Date_Resolved_UTC DATETIME2, -- Date of incident/ticket resolution in UTC. full date time stamp yyyy-mm-dd hh:mm:ss
    Date_Status_Changed_UTC DATETIME2, -- Date of the last ticket status change in UTC. full date time stamp yyyy-mm-dd hh:mm:ss
    Resolved_By NVARCHAR(30), -- Who actually resolved the incident (member_id)
    Resolved_Minutes INT, -- How many SLA minutes did it take to resolve the ticket
    Severity NVARCHAR(20), -- What is the severity of this incident
    Impact NVARCHAR(20), -- What is the impact of this ticket
    SR_Service_RecID INT, -- Same as ticket number
    Date_Entered_UTC DATETIME, -- The UTC date of ticket creation. full date time stamp yyyy-mm-dd hh:mm:ss
    Date_Closed_UTC DATETIME, -- The UTC date that the ticket was closed. full date time stamp yyyy-mm-dd hh:mm:ss
    config_recids NVARCHAR(MAX), -- A comma-separated list of configuration_recid, each one represents a computer.
    Priority_Description NVARCHAR(100), -- The priority of the ticket
    Ticket_Owner_RecID INT, -- The record id of the ticket owner (v_rpt_member.member_recid)
    Est_Start_Date_UTC DATETIME, -- The estimated start date of the ticket in UTC
    Initial_Description NVARCHAR(MAX), -- The initial description of the ticket
    Ticket_Owner_First_Name NVARCHAR(30), -- The first name of the ticket owner
    Ticket_Owner_Last_Name NVARCHAR(30), -- The last name of the ticket owner
    Closed_Age DECIMAL(8, 1), -- The age of the ticket in days when it was closed
    Priority_Level INT -- The priority level of the ticket
);
