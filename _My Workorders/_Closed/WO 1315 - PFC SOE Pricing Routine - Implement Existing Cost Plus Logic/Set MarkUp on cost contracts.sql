SELECT GETDATE()

UPDATE	CustomerMaster
SET	ContractSchd3 = null, ContractSchedule4 = null, ContractSchedule5 = null, ContractSchedule6 = null, ContractSchedule7 = null

SET	rowcount 0

--Get the unique Mark=up on Cost Price Groups from the Navision table
SELECT DISTINCT	([Customer No_] +  [Customer Price Group Code]) AS Cust_PG
INTO		#CG
FROM		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item_Cust_ Price Group]
ORDER BY	([Customer No_] +  [Customer Price Group Code])

SELECT		COUNT(DISTINCT(SUBSTRING(Cust_PG,1,6))) from #CG

--Add the Mark-up on Cost Contracts to the CustomerMaster
SET NOCOUNT ON
DECLARE	@Cust VARCHAR(6),
	@Group VARCHAR(10),
	@CurCust VARCHAR(6)
SET	@CurCust = NULL

DECLARE	SetCMUG Cursor FOR
SELECT	SUBString(Cust_PG,1,6), SubString(Cust_PG,7,10)
FROM	#CG

OPEN	SetCMUG
FETCH	NEXT
FROM	SetCmug
INTO	@Cust, @Group

DECLARE	@Cntrct1 VARCHAR(20),
	@Cntrct2 VARCHAR(20),
	@Cntrct3 VARCHAR(20),
	@Cntrct4 VARCHAR(20),
	@Cntrct5 VARCHAR(20),
	@Cntrct6 VARCHAR(20), 
	@Cntrct7 VARCHAR(20)

WHILE (@@Fetch_Status = 0)
     BEGIN
	--Set the current customer Contracts
	IF (ISNULL(@CurCust,'9') <> @Cust)
	     BEGIN
		SELECT	@Cntrct1 = ContractSchd1,
			@Cntrct2 = ContractSchd2,
			@Cntrct3 = ContractSchd3,
			@Cntrct4 = ContractSchedule4,
			@Cntrct5 = ContractSchedule5,
			@Cntrct6 = ContractSchedule6,
			@Cntrct7 = ContractSchedule7
		FROM	CustomerMaster
		WHERE	CustNo = @Cust

		SET	@CurCust = @Cust
	     END

	--Set Mark-up on cost group in Contract 1 if contract 1 IS NULL
	IF (@Cntrct1 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchd1 = @Group
		WHERE	CustNo = @Cust

		SET	@Cntrct1 = @Group
	     END	--Contract1 is used

	--Set Mark-up on cost group in Contract 2 if contract 2 IS NULL
	ELSE IF (@Cntrct2 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchd2 = @Group
		WHERE	CustNo = @Cust

		SET	@Cntrct2 = @Group
	     END	--Contract 2 is used

	--Set Mark-up on cost group in Contract 3 if contract 3 IS NULL
	ELSE IF (@Cntrct3 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchd3 = @Group
            	WHERE	CustNo = @Cust

		SET	@Cntrct3 = @Group
	     END	--Contract 3 is used

	--Set Mark-up on cost group in Contract 4 if contract 4 IS NULL
	ELSE IF (@Cntrct4 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchedule4 = @Group
		WHERE	CustNo = @Cust

		SET	@Cntrct4 = @Group
	     END	--Contract 4 is used

	--Set Mark-up on cost group in Contract 5 if contract 5 IS NULL
	ELSE IF (@Cntrct5 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchedule5 = @Group
		WHERE	CustNo = @Cust

		SET	@Cntrct5 = @Group
	     END	--Contract 5 is used

	--Set Mark-up on cost group in Contract 6 if contract 6 IS NULL
	ELSE IF (@Cntrct6 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchedule6 = @Group
		WHERE	CustNo = @Cust

		SET	@Cntrct6 = @Group
	     END	--Contract 6 is used

	--Set Mark-up on cost group in Contract 7 if contract 7 IS NULL
	ELSE IF (@Cntrct7 IS NULL)
	     BEGIN
		UPDATE	CustomerMaster
		SET	ContractSchedule7 = @Group
		WHERE	CustNo = @Cust
		SET	@Cntrct7 = @Group
	     END	--Contract 7 is used

	--Record no contract available for update if all contracts are in use
 	ELSE	INSERT INTO	ErrorLog
 				(AppFunction, ProcedureName, ErrorDesc, ErrorDt, EntryID, EntryDt, ServerName, DatabaseName)
 		SELECT		'UPDCustMUGroup', 'WO1028_UpdateCustomerMaster', 'Unable to Add '+@Group+ ' for Cust#'+@Cust, GETDATE(), 'SQLAgent', GETDATE(), 'PFCERPDB', 'PERP'

		FETCH	NEXT
		FROM	SetCMUG
		INTO	@Cust, @Group
 
	IF (@CurCust <> @Cust)
	     BEGIN        
		SET @Cntrct1 = NULL
		SET @Cntrct2 = NULL
		SET @Cntrct3 = NULL
		SET @Cntrct4 = NULL
		SET @Cntrct5 = NULL
		SET @Cntrct6 = NULL
		SET @Cntrct7 = NULL
	     END

     END  --While

CLOSE SetCMUG
DEALLOCATE SetCMUG
DROP TABLE #CG

SELECT GETDATE()
