SQLServerCodeHeader
/*****************************************************************************************************************
NAME:    dbo.LoadDFNB_p2.sql
PURPOSE: Create dbo.LoadDFNB_p2.sql
SUPPORT: NHILE ntll2@ensign.edu
MODIFICATION LOG:
Ver       Date         Author       Description
-------   ----------   ----------   -----------------------------------------------------------------------------
1.0       06/25/2021   NHILE        1. Built this view
1.1       06/25/2021   NHILE        1. Improved this view with description
RUNTIME:1. min
NOTES:The idea is that a small number of load Product Detail Codes were found in more than one source system.
When we observe these N:N relationships during the recent past the count of Accounts is how we can resolve them.
LICENSE:This code is covered by the GNU General Public License which guarantees end usersthe freedom to run, study, share, and modify the code. 
This license grants the recipientsof the code the rights of the Free Software Definition. 
All derivative work can only bedistributed under the same license terms.
******************************************************************************************************************/

USE DFNB2
GO

--Create a backup table
--SELECT [branch_id]
--      ,[acct_id]
--      ,[tran_date]
--      ,[tran_time]
--      ,[tran_type_id]
--      ,[tran_type_code]
--      ,[tran_type_desc]
--      ,[tran_fee_prct]
--      ,[cur_cust_req_ind]
--      ,[tran_amt]
--      ,[tran_fee_amt]
--	  INTO stg_p2_backup
--	  FROM dbo.stg_p2 sp

TRUNCATE TABLE stg_p2_backup
INSERT INTO stg_p2_backup

SELECT [branch_id]
      ,[acct_id]
      ,[tran_date]
      ,[tran_time]
      ,[tran_type_id]
      ,[tran_type_code]
      ,[tran_type_desc]
      ,[tran_fee_prct]
      ,[cur_cust_req_ind]
      ,[tran_amt]
      ,[tran_fee_amt]
	  INTO stg_p2_backup
	  FROM dbo.stg_p2 sp
	  

-- Create table with Transaction ID 
--SELECT 
--  ROW_NUMBER() OVER(ORDER BY sp.branch_id, sp.acct_id) AS tran_ID,
--		[branch_id]
--      ,[acct_id]
--      ,[tran_date]
--      ,[tran_time]
--      ,[tran_type_id]
--      ,[tran_type_code]
--      ,[tran_type_desc]
--      ,[tran_fee_prct]
--      ,[cur_cust_req_ind]
--      ,[tran_amt]
--      ,[tran_fee_amt]
--	  INTO stg_p2_update
--FROM dbo.stg_p2 sp

TRUNCATE TABLE stg_p2_update
INSERT INTO stg_p2_update

SELECT 
  ROW_NUMBER() OVER(ORDER BY sp.branch_id, sp.acct_id) AS tran_ID,
		[branch_id]
      ,[acct_id]
      ,[tran_date]
      ,[tran_time]
      ,[tran_type_id]
      ,[tran_type_code]
      ,[tran_type_desc]
      ,[tran_fee_prct]
      ,[cur_cust_req_ind]
      ,[tran_amt]
      ,[tran_fee_amt]
	  INTO stg_p2_update
FROM dbo.stg_p2 sp

--create tblTranFactDim
SELECT [tran_ID]
      ,[branch_id]
      ,[acct_id]
      ,[tran_date]
      ,[tran_time]
      ,[tran_type_id]
      ,[tran_amt]
      ,[tran_fee_amt]
	  INTO tblTranFactDim
	  FROM dbo.stg_p2_update spu

--create tblTranTypeDim
SELECT DISTINCT [tran_type_id]
      ,[tran_type_code]
      ,[tran_type_desc]
      ,[tran_fee_prct]
      ,[cur_cust_req_ind]
	  INTO tblTranTypeDim
	  FROM dbo.stg_p2_update spu

--create foreign keys for tblTranFactDim
ALTER TABLE dbo.tblTranFactDim
ADD CONSTRAINT FK_tblTranFactDim_tblTranTypeDim
FOREIGN KEY (tran_type_id) REFERENCES dbo.tblTranTypeDim(tran_type_id);
