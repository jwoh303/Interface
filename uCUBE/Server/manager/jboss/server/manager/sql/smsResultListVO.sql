SELECT APPLICATION_SHORT_NAME, 			-- 서비스 이름 
  SERVICE_INST_ID,              		-- 링크 이름
  RECEIVER_NM,                 			-- SMS 수신자
  BL_STATUS,                    		-- 성공여부
  MESSAGE_CONT,                 		-- 전송메세지
  TO_CHAR(CREATION_TIMESTAMP, 'yyyy/mm/dd hh24:mi:ss')       		        -- 전송시간
FROM TB_S60_SMLS010
WHERE EAI_SEND_DATE = REPLACE(? , '-', '')	-- 전송일자
  AND SERVICE_INST_ID LIKE CONCAT(? , '%')  -- 링크 이름
  AND RECEIVER_NM LIKE ?					-- SMS 수신자