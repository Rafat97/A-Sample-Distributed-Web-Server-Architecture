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
    DBMS_OUTPUT.PUT_LINE('SHOW ALL SITES' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/

DECLARE
    linkName VARCHAR2(10) := '';
    statusCheck number := 0;
    cont int := 0;
BEGIN
    FOR R IN (SELECT * FROM SITES_INFO order by SiteID asc ) LOOP
        DBMS_OUTPUT.PUT_LINE('Checking...');
        linkName := UPPER( AddSitePack.linkName(R.siteId) );
        statusCheck := checkStatus(linkName);
        DBMS_OUTPUT.PUT_LINE(linkName || ' -- ' || statusCheck);
        IF statusCheck >= 1 THEN
             EXECUTE IMMEDIATE 'UPDATE SITES_INFO SET sitestatus = ''ACTIVE'' where SiteID='|| R.siteId ||'';
        ELSE
            EXECUTE IMMEDIATE 'UPDATE SITES_INFO SET sitestatus = ''INACTIVE'' where SiteID='|| R.siteId ||' ';
        END IF; 
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Site ID' || ' || ' || 'Site link'  || ' || ' || 'Site IP' || ' || ' || 'Site Address'  || ' || ' || 'Site Status' );  
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
	FOR R IN (SELECT * FROM SITES_INFO order by SiteID asc ) LOOP
        linkName := UPPER( AddSitePack.linkName(R.siteId) );
        DBMS_OUTPUT.PUT_LINE(R.SiteID || ' || ' || linkName || ' || ' || R.SiteIP || ' || ' || R.SiteAddress || ' || ' || R.SiteStatus );   
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    SELECT count(*) into cont  FROM DBA_DB_LINKS where owner = 'SYSTEM';
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE( cont ||' row(s) is founded '|| CHR(10));
    
END;
/

commit;


    