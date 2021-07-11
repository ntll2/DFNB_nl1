USE [DFNB2]
GO

/****** Object:  Table [dbo].[tblTranFact]    Script Date: 7/11/2021 3:17:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTranFact](
	[tran_ID] [int] NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[acct_id] [int] NOT NULL,
	[tran_date] [date] NOT NULL,
	[tran_time] [time](7) NOT NULL,
	[tran_type_id] [smallint] NOT NULL,
	[tran_amt] [int] NOT NULL,
	[tran_fee_amt] [decimal](15, 3) NOT NULL,
 CONSTRAINT [PK_tblTranFact] PRIMARY KEY CLUSTERED 
(
	[tran_ID] ASC,
	[branch_id] ASC,
	[tran_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblTranFact]  WITH CHECK ADD  CONSTRAINT [FK_tblTranFact_tblTranTypeDim] FOREIGN KEY([tran_type_id])
REFERENCES [dbo].[tblTranTypeDim] ([tran_type_id])
GO

ALTER TABLE [dbo].[tblTranFact] CHECK CONSTRAINT [FK_tblTranFact_tblTranTypeDim]
GO


