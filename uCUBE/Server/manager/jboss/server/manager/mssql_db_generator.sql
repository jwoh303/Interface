/*
5월-20-2010 03:48:47 오후
 에 Aqua Data Studio 8.0.15에 의해 생성된 스크립트데이터베이스: UCUBE_DEV
스키마: dbo
객체: RULE, TABLE, INDEX
*/
DROP TABLE "dbo"."TEST"
GO
DROP TABLE "dbo"."TB_S60_USER010"
GO
DROP TABLE "dbo"."TB_S60_UERR010"
GO
DROP TABLE "dbo"."TB_S60_SYST020"
GO
DROP TABLE "dbo"."TB_S60_SUMM010"
GO
DROP TABLE "dbo"."TB_S60_STAT020"
GO
DROP TABLE "dbo"."TB_S60_SMLS010"
GO
DROP TABLE "dbo"."TB_S60_SERV010"
GO
DROP TABLE "dbo"."TB_S60_QNAM010"
GO
DROP TABLE "dbo"."TB_S60_QMON010"
GO
DROP TABLE "dbo"."TB_S60_PROC010"
GO
DROP TABLE "dbo"."TB_S60_NOTI010"
GO
DROP TABLE "dbo"."TB_S60_JMSS020"
GO
DROP TABLE "dbo"."TB_S60_IFTM020"
GO
DROP TABLE "dbo"."TB_S60_IFTD020"
GO
DROP TABLE "dbo"."TB_S60_IFTC010"
GO
DROP TABLE "dbo"."TB_S60_IFMG020"
GO
DROP TABLE "dbo"."TB_S60_BZTP010"
GO
DROP TABLE "dbo"."EAI_USER_EVENTS"
GO
DROP TABLE "dbo"."EAI_SEND_DATA"
GO

CREATE TABLE "dbo"."EAI_SEND_DATA"  ( 
	"SEND_DATA_SEQ_ID"      	bigint identity(1,1) NOT NULL,
	"APPLICATION_SHORT_NAME"	varchar(50) NULL,
	"SERVICE_INST_ID"       	varchar(255) NULL,
	"EAI_INTERFACE_ID"      	varchar(20) NULL,
	"TRANSACTION_CODE"      	varchar(8) NULL,
	"EAI_SYSTEM_ID"         	varchar(10) NULL,
	"EAI_SEND_TIMESTAMP"    	datetime NULL,
	"DOCUMENT_ID"           	varchar(255) NULL,
	"SEND_DATA"             	text NULL,
	"GENERATION_DATE"       	datetime NULL 
	)
GO
CREATE TABLE "dbo"."EAI_USER_EVENTS"  ( 
	"USER_EVENTS_SEQ_ID"   	bigint identity(1,1) NOT NULL,
	"EVENT_ID"             	int NULL,
	"EVENT_CATEGORY"       	varchar(4000) NULL,
	"GENERATION_DATE"      	datetime NULL,
	"EVENT_SOURCE"         	varchar(4000) NULL,
	"EVENT_SCOPE"          	varchar(4000) NULL,
	"EVENT_MODULE"         	varchar(4000) NULL,
	"DESCRIPTION"          	varchar(4000) NULL,
	"EVENT_STATUS"         	varchar(4000) NULL,
	"EXPIRY_TIME"          	datetime NULL,
	"SERVICE_GUID"         	varchar(4000) NULL,
	"TEXT_DATA"            	varchar(4000) NULL,
	"EAI_INTERFACE_ID"     	varchar(20) NULL,
	"TRANSACTION_CODE"     	varchar(8) NULL,
	"LOCAL_HOST_NAME"      	varchar(100) NULL,
	"DATA_LOGGER_STATUS"   	varchar(11) NULL,
	"EAI_SEND_TIMESTAMP"   	datetime NULL,
	"EAI_RECEIVE_TIMESTAMP"	datetime NULL,
	"UAP_PROCESS_TIME"     	numeric(8,3) NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_BZTP010"  ( 
	"EAI_BUSINESS_TYPE_CODE"	varchar(1) NOT NULL,
	"EAI_BUSINESS_TYPE_NAME"	varchar(100) NULL,
	"CREATION_TIMESTAMP"    	datetime NULL,
	"LAST_UPDATE_TIMESTAMP" 	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_IFMG020"  ( 
	"SEQ_ID"               	bigint identity(1,1) NOT NULL,
	"INTERFACE_SECTION"    	varchar(50) NOT NULL,
	"EAI_INTERFACE_ID"     	varchar(50) NOT NULL,
	"SEND_EAI_SYSTEM_ID"   	varchar(50) NOT NULL,
	"SEND_IP_ADDRESS"      	varchar(50) NOT NULL,
	"SEND_SERVICE_SECTION" 	varchar(50) NOT NULL,
	"SEND_PROCESS_CHAIN"   	varchar(50) NOT NULL,
	"SEND_PROCESS"         	varchar(50) NOT NULL,
	"SEND_AREA"            	varchar(50) NOT NULL,
	"SEND_DATA_TYPE"       	varchar(50) NOT NULL,
	"RECV_EAI_SYSTEM_ID"   	varchar(50) NOT NULL,
	"RECV_IP_ADDRESS"      	varchar(50) NOT NULL,
	"RECV_SERVICE_SECTION" 	varchar(50) NOT NULL,
	"RECV_PROCESS_CHAIN"   	varchar(50) NOT NULL,
	"RECV_PROCESS"         	varchar(50) NOT NULL,
	"RECV_AREA"            	varchar(50) NOT NULL,
	"RECV_DATA_TYPE"       	varchar(50) NOT NULL,
	"MULTI_RECV_COUNT"     	varchar(1) NOT NULL,
	"SYNCH_COMM_YN"        	varchar(1) NOT NULL,
	"BUFFERING_YN"         	varchar(1) NOT NULL,
	"POCESS_SEQUENCE_YN"   	varchar(1) NOT NULL,
	"IFD_SEQUENCE"         	varchar(1) NOT NULL,
	"SEND_APP_NAME"        	varchar(50) NULL,
	"SEND_LINK_NAME"       	varchar(50) NULL,
	"SEND_APP_TYPE"        	varchar(50) NULL,
	"RECV_APP_NAME"        	varchar(50) NULL,
	"RECV_LINK_NAME"       	varchar(50) NULL,
	"RECV_APP_TYPE"        	varchar(50) NULL,
	"CONNECTION_SERVER"    	varchar(50) NULL,
	"CONNECTION_SERVER1"   	varchar(50) NULL,
	"QUEUE_NAME"           	varchar(50) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_IFTC010"  ( 
	"TRANSACTION_ID"       	bigint identity(1,1) NOT NULL,
	"TRANSACTION_CODE"     	varchar(8) NOT NULL,
	"TRANSACTION_NAME"     	varchar(100) NOT NULL,
	"DATA_COUNT"           	int NULL DEFAULT ((0)),
	"MESSAGE_MAX_LEN"      	int NULL DEFAULT ((0)),
	"SEND_RECORD_COUNT"    	int NULL DEFAULT ((1)),
	"DATA_QUANTITY"        	int NULL DEFAULT ((0)),
	"RECOVER_TIME"         	int NULL,
	"TROUBLE_EFFECT_TYPE"  	varchar(2) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_IFTD020"  ( 
	"SEQ_ID"                  	bigint identity(1,1) NOT NULL,
	"INTERFACE_SECTION"       	varchar(50) NULL,
	"ERROR_INFO"              	varchar(50) NULL,
	"RECORD_INFO"             	varchar(50) NULL,
	"NO"                      	int NULL,
	"BSC_SECTION_YN"          	varchar(1) NULL,
	"EDC_INFO"                	varchar(50) NULL,
	"EAI_SECTION"             	varchar(50) NULL,
	"EAI_INTERFACE_ID"        	varchar(50) NULL,
	"FORMAT_NAME"             	varchar(50) NULL,
	"FORMAT_NAME_KOR"         	varchar(2000) NULL,
	"TC_NAME"                 	varchar(50) NULL,
	"TC_NAME_KOR"             	varchar(2000) NULL,
	"TC_DESCRIPTION"          	varchar(2000) NULL,
	"INTERFACE_ERROR_CHECK_YN"	varchar(1) NULL,
	"SEND_SERVICE_SECTION"    	varchar(50) NULL,
	"SEND_PROCESS_CHAIN"      	varchar(50) NULL,
	"SEND_PROCESS"            	varchar(50) NULL,
	"SEND_AREA"               	varchar(50) NULL,
	"RECV_SERVICE_SECTION"    	varchar(50) NULL,
	"RECV_PROCESS_CHAIN"      	varchar(50) NULL,
	"RECV_PROCESS"            	varchar(50) NULL,
	"RECV_AREA"               	varchar(50) NULL,
	"MULTI_RECV_COUNT"        	varchar(1) NULL,
	"SEND_SERVER_NAME"        	varchar(50) NULL,
	"SEND_HOST_NAME"          	varchar(50) NULL,
	"SEND_EAI_SYSTEM_ID"      	varchar(50) NULL,
	"SEND_IP_ADDRESS"         	varchar(50) NULL,
	"SEND_APP_LANGUAGE"       	varchar(50) NULL,
	"SEND_APP_NAME"           	varchar(50) NULL,
	"SEND_DATA_TYPE"          	varchar(50) NULL,
	"SEND_FILE_PATH"          	varchar(50) NULL,
	"SEND_DB_TYPE"            	varchar(50) NULL,
	"SEND_CODE_TYPE"          	varchar(50) NULL,
	"RECV_SERVER_NAME"        	varchar(50) NULL,
	"RECV_HOST_NAME"          	varchar(50) NULL,
	"RECV_EAI_SYSTEM_ID"      	varchar(50) NULL,
	"RECV_IP_ADDRESS"         	varchar(50) NULL,
	"RECV_APP_LANGUAGE"       	varchar(50) NULL,
	"RECV_APP_NAME"           	varchar(50) NULL,
	"RECV_DATA_TYPE"          	varchar(50) NULL,
	"RECV_FILE_PATH"          	varchar(50) NULL,
	"RECV_DB_TYPE"            	varchar(50) NULL,
	"RECV_CODE_TYPE"          	varchar(50) NULL,
	"CODE_CONVER_YN"          	varchar(1) NULL,
	"KOR_EXIST_YN"            	varchar(1) NULL,
	"MAX_COUNT"               	int NULL,
	"RECORD_LENGTH"           	int NULL,
	"RECORD_COUNT"            	int NULL,
	"MAX_SIZE"                	int NULL,
	"RECOVERY_ALLOW_TIME"     	int NULL,
	"BACKUP_PROCESS"          	varchar(50) NULL,
	"PROBLEM_IMPACT"          	varchar(50) NULL,
	"SYNCH_COMM_YN"           	varchar(1) NULL,
	"BUFFERING_YN"            	varchar(1) NULL,
	"POCESS_SEQUENCE_YN"      	varchar(1) NULL,
	"SEND_TEAM_NAME"          	varchar(50) NULL,
	"SEND_PERSON_NAME"        	varchar(50) NULL,
	"SEND_PERSON_CONTACT"     	varchar(50) NULL,
	"RECV_TEAM_NAME"          	varchar(50) NULL,
	"RECV_PERSON_NAME"        	varchar(50) NULL,
	"RECV_PERSON_CONTACT"     	varchar(50) NULL,
	"WORKER_TEAM_NAME"        	varchar(50) NULL,
	"WORKER_NAME"             	varchar(50) NULL,
	"WORKER_CONTACT"          	varchar(50) NULL,
	"WORKER_CONFIRM_YN"       	varchar(1) NULL,
	"EAI_PERSON_NAME"         	varchar(50) NULL,
	"EAI_PERSON_CONTACT"      	varchar(50) NULL,
	"TEST_PLAN_DATE"          	datetime NULL,
	"OPERATE_DATE"            	datetime NULL,
	"DATA_MAP_YN"             	varchar(1) NULL,
	"REMARK"                  	varchar(50) NULL,
	"ORDERS_TC_YN"            	varchar(1) NULL,
	"TOPIC_NAME"              	varchar(50) NULL,
	"OPERATE_YN"              	varchar(1) NULL,
	"QUEUE_NAME"              	varchar(50) NULL,
	"CONNECTION_SERVER"       	varchar(50) NULL,
	"CONNECTION_SERVER1"      	varchar(50) NULL,
	"IFD_SEQUENCE"            	varchar(1) NULL,
	"CREATION_TIMESTAMP"      	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"   	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_IFTM020"  ( 
	"SEQ_ID"                  	bigint identity(1,1) NOT NULL,
	"INTERFACE_SECTION"       	varchar(50) NULL,
	"ERROR_INFO"              	varchar(50) NULL,
	"RECORD_INFO"             	varchar(50) NULL,
	"NO"                      	int NULL,
	"BSC_SECTION_YN"          	varchar(1) NULL,
	"EDC_INFO"                	varchar(50) NULL,
	"EAI_SECTION"             	varchar(50) NULL,
	"EAI_INTERFACE_ID"        	varchar(50) NULL,
	"FORMAT_NAME"             	varchar(50) NULL,
	"FORMAT_NAME_KOR"         	varchar(2000) NULL,
	"TC_NAME"                 	varchar(50) NULL,
	"TC_NAME_KOR"             	varchar(2000) NULL,
	"TC_DESCRIPTION"          	varchar(2000) NULL,
	"INTERFACE_ERROR_CHECK_YN"	varchar(1) NULL,
	"SEND_SERVICE_SECTION"    	varchar(50) NULL,
	"SEND_PROCESS_CHAIN"      	varchar(50) NULL,
	"SEND_PROCESS"            	varchar(50) NULL,
	"SEND_AREA"               	varchar(50) NULL,
	"RECV_SERVICE_SECTION"    	varchar(50) NULL,
	"RECV_PROCESS_CHAIN"      	varchar(50) NULL,
	"RECV_PROCESS"            	varchar(50) NULL,
	"RECV_AREA"               	varchar(50) NULL,
	"MULTI_RECV_COUNT"        	varchar(1) NULL,
	"SEND_SERVER_NAME"        	varchar(50) NULL,
	"SEND_HOST_NAME"          	varchar(50) NULL,
	"SEND_EAI_SYSTEM_ID"      	varchar(50) NULL,
	"SEND_IP_ADDRESS"         	varchar(50) NULL,
	"SEND_APP_LANGUAGE"       	varchar(50) NULL,
	"SEND_APP_NAME"           	varchar(50) NULL,
	"SEND_DATA_TYPE"          	varchar(50) NULL,
	"SEND_FILE_PATH"          	varchar(50) NULL,
	"SEND_DB_TYPE"            	varchar(50) NULL,
	"SEND_CODE_TYPE"          	varchar(50) NULL,
	"RECV_SERVER_NAME"        	varchar(50) NULL,
	"RECV_HOST_NAME"          	varchar(50) NULL,
	"RECV_EAI_SYSTEM_ID"      	varchar(50) NULL,
	"RECV_IP_ADDRESS"         	varchar(50) NULL,
	"RECV_APP_LANGUAGE"       	varchar(50) NULL,
	"RECV_APP_NAME"           	varchar(50) NULL,
	"RECV_DATA_TYPE"          	varchar(50) NULL,
	"RECV_FILE_PATH"          	varchar(50) NULL,
	"RECV_DB_TYPE"            	varchar(50) NULL,
	"RECV_CODE_TYPE"          	varchar(50) NULL,
	"CODE_CONVER_YN"          	varchar(1) NULL,
	"KOR_EXIST_YN"            	varchar(1) NULL,
	"MAX_COUNT"               	int NULL,
	"RECORD_LENGTH"           	int NULL,
	"RECORD_COUNT"            	int NULL,
	"MAX_SIZE"                	int NULL,
	"RECOVERY_ALLOW_TIME"     	int NULL,
	"BACKUP_PROCESS"          	varchar(50) NULL,
	"PROBLEM_IMPACT"          	varchar(50) NULL,
	"SYNCH_COMM_YN"           	varchar(1) NULL,
	"BUFFERING_YN"            	varchar(1) NULL,
	"POCESS_SEQUENCE_YN"      	varchar(1) NULL,
	"SEND_TEAM_NAME"          	varchar(50) NULL,
	"SEND_PERSON_NAME"        	varchar(50) NULL,
	"SEND_PERSON_CONTACT"     	varchar(50) NULL,
	"RECV_TEAM_NAME"          	varchar(50) NULL,
	"RECV_PERSON_NAME"        	varchar(50) NULL,
	"RECV_PERSON_CONTACT"     	varchar(50) NULL,
	"WORKER_TEAM_NAME"        	varchar(50) NULL,
	"WORKER_NAME"             	varchar(50) NULL,
	"WORKER_CONTACT"          	varchar(50) NULL,
	"WORKER_CONFIRM_YN"       	varchar(1) NULL,
	"EAI_PERSON_NAME"         	varchar(50) NULL,
	"EAI_PERSON_CONTACT"      	varchar(50) NULL,
	"TEST_PLAN_DATE"          	datetime NULL,
	"OPERATE_DATE"            	datetime NULL,
	"DATA_MAP_YN"             	varchar(1) NULL,
	"REMARK"                  	varchar(50) NULL,
	"ORDERS_TC_YN"            	varchar(1) NULL,
	"TOPIC_NAME"              	varchar(50) NULL,
	"OPERATE_YN"              	varchar(1) NULL,
	"QUEUE_NAME"              	varchar(50) NULL,
	"CONNECTION_SERVER"       	varchar(50) NULL,
	"CONNECTION_SERVER1"      	varchar(50) NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_JMSS020"  ( 
	"CONNECTION_SERVER"       	varchar(50) NOT NULL,
	"JMSPROVIDER_URL"         	varchar(50) NULL,
	"INITIAL_CONTEXT_FACTORY" 	varchar(50) NULL,
	"QUEUE_CONNECTION_FACTORY"	varchar(50) NULL,
	"TOPIC_CONNECTION_FACTORY"	varchar(50) NULL,
	"SECURITY_PRINCIPAL"      	varchar(50) NULL,
	"SECURITY_CREDENTIALS"    	varchar(50) NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_NOTI010"  ( 
	"BBS_ID"               	bigint identity(1,1) NOT NULL,
	"NOTICE_DATE_FROM"     	datetime NULL,
	"NOTICE_DATE_TO"       	datetime NULL,
	"USE_TP"               	varchar(1) NULL,
	"EAI_INTERFACE_ID"     	varchar(12) NULL,
	"TRANSACTION_CODE"     	varchar(8) NULL,
	"MESSAGE_CONT"         	varchar(2000) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_PROC010"  ( 
	"PROCESS_CHAIN_CODE"   	varchar(6) NOT NULL,
	"PROCESS_CHAIN_NAME"   	varchar(100) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_QMON010"  ( 
	"LOCAL_QUEUE_NAME"  	varchar(100) NOT NULL,
	"GENERATION_DATE"   	datetime NOT NULL,
	"DATA_COUNT"        	int NULL DEFAULT ((0)),
	"DATA_END_TIMESTAMP"	datetime NULL,
	"CREATED_OBJECT_ID" 	varchar(22) NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_QNAM010"  ( 
	"LOCAL_QUEUE_NAME"     	varchar(100) NOT NULL,
	"QUEUE_DESCRIPTION"    	varchar(100) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_SERV010"  ( 
	"APPLICATION_SHORT_NAME"	varchar(50) NOT NULL,
	"SERVICE_INST_ID"       	varchar(255) NOT NULL,
	"SERVICE_GUID"          	varchar(4000) NULL,
	"RECEIVER_NM"           	varchar(50) NULL,
	"EAI_SERVICE_SEQ_NO"    	int NULL DEFAULT ((1)),
	"CREATION_TIMESTAMP"    	datetime NULL,
	"LAST_UPDATE_TIMESTAMP" 	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_SMLS010"  ( 
	"SMS_SEQ_ID"            	bigint identity(1,1) NOT NULL,
	"EAI_SEND_DATE"         	varchar(8) NOT NULL,
	"EAI_SYSTEM_ID"         	varchar(10) NULL,
	"APPLICATION_SHORT_NAME"	varchar(50) NULL,
	"SERVICE_INST_ID"       	varchar(255) NULL,
	"RECEIVER_NM"           	varchar(50) NULL,
	"RECEIVER_CP_NUM"       	varchar(80) NULL,
	"BL_STATUS"             	varchar(15) NULL,
	"MESSAGE_CONT"          	varchar(2000) NULL,
	"CREATION_TIMESTAMP"    	datetime NULL,
	"LAST_UPDATE_TIMESTAMP" 	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_STAT020"  ( 
	"STATUS_SEQ_ID"         bigint identity(1,1) NOT NULL,
	"EAI_SYSTEM_ID"        	varchar(10) NULL,
	"SERVICE_NAME"         	varchar(50) NULL,
	"SERVICE_LINK_NAME"    	varchar(255) NULL,
	"BL_STATUS"            	varchar(15) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL,
	"IP_NUMBERS"           	varchar(255) NULL,
	"PORT_NUMBERS"         	varchar(255) NULL,
	"ERROR_RETURN_VALUE"   	varchar(255) NULL,
	"LOCAL_QUEUE_YN"       	varchar(255) NULL,
	"LOCAL_QUEUE_COUNT"    	varchar(255) NULL,
	"EVENT_MODULE"         	varchar(255) NULL,
	"EVENT_STATUS"         	varchar(255) NULL,
	"DESCRIPTION"          	varchar(255) NULL,
	"DATA_ACCRUAL_TIME"    	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_SUMM010"  ( 
	"EAI_INTERFACE_ID"      	varchar(20) NOT NULL,
	"TRANSACTION_CODE"      	varchar(8) NOT NULL,
	"SEND_RECEIVE_CODE"     	varchar(1) NOT NULL,
	"EAI_SYSTEM_ID"         	varchar(10) NOT NULL,
	"EAI_SEND_DATE"         	varchar(8) NOT NULL,
	"PROCESS_CHAIN_CODE"    	varchar(6) NOT NULL,
	"APPLICATION_SHORT_NAME"	varchar(50) NULL,
	"SERVICE_INST_ID"       	varchar(255) NULL,
	"MULTI_RECEIVE_COUNT"   	int NULL DEFAULT ((1)),
	"TIME_COUNT0"           	int NULL DEFAULT ((0)),
	"TIME_COUNT1"           	int NULL DEFAULT ((0)),
	"TIME_COUNT2"           	int NULL DEFAULT ((0)),
	"TIME_COUNT3"           	int NULL DEFAULT ((0)),
	"TIME_COUNT4"           	int NULL DEFAULT ((0)),
	"TIME_COUNT5"           	int NULL DEFAULT ((0)),
	"TIME_COUNT6"           	int NULL DEFAULT ((0)),
	"TIME_COUNT7"           	int NULL DEFAULT ((0)),
	"TIME_COUNT8"           	int NULL DEFAULT ((0)),
	"TIME_COUNT9"           	int NULL DEFAULT ((0)),
	"TIME_COUNT10"          	int NULL DEFAULT ((0)),
	"TIME_COUNT11"          	int NULL DEFAULT ((0)),
	"TIME_COUNT12"          	int NULL DEFAULT ((0)),
	"TIME_COUNT13"          	int NULL DEFAULT ((0)),
	"TIME_COUNT14"          	int NULL DEFAULT ((0)),
	"TIME_COUNT15"          	int NULL DEFAULT ((0)),
	"TIME_COUNT16"          	int NULL DEFAULT ((0)),
	"TIME_COUNT17"          	int NULL DEFAULT ((0)),
	"TIME_COUNT18"          	int NULL DEFAULT ((0)),
	"TIME_COUNT19"          	int NULL DEFAULT ((0)),
	"TIME_COUNT20"          	int NULL DEFAULT ((0)),
	"TIME_COUNT21"          	int NULL DEFAULT ((0)),
	"TIME_COUNT22"          	int NULL DEFAULT ((0)),
	"TIME_COUNT23"          	int NULL DEFAULT ((0)),
	"DATA_COUNT"            	int NULL DEFAULT ((0)),
	"UAP_PROCESS_TIME"      	numeric(6,3) NULL,
	"CREATION_TIMESTAMP"    	datetime NULL,
	"LAST_UPDATE_TIMESTAMP" 	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_SYST020"  ( 
	"SYSTEM_SEQ_ID"          	bigint identity(1,1) NOT NULL,
	"SYSTEM_SECTION"         	varchar(100) NULL,
	"SYSTEM_PROCESS"         	varchar(100) NULL,
	"HOST_NAME"              	varchar(100) NULL,
	"EAI_SYSTEM_ID"          	varchar(100) NOT NULL,
	"EAI_IP_NUMBERS"         	varchar(100) NULL,
	"REAL_IP_NUMBERS"        	varchar(100) NULL,
	"VIRTUAL_IP_NUMBERS"     	varchar(100) NULL,
	"LOCAL_QUEUE_YN"         	varchar(100) NULL,
	"LOCAL_QUEUE_SIZE"       	varchar(100) NULL,
	"WORKS_CODE"             	varchar(100) NULL,
	"OPERATE_YN"             	varchar(100) NULL,
	"OS_VERSION"             	varchar(100) NULL,
	"OS_TYPE"                	varchar(100) NULL,
	"EAI_SOLUTION"           	varchar(100) NULL,
	"ONLINE_BACKUP_TYPE"     	varchar(100) NULL,
	"SYSTEM_OPERATION_DATE"  	varchar(100) NULL,
	"SYSTEM_OPERATION_NUMBER"	varchar(100) NULL,
	"TOOL_VERSION"           	varchar(100) NULL,
	"CRTL_VERSION"           	varchar(100) NULL,
	"ADAPTER_VERSION"        	varchar(100) NULL,
	"SECURITY_YN"            	varchar(100) NULL,
	"LICENSE_YN"             	varchar(100) NULL,
	"USER_EMP_NAME"          	varchar(100) NULL,
	"USER_EMP_PHONE"         	varchar(100) NULL,
	"REMARKS"                	varchar(1000) NULL,
	"EAI_HOME_PATH"          	varchar(100) NULL,
	"CONFIG_FILE_PATH"       	varchar(100) NULL,
	"IFD_FILE_PATH"          	varchar(100) NULL,
	"EAI_USER_NAME01"        	varchar(100) NULL,
	"EAI_USER_NAME02"        	varchar(100) NULL,
	"SYSTEM_SECTION_CODE"    	varchar(100) NULL,
	"SYSTEM_GROUP"           	varchar(100) NULL,
	"SYSTEM_AREA"            	varchar(100) NULL,
	"RECONNECT_INTERVAL"     	int NULL,
	"ENCODING_VALUE"         	varchar(100) NULL,
	"ENABLE_LIVECHECK_YN"    	varchar(1) NULL,
	"ENABLE_MONITOR_YN"      	varchar(1) NULL,
	"BACK_GROUND_CONN_YN"    	varchar(1) NULL,
	"CREATION_TIMESTAMP"     	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"  	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TB_S60_UERR010"  ( 
	"LOCAL_QUEUE_NAME"     	varchar(100) NOT NULL,
	"TRANSACTION_CODE"     	varchar(8) NOT NULL,
	"EAI_SEND_TIMESTAMP"   	datetime NOT NULL,
	"EAI_RECEIVE_TIMESTAMP"	datetime NULL,
	"EAI_SYSTEM_ID"        	varchar(10) NULL,
	"EAI_INTERFACE_ID"     	varchar(12) NULL,
	"ERROR_RETURN_VALUE"   	varchar(10) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL,
	"TEXT_DATA"            	varchar(255) NULL,
	"DESCRIPTION"          	varchar(255) NULL 
	"CREATED_OBJECT_ID"     varchar(100) NULL
	)
GO
CREATE TABLE "dbo"."TB_S60_USER010"  ( 
	"USER_EMP_NO"          	varchar(20) NOT NULL,
	"EAI_USER_PASSWORD"    	varchar(8) NULL,
	"LAST_NAME"            	varchar(40) NULL,
	"SYS_USER_TP"          	varchar(1) NULL,
	"TEAM_NM"              	varchar(50) NULL,
	"OFFICE_NUMBER"        	varchar(30) NULL,
	"HAND_PHONE"           	varchar(60) NULL,
	"EMAIL_ADDRESS"        	varchar(50) NULL,
	"SMS_RCV_FLAG"         	varchar(1) NULL,
	"CREATION_TIMESTAMP"   	datetime NULL,
	"LAST_UPDATE_TIMESTAMP"	datetime NULL 
	)
GO
CREATE TABLE "dbo"."TEST"  ( 
	"column1"	varchar(50) NULL,
	"column2"	varchar(50) NULL 
	)
GO

-- default value insert
INSERT INTO TB_S60_SYST020 (HOST_NAME,EAI_SYSTEM_ID,EAI_IP_NUMBERS,REAL_IP_NUMBERS) values ('TEST','TEST','127.0.0.1','127.0.0.1');
GO

INSERT INTO TB_S60_PROC010 ("PROCESS_CHAIN_CODE", "PROCESS_CHAIN_NAME", "CREATION_TIMESTAMP", "LAST_UPDATE_TIMESTAMP") VALUES ('M90', '제어계측', convert(char,'', 121), convert(char,'', 121)) ;
GO

INSERT INTO TB_S60_USER010    (USER_EMP_NO,EAI_USER_PASSWORD,LAST_NAME,SYS_USER_TP)  VALUES    ('admin','passwd','admin','1') ;
GO
--- USER FUNCTION 정의

-- 1) subsrtb , byte 단위로 Substring 
create function UCUBE_SUBSTRINGB(@str varchar(4000),@start int,@len int)
  returns varchar(4000)
  as
  begin
  declare @i int,@j int
   set @i=0
   set @j=datalength(substring(@str,@start,@len))
   if(@j<=@len)
     set @i=@len
   else
     begin
     set @i=@len
     while(@i>0)
       begin
        set @i=@i-1
         if(datalength(substring(@str,@start,@i))<=@len)
        break
     end
   end
 return(substring(@str,@start,@i))
 end

GO
 --2) LPAD() 정의
 CREATE FUNCTION UCUBE_LPAD(@I_STR  VARCHAR(4000), @I_STR_LEN INT, @I_FILL_STR VARCHAR)
 RETURNS VARCHAR(4000)
 AS
 BEGIN
     DECLARE @R_STR VARCHAR(200),
             @T_DIFF_LEN INT,
             @T_STR_LEN INT,
             @O_STR_LEN INT,
             @POS INT

    SET @O_STR_LEN = LEN(@I_STR)
    SET @T_STR_LEN = 0
    SET @POS = 1

    WHILE @O_STR_LEN >= @POS
    BEGIN
        IF LEN(UNICODE(SUBSTRING(@I_STR,@POS,@POS+1))) > 3
        BEGIN
            SET @T_STR_LEN = @T_STR_LEN + 2
        END
        ELSE
        BEGIN
            SET @T_STR_LEN = @T_STR_LEN + 1        
        END
        SET @POS = @POS+1    
    END

 SET @T_DIFF_LEN = @I_STR_LEN -  @T_STR_LEN

 IF @T_DIFF_LEN >= 0  
  SET @R_STR = REPLICATE(@I_FILL_STR, @T_DIFF_LEN) + @I_STR
 ELSE 
  SET @R_STR = @I_STR
     RETURN substring(@R_STR,1,@I_STR_LEN )
END 

GO
-- 3) RPAD()정의
 CREATE FUNCTION UCUBE_RPAD(@I_STR  VARCHAR(4000), @I_STR_LEN INT, @I_FILL_STR VARCHAR)
 RETURNS VARCHAR(4000)
 AS
 BEGIN
     DECLARE @R_STR VARCHAR(200),
             @T_DIFF_LEN INT,
             @T_STR_LEN INT,
             @O_STR_LEN INT,
             @POS INT

    SET @O_STR_LEN = LEN(@I_STR)
    SET @T_STR_LEN = 0
    SET @POS = 1

    WHILE @O_STR_LEN >= @POS
    BEGIN
        IF LEN(UNICODE(SUBSTRING(@I_STR,@POS,@POS+1))) > 3
        BEGIN
            SET @T_STR_LEN = @T_STR_LEN + 2
        END
        ELSE
        BEGIN
            SET @T_STR_LEN = @T_STR_LEN + 1        
        END
        SET @POS = @POS+1    
    END

 SET @T_DIFF_LEN = @I_STR_LEN -  @T_STR_LEN

 IF @T_DIFF_LEN >= 0  
  SET @R_STR = @I_STR + REPLICATE(@I_FILL_STR, @T_DIFF_LEN)  
 ELSE 
  SET @R_STR = @I_STR
     RETURN substring(@R_STR,1,@I_STR_LEN )

END 

GO

--4) UCUBE_DECODE_INT
create function  UCUBE_DECODE_INT(@str varchar(2000), @tmp varchar(2000) ,@val1 int, @val2 int)
returns int
  as 
   begin
    return (case @str  when @tmp  then @val1 else @val2 end )
end
GO