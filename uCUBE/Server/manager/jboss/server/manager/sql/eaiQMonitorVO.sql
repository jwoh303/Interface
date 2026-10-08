SELECT /*+ S603 UI  MES 수신 Queue 모니터 EaiMonitorVO 황용길 */
  QMON.serverName serverName ,
  QNAM.local_queue_name qname ,
  QNAM.queue_description qdesc ,
  QMON.dcnt dcnt ,
  TO_CHAR(QMON.gdate, 'mm-dd hh24:mi') gdate ,
  ddate ,
  UERR.sysid sysid ,
  UERR.ifid ifid ,
  UERR.tcode tcode ,
  UERR.ecode ecode ,
  TO_CHAR(UERR.stime, 'yyyy-mm-dd hh24:mi:ss.ff') stime ,
  TO_CHAR(UERR.rtime, 'yyyy-mm-dd hh24:mi:ss.ff') rtime ,
  (
    SELECT HOST_NAME
    FROM TB_S60_SYST020
    WHERE EAI_SYSTEM_ID = UERR.sysid) sname ,
  (
    SELECT TRANSACTION_NAME
    FROM TB_S60_IFTC010
    WHERE TRANSACTION_CODE = UERR.tcode) tname
FROM TB_S60_QNAM010 QNAM ,
  (
    SELECT TQmon.CREATED_OBJECT_ID serverName ,
      TQmon.LOCAL_QUEUE_NAME qname ,
      TQmon.DATA_COUNT dcnt ,
      TQmon.GENERATION_DATE gdate ,
      trunc((sysdate-to_date(to_char(TQmon.DATA_END_TIMESTAMP, 'Rrrr-mm-dd Hh24:Mi:Ss'), 'Rrrr-mm-dd Hh24:Mi:Ss'))*24*60) ddate
    FROM TB_S60_QMON010 TQmon,
    (
        SELECT LOCAL_QUEUE_NAME ,
          MAX(GENERATION_DATE) gdate
        FROM TB_S60_QMON010
        WHERE GENERATION_DATE >= ( SYSDATE - 30/(24*60) )
        GROUP BY LOCAL_QUEUE_NAME ) Qlist
    WHERE TQmon.GENERATION_DATE = Qlist.gdate
      AND TQmon.LOCAL_QUEUE_NAME = Qlist.LOCAL_QUEUE_NAME) QMON  ,
  (
    SELECT LOCAL_QUEUE_NAME qname ,
      TRANSACTION_CODE tcode ,
      EAI_SEND_TIMESTAMP stime ,
      EAI_RECEIVE_TIMESTAMP rtime ,
      EAI_SYSTEM_ID sysid ,
      EAI_INTERFACE_ID ifid ,
      ERROR_RETURN_VALUE ecode
    FROM TB_S60_UERR010 Tuerr ,
      (
        SELECT LOCAL_QUEUE_NAME queue ,
          MAX(EAI_RECEIVE_TIMESTAMP) rtime
        FROM TB_S60_UERR010
        WHERE EAI_RECEIVE_TIMESTAMP >= ( SYSDATE - 2/(24*60) )
        GROUP BY LOCAL_QUEUE_NAME ) Muerr
    WHERE Tuerr.LOCAL_QUEUE_NAME = Muerr.queue
      AND Tuerr.EAI_RECEIVE_TIMESTAMP = Muerr.rtime ) UERR
WHERE QNAM.local_queue_name = QMON.qname
  AND QNAM.local_queue_name = UERR.qname(+)
  AND QNAM.local_queue_name LIKE CONCAT(? , '%')
  AND QMON.dcnt > TO_NUMBER(?) -1
  AND (QMON.serverName like CONCAT(? , '%') OR QMON.serverName is NULL)
  AND ddate >= TO_NUMBER(?)
ORDER BY ddate desc , gdate , qname
