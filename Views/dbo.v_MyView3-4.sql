/*****************************************************************************************************************
NAME:    dbo.TotalNumofAccbyRegion.sql
PURPOSE: Create view dbo.TotalNumofAccbyRegion.sql
SUPPORT: NHILE ntll2@ensign.edu
MODIFICATION LOG:
Ver       Date         Author       Description
-------   ----------   ----------   -----------------------------------------------------------------------------
1.0       07/14/2021   NHILE        1. Built this view
1.1       07/14/2021   NHILE        1. Improved this view with description
RUNTIME:2. min
NOTES:The idea is that a small number of load Product Detail Codes were found in more than one source system.
When we observe these N:N relationships during the recent past the count of Accounts is how we can resolve them.
LICENSE:This code is covered by the GNU General Public License which guarantees end usersthe freedom to run, study, share, and modify the code. 
This license grants the recipientsof the code the rights of the Free Software Definition. 
All derivative work can only bedistributed under the same license terms.
******************************************************************************************************************/


CREATE VIEW TotalNumofAccbyRegion AS
SELECT tad.region_id
	, year (tad.open_date) AS open_year
	, count(tad.acct_id) AS total_acct_area
	from dbo.tblAcctDim tad
	GROUP BY tad.region_id,year(tad.open_date)