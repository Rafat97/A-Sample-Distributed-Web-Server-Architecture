
CREATE OR REPLACE FUNCTION isIpValid(ipAddress in VARCHAR2)
RETURN number
IS

flag number := 0;

BEGIN
    -- SELECT
    -- decode(regexp_instr('10.0.0.0',
    -- '^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$'), 
    -- 1, 
    -- 'Valid', 
    -- 'NOT-Valid') "IS_VALID"
    -- FROM DUAL;

	SELECT
    regexp_instr(ipAddress,
        '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') "IS_VALID_IP" into flag
    FROM DUAL;
	return flag;
END isIpValid;
/

CREATE OR REPLACE FUNCTION isWebAddressValid(webAddress in VARCHAR2)
RETURN number
IS
flag number := 0;
BEGIN
	SELECT
        regexp_instr(webAddress,
        '^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$') "IS_VALID_WEB_ADDRESS" into flag
    FROM DUAL;
	return flag;
END isWebAddressValid;
/


CREATE OR REPLACE FUNCTION checkStatus(sitelink in VARCHAR2)
RETURN number
IS
flag number := 1;
BEGIN
	execute immediate 'select * from dual@' || sitelink;
	return flag;
EXCEPTION
    WHEN OTHERS THEN
        flag:=0;
        return 0;
END checkStatus;
/
