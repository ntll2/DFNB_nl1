/*****************************************************************************************************************
NAME:    dbo.TopCust.sql
PURPOSE: Create view dbo.TopCust.sql
SUPPORT: NHILE ntll2@ensign.edu
MODIFICATION LOG:
Ver       Date         Author       Description
-------   ----------   ----------   -----------------------------------------------------------------------------
1.0       06/25/2021   NHILE        1. Built this view
1.1       07/11/2021   NHILE        1. Improved this view with description
RUNTIME:2. min
NOTES:The idea is that a small number of load Product Detail Codes were found in more than one source system.
When we observe these N:N relationships during the recent past the count of Accounts is how we can resolve them.
LICENSE:This code is covered by the GNU General Public License which guarantees end usersthe freedom to run, study, share, and modify the code. 
This license grants the recipientsof the code the rights of the Free Software Definition. 
All derivative work can only bedistributed under the same license terms.
******************************************************************************************************************/

--Who are the top Customers transacting at each Branch?
--create TopCust view with top transacting customers in each branch
SELECT tcd.cust_id, tcd.last_name, tcd.first_name, topacct.acct_id, topacct.branch_id from dbo.tblCustDim tcd
INNER JOIN dbo.tblAcctDim tad
ON tad.pri_cust_id = tcd.cust_id
INNER JOIN TopAcct
ON topacct.acct_id = tad.acct_id
ORDER BY tad.branch_id
