/*****************************************************************************************************************
NAME:    dbo.AcctByBranchView
PURPOSE: Create the dbo.AcctByBranchView view
SUPPORT: NHILE ntll2@ensign.edu
MODIFICATION LOG:
Ver       Date         Author       Description
-------   ----------   ----------   -----------------------------------------------------------------------------
1.0       06/03/2021   NHILE        1. Built this view
1.1       06/11/2021   NHILE        1. Improved this view with description
RUNTIME:1. min
NOTES:The idea is that a small number of load Product Detail Codes were found in more than one source system.
When we observe these N:N relationships during the recent past the count of Accounts is how we can resolve them.
LICENSE:This code is covered by the GNU General Public License which guarantees end usersthe freedom to run, study, share, and modify the code. 
This license grants the recipientsof the code the rights of the Free Software Definition. 
All derivative work can only bedistributed under the same license terms.
******************************************************************************************************************/

SELECT tad.branch_id, count(tad.acct_id) AS acct_count_2017 FROM dbo.tblAcctDim tad
where year(open_date) = 2017
group BY tad.branch_id
ORDER BY tad.branch_id

SELECT branch_id, count(tad.acct_id) as acct_count_2018 FROM dbo.tblAcctDim tad
where year(open_date) = '2018'
group BY tad.branch_id
ORDER BY tad.branch_id

SELECT branch_id, count(tad.acct_id) as acct_count_2016 FROM dbo.tblAcctDim tad
where year(open_date) = '2016'
group BY tad.branch_id
ORDER BY tad.branch_id
