SET SERVEROUTPUT ON;
SET FEEDBACK OFF;
SET VERIFY OFF;
SET AUTOCOMMIT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('ADD NEW WEBPAGE' || CHR(10));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------' || CHR(10));
END;
/



ACCEPT inputPath CHAR PROMPT "ENTER A NEW PATH = ";
ACCEPT inputContent CHAR PROMPT "ENTER A NEW PATH OF CONTENTS = ";
ACCEPT inputVersion CHAR PROMPT "ENTER A NEW PATH OF CONTENTS VERSION = ";

DECLARE
	sId number := 0;
	requestPath varchar2(255);
    q varchar(500) := '';
    cnt int:= 0;
	pathVal varchar(500) := '';
	contentVal varchar(3000) := '';
	versionVal varchar(500) := '';
BEGIN

    pathVal := '&inputPath';
    contentVal := '&inputContent';
	versionVal := '&inputVersion';
    
    q :=  'INSERT INTO SITES_WEB_PAGE (PageId, requestedPath, responseContent, version) VALUES (SITES_WEB_PAGE_PageId.nextval, :1 ,:2, :3 )';
    execute immediate  q  using  pathVal, contentVal, versionVal;
    
	DBMS_OUTPUT.PUT_LINE( CHR(10) || 'SUCCESSFULLY INSERTED' || CHR(10));
	
    EXCEPTION
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