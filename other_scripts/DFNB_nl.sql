SQLServerCodeHeader
/*****************************************************************************************************************
NAME:    dbo.DFNB_nl.sql
PURPOSE: Create the dbo.DFNB_nl.sql
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

--CREATE TABLE tblAcctCustRoleDim 

SELECT DISTINCT sp.acct_id, sp.cust_id,sp.acct_cust_role_id ,sp.as_of_date
INTO tblAcctCustRoleDim
FROM dbo.stg_p1 sp
ORDER BY sp.acct_id,sp.as_of_date;

--Create primary key for tblAcctCustRoleDim
ALTER TABLE dbo.tblAcctCustRoleDim
ADD CONSTRAINT PK_tblAcctCustRoleDim PRIMARY KEY (acct_id,cust_id,as_of_date);

--create table tblCustFactDim
SELECT DISTINCT sp.as_of_date, sp.acct_id, sp.cur_bal
INTO tblCustFactDim
from dbo.stg_p1 sp
ORDER BY acct_id, as_of_date;

-- create table tblAcctDim
SELECT distinct [acct_id2]	
      ,[prod_id]	
      ,[open_date]	
      ,[close_date]	
      ,[open_close_code]	
      ,[branch_id]	
      ,[acct_rel_id]	
      ,[pri_cust_id]	
      ,[loan_amt]	
	  ,[acct_region_id]
      ,[acct_area_id]	
	  INTO tblAcctDim
	  FROM dbo.stg_p1 sp

--create Foreign Keys for tblAcctDim
ALTER TABLE dbo.tblAcctDim
ADD CONSTRAINT FK_tblAcctDimProdtblProdDim
FOREIGN KEY (Prod_id) REFERENCES dbo.tblProdDim(prod_id);

--create Foreign Key for tblAreaDim
ALTER TABLE dbo.tblBranchDim
ADD CONSTRAINT FK_tblBranchDimtblAreaDim
FOREIGN KEY (area_id) REFERENCES dbo.tblAreaDim(area_id);

--create Foreign Key for tblRegionDim
ALTER TABLE dbo.tblBranchDim
ADD CONSTRAINT FK_tblBranchDimtblRegionDim
FOREIGN KEY (region_id) REFERENCES dbo.tblRegionDim(region_id);

USE DFNB2
GO

--Create a backup table

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

-- Profitability: create view TranFeeandAmount
SELECT ttfd.branch_id, sum(ttfd.tran_fee_amt) AS total_tran_fee_amt, sum(ttfd.tran_amt) AS total_tran_amt FROM dbo.tblTranFactDim ttfd
GROUP BY ttfd.branch_id

-- create view BranchNumofTran
SELECT ttfd.branch_id, ttfd.tran_type_id, count(tran_id) AS num_of_tran FROM dbo.tblTranFactDim ttfd
GROUP BY ttfd.branch_id,ttfd.tran_type_id
ORDER BY ttfd.branch_id,ttfd.tran_type_id


-- counting number of transactions for each account in branch 1
SELECT spu.acct_id, count(spu.tran_ID) AS num_of_tran_branch_1 FROM dbo.stg_p2_update spu
WHERE spu.branch_id = 1
GROUP BY spu.acct_id
ORDER BY num_of_tran_branch_1 DESC
-- acct_id -1, 52951, 81524 with 12 tran

-- counting number of transactions for each account in branch 2
SELECT spu.acct_id, count(spu.tran_ID) AS num_of_tran_branch_2 FROM dbo.stg_p2_update spu
WHERE spu.branch_id = 2
GROUP BY spu.acct_id
ORDER BY num_of_tran_branch_2 DESC

-- create view AcctNumofTran to show number of transactions for each account at each branch
SELECT ttfd.acct_id, ttfd.branch_id, count(ttfd.tran_ID) AS num_of_acct from dbo.tblTranFactDim ttfd
GROUP BY ttfd.acct_id, ttfd.branch_id
ORDER BY num_of_acct DESC

--create view TopAcct with top accounts transacting in each branch
SELECT ttfd.acct_id, ttfd.branch_id, count(ttfd.tran_ID) AS num_of_acct from dbo.tblTranFactDim ttfd
GROUP BY ttfd.acct_id, ttfd.branch_id
Having count(ttfd.tran_ID) = 12
ORDER BY branch_id, num_of_acct DESC

--Who are the top Customers transacting at each Branch?
--create TopCust view with top transacting customers in each branch
SELECT tcd.cust_id, tcd.last_name, tcd.first_name, topacct.acct_id, topacct.branch_id from dbo.tblCustDim tcd
INNER JOIN dbo.tblAcctDim tad
ON tad.pri_cust_id = tcd.cust_id
INNER JOIN TopAcct
ON topacct.acct_id = tad.acct_id
ORDER BY tad.branch_id

--Do these top Customers transact at other Branch locations? No because the number of outputs from this = to TopCust View = 42
SELECT DISTINCT tcd.cust_id, tcd.last_name, tcd.first_name, topacct.acct_id, topacct.branch_id from dbo.tblCustDim tcd
INNER JOIN dbo.tblAcctDim tad
ON tad.pri_cust_id = tcd.cust_id
INNER JOIN TopAcct
ON topacct.acct_id = tad.acct_id


--create tblBranchSum
SELECT tad.branch_id
	, year (tad.open_date) AS open_year
	, sum (tad.loan_amt) AS total_loan_branch
	INTO tblBranchSum
	from dbo.tblAcctDim tad
	GROUP BY tad.branch_id,year(tad.open_date)
	ORDER BY tad.branch_id,year(tad.open_date)

--create tblProdSum
	SELECT tad.prod_id
	, year (tad.open_date) AS open_year
	, sum (tad.loan_amt) AS total_loan_prod
	INTO tblProdSum
	from dbo.tblAcctDim tad
	GROUP BY tad.prod_id,year(tad.open_date)
	ORDER BY tad.prod_id,year(tad.open_date)


--create tblAreaSum
SELECT tad.area_id
	, year (tad.open_date) AS open_year
	, sum (tad.loan_amt) AS total_loan_area
	INTO tblAreaSum
	from dbo.tblAcctDim tad
	GROUP BY tad.area_id,year(tad.open_date)
	ORDER BY tad.area_id,year(tad.open_date)

--create View TotalLoanAmtBank
CREATE VIEW TotalLoanAmtBank AS 
SELECT year(dbo.tblAcctDim.open_date) AS open_year,
	sum (dbo.tblAcctDim.loan_amt) AS total_loan_bank
 from dbo.tblAcctDim
 GROUP BY year(dbo.tblAcctDim.open_date)


  --create View TotalNumofAccbyBranch
CREATE VIEW TotalNumofAccbyBranch AS
SELECT tad.prod_id
	, year (tad.open_date) AS open_year
	, count(tad.acct_id) AS total_acct_branch
	from dbo.tblAcctDim tad
	GROUP BY tad.prod_id,year(tad.open_date)

 --create View TotalNumofAccbyArea
CREATE VIEW TotalNumofAccbyArea AS
SELECT tad.area_id
	, year (tad.open_date) AS open_year
	, count(tad.acct_id) AS total_acct_area
	from dbo.tblAcctDim tad
	GROUP BY tad.area_id,year(tad.open_date)


 --create View TotalNumofAccbyRegion
CREATE VIEW TotalNumofAccbyRegion AS
SELECT tad.region_id
	, year (tad.open_date) AS open_year
	, count(tad.acct_id) AS total_acct_area
	from dbo.tblAcctDim tad
	GROUP BY tad.region_id,year(tad.open_date)


 --create View TotalNumofAcct
CREATE VIEW TotalNumofAcct AS
SELECT year (tad.open_date) AS open_year
	, count(tad.acct_id) AS total_acct_area
	from dbo.tblAcctDim tad
	GROUP BY year(tad.open_date)