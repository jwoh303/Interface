SELECT APPLICATION_SHORT_NAME , -- JMS Server Name
  SERVICE_INST_ID ,             -- Link Name (Queue Name)
  SERVICE_GUID ,                -- System Name
  RECEIVER_NM ,                 -- SMS 수신 User
  NVL(CREATED_OBJECT_TYPE,'N'),          -- SMS 수신여부
  LAST_UPDATED_OBJECT_ID,		-- 최종 수정자 
  TO_CHAR(LAST_UPDATE_TIMESTAMP, 'yyyy/mm/dd hh24:mi:ss') 			-- 최종 수정날짜  				
FROM TB_S60_SERV010
WHERE APPLICATION_SHORT_NAME LIKE CONCAT(?, '%')
AND SERVICE_INST_ID LIKE CONCAT(?, '%')
AND RECEIVER_NM LIKE ?
AND NVL(CREATED_OBJECT_TYPE,'N') LIKE ?
    