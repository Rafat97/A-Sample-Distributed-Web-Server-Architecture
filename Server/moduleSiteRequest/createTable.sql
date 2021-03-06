DROP TABLE SITES_LOG CASCADE CONSTRAINTS PURGE;  
DROP SEQUENCE SITES_LOG_LogId;

DROP TABLE SITES_SUBSCRIBE_CACHE CASCADE CONSTRAINTS; 
DROP SEQUENCE SITES_SUBSCRIBE_CACHE_SUBID;

CREATE SEQUENCE SITES_LOG_LogId
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10;


CREATE SEQUENCE SITES_SUBSCRIBE_CACHE_SUBID
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10;


CREATE TABLE SITES_LOG (
    LogId int NOT NULL ,
    SiteID int ,
    requestedPath varchar2(255) NOT NULL ,
    responseCode int DEFAULT 500,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (LogId),
    FOREIGN KEY (SiteID) REFERENCES SITES_INFO(SiteID) ON DELETE SET NULL
);


CREATE TABLE SITES_SUBSCRIBE_CACHE (
    SubId int NOT NULL ,
    SiteID int ,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (SubId),
    FOREIGN KEY (SiteID) REFERENCES SITES_INFO(SiteID) ON DELETE SET NULL
);


SELECT * FROM SITES_LOG;
SELECT * FROM SITES_SUBSCRIBE_CACHE;


--INSERT INTO SITES_LOG  (LogId, SiteID, requestedPath, responseCode) VALUES (SITES_LOG_LogId.nextval, 1, '/asd', 500 );
--INSERT INTO SITES_LOG  (LogId, SiteID, requestedPath, responseCode) VALUES (SITES_LOG_LogId.nextval, 1, '/werwe', 500 );
--INSERT INTO SITES_LOG  (LogId, SiteID, requestedPath, responseCode) VALUES (SITES_LOG_LogId.nextval, 1, '/asdfewrwssd', 500 );


--INSERT INTO SITES_SUBSCRIBE_CACHE  (SubId, SiteID) VALUES (SITES_SUBSCRIBE_CACHE_SUBID.nextval, 1 );

COMMIT;