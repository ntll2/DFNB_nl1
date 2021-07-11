USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblBranchAddDim]    Script Date: 7/11/2021 3:22:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblBranchAddDim](
	[branch_add_id] [int] NOT NULL,
	[branch_lat] [decimal](16, 12) NOT NULL,
	[branch_lon] [decimal](16, 12) NOT NULL,
	[branch_add_type] [varchar](1) NOT NULL,
 CONSTRAINT [PK_tblBranchAddDim] PRIMARY KEY CLUSTERED 
(
	[branch_add_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


