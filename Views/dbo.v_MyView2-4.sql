/*****************************************************************************************************************
NAME:    dbo.TopAcct.sql
PURPOSE: Create view dbo.TopAcct.sql
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

--create view TopAcct with top accounts transacting in each branch
SELECT ttfd.acct_id, ttfd.branch_id, count(ttfd.tran_ID) AS num_of_acct from dbo.tblTranFactDim ttfd
GROUP BY ttfd.acct_id, ttfd.branch_id
Having count(ttfd.tran_ID) = 12
ORDER BY branch_id, num_of_acct DESC
