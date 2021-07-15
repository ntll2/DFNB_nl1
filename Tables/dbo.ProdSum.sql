USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblProdSum]    Script Date: 7/14/2021 10:41:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblProdSum](
	[prod_id] [smallint] NOT NULL,
	[open_year] [int] NOT NULL,
	[total_loan_prod] [decimal](38, 4) NULL,
 CONSTRAINT [PK_tblProdSum] PRIMARY KEY CLUSTERED 
(
	[prod_id] ASC,
	[open_year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


