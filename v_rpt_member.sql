CREATE TABLE v_rpt_member (
    Member_RecID INT, -- member/tech index
    Member_ID NVARCHAR(30), -- member id
    First_Name NVARCHAR(60), -- fisrt name
    Last_Name NVARCHAR(60), -- last name
    Member_Type_Desc NVARCHAR(100), -- title
    --Member_Type_Desc NVARCHAR(60), -- member type
    Email_Address NVARCHAR(500), -- email address
    Inactive_Flag BIT, -- not active tech if true
    Date_Inactive DATETIME -- date tech become inactive. full date time stamp yyyy-mm-dd hh:mm:ss
);
