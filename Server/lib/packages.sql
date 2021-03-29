CREATE OR REPLACE PACKAGE AddSitePack AS
    FUNCTION linkName(siteId IN NUMBER)
	RETURN VARCHAR2;

	PROCEDURE createDBLink(siteId IN NUMBER , siteIp IN VARCHAR2, sitePass in VARCHAR2, sitePort IN NUMBER);
	
	PROCEDURE siteIntoSubs(siteId IN NUMBER);
END AddSitePack;
/


CREATE OR REPLACE PACKAGE BODY AddSitePack AS

    FUNCTION linkName(siteId IN NUMBER)
	RETURN VARCHAR2
	IS 
    linkName VARCHAR2(10):= '';
	BEGIN
		linkName := 'site' || siteId;
        RETURN linkName;
	END linkName;

	PROCEDURE createDBLink(siteId IN NUMBER , siteIp IN VARCHAR2, sitePass in VARCHAR2, sitePort IN NUMBER)
	IS
	q  VARCHAR2(500):= '';
    linkName VARCHAR2(10):= '';
	BEGIN
        
        linkName := AddSitePack.linkName(siteId);
		q := 'CREATE database link '|| linkName ||' connect to system identified by "'|| sitePass ||'" using ';
        
       q := q || '''(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = '|| siteIp ||')
		 (PORT = '||sitePort ||'))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )''';
     
--    DBMS_OUTPUT.PUT_LINE(q);
    execute immediate q;
    
    commit;
    
	END createDBLink;
	

	PROCEDURE siteIntoSubs(siteId IN NUMBER)
	IS
	q  VARCHAR2(500):= '';
	BEGIN
	
	q := 'INSERT INTO SITES_SUBSCRIBE_CACHE  (SubId, SiteID) VALUES (SITES_SUBSCRIBE_CACHE_SUBID.nextval, '|| siteId ||')';
    execute immediate q;
    
    commit;
    
	END siteIntoSubs;
    
	
END AddSitePack;
/










CREATE OR REPLACE PACKAGE RequestContentPack AS
	PROCEDURE getSiteWebContent(siteId IN NUMBER,siteReqPath VARCHAR2, siteResponse IN Out NUMBER);
END RequestContentPack;
/


CREATE OR REPLACE PACKAGE BODY RequestContentPack AS

	PROCEDURE getSiteWebContent(siteId IN NUMBER,siteReqPath VARCHAR2, siteResponse IN Out NUMBER)
	IS
    
    lkName VARCHAR2(10) := '';
	q  VARCHAR2(500):= '';
    cnt number := 0;
    linkName VARCHAR2(10):= '';
    contentVal  VARCHAR2(5000);
    viewName VARCHAR2(10):= '';
	BEGIN
        lkName := UPPER( AddSitePack.linkName(siteId) );
        viewName :=  lkName ||'$view';
        q  := 'SELECT count (*) FROM '|| viewName ||' where requestedPath=''' || siteReqPath || ''' ';
        
        EXECUTE IMMEDIATE q INTO cnt;
        
        IF cnt >= 1 THEN
            siteResponse := 200;
			
			q  := 'SELECT responseContent FROM '|| viewName ||' where requestedPath=''' || siteReqPath || ''' ';
            
            EXECUTE IMMEDIATE q INTO contentVal;
            
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE('PAGE CONTENT' );
            DBMS_OUTPUT.PUT_LINE('-------------------------------------'|| chr(10) );
            DBMS_OUTPUT.PUT_LINE(contentVal);
            DBMS_OUTPUT.PUT_LINE(chr(10)|| '-------------------------------------');
			
			
        ELSE
            siteResponse := 404;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Sorry ! Data Not founds 404');
            DBMS_OUTPUT.PUT_LINE('-------------------------------------'|| chr(10) );
        END IF;     
        
        q := 'create or replace view '|| viewName ||' as SELECT PageId,responseContent,requestedPath  FROM SITES_WEB_PAGE@'|| lkName || '';
		EXECUTE IMMEDIATE q;
		COMMIT;
		
	EXCEPTION
    WHEN OTHERS THEN
		IF SQLCODE = -942 THEN
		q := 'create or replace view '|| viewName ||' as SELECT PageId,responseContent,requestedPath  FROM SITES_WEB_PAGE@'|| lkName || '';
		EXECUTE IMMEDIATE q;
		q :=  'INSERT INTO SITES_LOG (LogId, SiteID, requestedPath) VALUES (SITES_LOG_LogId.nextval, :1 ,:2 )';
		execute immediate  q  using  siteId, siteReqPath;
		
		COMMIT;
		END IF; 
        --DBMS_OUTPUT.PUT_LINE(CHR(10));
		--DBMS_OUTPUT.PUT_LINE('Some thing goes wrong' ||  CHR(10) || SQLCODE || CHR(10) || SQLERRM);
        --DBMS_OUTPUT.PUT_LINE(CHR(10));


    
	END getSiteWebContent;
    
	
END RequestContentPack;
/





