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
    DBMS_OUTPUT.PUT_LINE('DELETE ALL SITE' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/

DECLARE
    cont int := 0;
    linkName VARCHAR2(10) := '';
    optionVal number := 0;
    selectID number := 0;
	viewName VARCHAR2(10):= '';
BEGIN

    SELECT count(*) into cont  FROM DBA_DB_LINKS where owner = 'SYSTEM';
    
    FOR R IN (SELECT * FROM SITES_INFO) LOOP
        linkName := UPPER( AddSitePack.linkName(R.siteId) );
		viewName :=  linkName ||'$view';
        if R.SiteStatus = 'ACTIVE' THEN
            DBMS_SESSION.CLOSE_DATABASE_LINK(linkName);
        END IF;
        
        DELETE FROM SITES_INFO  WHERE  siteid = R.siteid;
        EXECUTE IMMEDIATE 'drop database link "'|| linkName ||'"';
		DBMS_OUTPUT.PUT_LINE(linkName || ' is deleted !');
		
	END LOOP;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE( cont ||' row(s) is deleted '|| CHR(10));

END;
/
commit;
    