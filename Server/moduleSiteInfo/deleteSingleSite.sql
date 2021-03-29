clear screen;
-- IMPORTANCE TASK IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\1.sql" 

-- PACKAGES IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\packages.sql"

-- FUNCTION_PROCEDURE IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\function_procedure.sql"

-- TRIGGER IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\trigger.sql"


@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\moduleSiteInfo\showSite.sql"
    

BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('DELETE SINGLE SITE' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/


ACCEPT inputedSiteID number PROMPT "ENTER SITEID WHICH YOU WANT TO DELETE = ";

DECLARE
    cont int := 0;
    linkName VARCHAR2(10) := '';
	siteSts VARCHAR2(20) := '';
    siteIdInp  number := 0;
    i number := 0;
	viewName VARCHAR2(10):= '';
BEGIN
     siteIdInp := &inputedSiteID;
     
     SELECT count(*) into cont  FROM SITES_INFO WHERE SITES_INFO.SiteID = siteIdInp;
     
     IF cont >= 1 THEN
		linkName := UPPER( AddSitePack.linkName(siteIdInp) );
		viewName :=  linkName ||'$view';
         SELECT  SiteStatus into siteSts  FROM SITES_INFO WHERE SITES_INFO.SiteID = siteIdInp;
		 IF siteSts = 'ACTIVE' THEN
			DBMS_SESSION.CLOSE_DATABASE_LINK(linkName);
		 END IF;
		DELETE FROM SITES_INFO  WHERE  SITES_INFO.SiteID = siteIdInp ;
		EXECUTE IMMEDIATE 'drop database link "'|| linkName ||'"';
		DBMS_OUTPUT.PUT_LINE(linkName || ' is deleted !');
		commit ;
    ELSE 
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Sorry! No site found. Please select corrent option ');
    END IF;
     
    DBMS_OUTPUT.PUT_LINE(cont ||' row(s) is deleted '|| CHR(10));


END;
/
commit;
    