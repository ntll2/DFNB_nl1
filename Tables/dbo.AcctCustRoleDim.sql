USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblAcctCustRoleDim]    Script Date: 7/11/2021 3:24:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAcctCustRoleDim](
	[acct_id] [int] NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[acct_cust_role_id] [smallint] NOT NULL,
	[as_of_date] [date] NOT NULL,
 CONSTRAINT [PK_tblAcctCustRoleDim] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[cust_id] ASC,
	[as_of_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


