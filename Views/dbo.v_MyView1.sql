/*****************************************************************************************************************
NAME:    dbo.LoanCurBalView
PURPOSE: Create the dbo.LoanCurBalView view
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

select tcfd.acct_id, tcfd.as_of_date,tad.branch_id, tad.loan_amt, tcfd.cur_bal
from dbo.tblCustFactDim tcfd
inner join (
select tcfd.acct_id, max(tcfd.as_of_date) as MaxDate
from dbo.tblCustFactDim tcfd
group by tcfd.acct_id
) tm on tcfd.acct_id = tm.acct_id and tcfd.as_of_date = tm.MaxDate
INNER JOIN dbo.tblAcctDim tad
ON tcfd.acct_id = tad.acct_id
ORDER BY tcfd.acct_id
