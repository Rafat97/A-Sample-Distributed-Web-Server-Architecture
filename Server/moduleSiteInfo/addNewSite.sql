clear screen;

-- IMPORTANCE TASK IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\1.sql" 

-- PACKAGES IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\packages.sql"

-- FUNCTION_PROCEDURE IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\function_procedure.sql"

-- TRIGGER IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\trigger.sql"


BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('ADD NEW SITE' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/

ACCEPT inputIpAddress CHAR PROMPT "ENTER IPv4 ADDRESS = ";
ACCEPT inputSiteName CHAR PROMPT "ENTER SITE NAME = "

DECLARE
	ipAddress varchar2(16);
	siteName varchar2(20);
    validIp number := 0;
    validAddress number := 0;
    tableName  varchar2(16) := 'SITES_INFO';
    q varchar(500) := '';
    INPUTED_IP_INVALID EXCEPTION;
    INPUTED_WEB_ADDRESS_INVALID EXCEPTION;
BEGIN
    ipAddress := TRIM('&inputIpAddress');
    siteName := TRIM('&inputSiteName');
    
    validIp :=  isIpValid(ipAddress);
    
    IF validIp <= 0 THEN
		RAISE INPUTED_IP_INVALID;
	END IF;
    
    validAddress :=  isWebAddressValid(siteName);
    IF validAddress <= 0 THEN
		RAISE INPUTED_WEB_ADDRESS_INVALID;
	END IF;
    
    q :=  'INSERT INTO '|| tableName ||' (SiteID, SiteIP, SiteAddress) VALUES (SITES_INFO_SITESID.nextval, :1 ,:2 )';
    execute immediate  q  using  ipAddress, siteName;
    commit;
    
    EXCEPTION
    WHEN INPUTED_IP_INVALID THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Give proper IP address, EXCEPTION IS - INPUTED_IP_INVALID ');
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    WHEN INPUTED_WEB_ADDRESS_INVALID THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Give proper web address, EXCEPTION IS - INPUTED_WEB_ADDRESS_INVALID');
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Duplicate values detected , EXCEPTION IS - DUP_VAL_ON_INDEX');
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
		DBMS_OUTPUT.PUT_LINE('Some thing goes wrong' ||  CHR(10) || SQLCODE || CHR(10) || SQLERRM);
        DBMS_OUTPUT.PUT_LINE(CHR(10));
END;
/

commit;

@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\moduleSiteInfo\showSite.sql"
    