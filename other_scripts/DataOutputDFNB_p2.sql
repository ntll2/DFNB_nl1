
/*****************************************************************************************************************
NAME:    dbo.DataOutputDFNB_p2.sql
PURPOSE: Create the dbo.DataOutputDFNB_p2.sql
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

-- Profitability: create view TranFeeandAmount
SELECT ttfd.branch_id, sum(ttfd.tran_fee_amt) AS total_tran_fee_amt, sum(ttfd.tran_amt) AS total_tran_amt FROM dbo.tblTranFactDim ttfd
GROUP BY ttfd.branch_id

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