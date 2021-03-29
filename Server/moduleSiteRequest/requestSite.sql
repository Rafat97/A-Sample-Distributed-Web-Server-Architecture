-- IMPORTANCE TASK IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\1.sql" 

-- PACKAGES IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\packages.sql"

-- FUNCTION_PROCEDURE IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\function_procedure.sql"

-- TRIGGER IMPORT
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\lib\trigger.sql"


--BEGIN
--    EXECUTE IMMEDIATE 'SELECT * FROM SITES_LOG';
--    
--    EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('Please check database properly' || CHR(10) || SQLCODE || ' ' || SQLERRM);
--END;
--/

-- Show All The Sitess
@"C:\Users\rafat\OneDrive\Desktop\SQL Project\Server\moduleSiteInfo\showSite.sql"


BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('Request Webpage' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/

CREATE OR REPLACE TRIGGER TR_BFR_INS_SITES_LOG
BEFORE INSERT
ON SITES_LOG
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;    
    linkName VARCHAR2(10) := '';
    statusCheck number := 0;
    reqPath VARCHAR2(500) := '';
    q VARCHAR2(500):= '';
BEGIN
--    DBMS_OUTPUT.PUT_LINE('CHECKING STATUS' || CHR(10) );
    linkName := UPPER( AddSitePack.linkName(:NEW.SiteID) );
    reqPath := :NEW.requestedPath;
    statusCheck := checkStatus(linkName);
    IF statusCheck >= 1 THEN
--        DBMS_OUTPUT.PUT_LINE('CHECKING REQUESTED PATH' || CHR(10) );
         :NEW.responseCode := 404;
         RequestContentPack.getSiteWebContent(:NEW.SiteID,  :NEW.requestedPath , :NEW.responseCode);
--         DBMS_OUTPUT.PUT_LINE('INSERT INTO '|| linkName || CHR(10) );
         q :=  'INSERT INTO SITES_LOG@'|| linkName ||' VALUES ('''||:NEW.LogId||''' ,'''||:NEW.requestedPath||''', '''||:NEW.responseCode||''', '''||:NEW.CreatedAt||''')';
         execute immediate  q  ;
     END IF;
     DBMS_OUTPUT.PUT_LINE('BEFORE INSERT LOG VALUE IS - ' || CHR(10) );
     DBMS_OUTPUT.PUT_LINE(
     'DB_LINK = ' || linkName || CHR(10) || 
     'SERVER_TLS_STATUS = ' || statusCheck || CHR(10)  || 
     'RESPONSE CODE = ' ||:NEW.responseCode || CHR(10)  ||
     'REQUEST PATH = ' || reqPath  || CHR(10)  ||
     'REQUEST TIME = ' || :NEW.CreatedAt  || CHR(10)  );
     
     
     commit;
END;
/


ACCEPT inputSiteId number PROMPT "Please select a site id = ";
ACCEPT inputRequestPath CHAR PROMPT "Enter site request path = ";


DECLARE
	sId number := 0;
	requestPath varchar2(255);
    q varchar(500) := '';
    cnt int:= 0;
    INPUTED_SITEID_INVALID EXCEPTION;
    INPUTED_WEB_ADDRESS_INVALID EXCEPTION;
BEGIN

    sId := &inputSiteId;
    requestPath := '&inputRequestPath';
    
    SELECT count(*) into cnt FROM SITES_INFO where sites_info.siteid = sId;
    
    if cnt <= 0 THEN
        RAISE INPUTED_SITEID_INVALID;
    END IF;
    
    q :=  'INSERT INTO SITES_LOG (LogId, SiteID, requestedPath) VALUES (SITES_LOG_LogId.nextval, :1 ,:2 )';
    execute immediate  q  using  sId, requestPath;
    
    EXCEPTION
    WHEN INPUTED_SITEID_INVALID THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Please check site id properly , EXCEPTION IS - INPUTED_SITEID_INVALID');
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



