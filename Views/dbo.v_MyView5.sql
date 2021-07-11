/*****************************************************************************************************************
NAME:    dbo.Top10MaxLoanAmtView
PURPOSE: Create the dbo.Top10MaxLoanAmtView view
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

SELECT TOP 10 * FROM dbo.tblAcctDim tad
WHERE tad.loan_amt = 1000000.0000

SELECT max(loan_amt) FROM dbo.tblAcctDim tad
