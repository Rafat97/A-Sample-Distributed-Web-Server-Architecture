DROP TABLE SITES_WEB_PAGE CASCADE CONSTRAINTS; 
DROP SEQUENCE SITES_WEB_PAGE_PageId;

CREATE SEQUENCE SITES_WEB_PAGE_PageId
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE TABLE SITES_WEB_PAGE (
    PageId int NOT NULL ,
    requestedPath varchar2(255) NOT NULL UNIQUE,
    responseContent varchar2(3000) DEFAULT '<html><body><H1>Welcome To Site</H1></body></html>',
	version varchar2(100) DEFAULT '0.0.1',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PageId)
);


insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/a');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/b');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/c');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/g');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/asdasd');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/asd');
insert into SITES_WEB_PAGE(PageId,requestedPath) values(SITES_WEB_PAGE_PageId.nextval,'/a_1');

SELECT * FROM SITES_WEB_PAGE;

COMMIT;