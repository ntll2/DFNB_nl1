USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblRegionSum]    Script Date: 7/14/2021 10:42:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblRegionSum](
	[region_id] [int] NOT NULL,
	[open_year] [int] NOT NULL,
	[total_loan_region] [decimal](38, 4) NULL,
 CONSTRAINT [PK_tblRegionSum] PRIMARY KEY CLUSTERED 
(
	[region_id] ASC,
	[open_year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


