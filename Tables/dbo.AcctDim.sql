USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblAcctDim]    Script Date: 7/11/2021 3:24:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAcctDim](
	[acct_id] [int] NOT NULL,
	[prod_id] [smallint] NOT NULL,
	[open_date] [date] NOT NULL,
	[close_date] [date] NOT NULL,
	[open_close_code] [varchar](1) NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[acct_rel_id] [smallint] NOT NULL,
	[pri_cust_id] [smallint] NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[acct_branch_id] [smallint] NOT NULL,
	[region_id] [int] NOT NULL,
	[area_id] [int] NOT NULL,
 CONSTRAINT [PK_tblAcctDim_1] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[prod_id] ASC,
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblAcctDim]  WITH CHECK ADD  CONSTRAINT [FK_tblAcctDimProdtblProdDim] FOREIGN KEY([prod_id])
REFERENCES [dbo].[tblProdDim] ([prod_id])
GO

ALTER TABLE [dbo].[tblAcctDim] CHECK CONSTRAINT [FK_tblAcctDimProdtblProdDim]
GO


