package com.koreab2b.mro.util;

import java.util.Map;


public class MailSmsUtil {
	 
	/**
	 * SMS 전송
	 * @param pMap
	 * 
	 * desc ARREO_SMS 참조
	 */
	public static int smsSend(Map<String, String> pMap ){		
		
	 
		
		pMap.put("CMP_MSG_ID", CommonUtil.onvl(pMap.get("CMP_MSG_ID") ,"") );
		pMap.put("CMP_USR_ID", CommonUtil.onvl(pMap.get("CMP_USR_ID") ,"") );
		pMap.put("ODR_FG", CommonUtil.onvl(pMap.get("ODR_FG") ,"") );
		pMap.put("SMS_GB", CommonUtil.onvl(pMap.get("SMS_GB") ,"") );
		pMap.put("USED_CD", CommonUtil.onvl(pMap.get("USED_CD") ,"") );
		pMap.put("MSG_GB", CommonUtil.onvl(pMap.get("MSG_GB") ,"") );
		pMap.put("WRT_DTTM", CommonUtil.onvl(pMap.get("WRT_DTTM") ,"") );
		pMap.put("SND_DTTM", CommonUtil.onvl(pMap.get("SND_DTTM") ,"") );
		pMap.put("SND_PHN_ID", CommonUtil.onvl(pMap.get("SND_PHN_ID") ,"") );
		pMap.put("RCV_PHN_ID", CommonUtil.onvl(pMap.get("RCV_PHN_ID") ,"") );
		pMap.put("CALLBACK", CommonUtil.onvl(pMap.get("CALLBACK") ,"") );
		pMap.put("SND_MSG", CommonUtil.onvl(pMap.get("SND_MSG") ,"") );
		pMap.put("CMP_SND_DTTM", CommonUtil.onvl(pMap.get("CMP_SND_DTTM") ,"") );
		pMap.put("CMP_RCV_DTTM", CommonUtil.onvl(pMap.get("CMP_RCV_DTTM") ,"") );
		pMap.put("REG_SND_DTTM", CommonUtil.onvl(pMap.get("REG_SND_DTTM") ,"") );
		pMap.put("REG_RCV_DTTM", CommonUtil.onvl(pMap.get("REG_RCV_DTTM") ,"") );
		pMap.put("EXPIRE_VAL", CommonUtil.onvl(pMap.get("EXPIRE_VAL") ,"") );
		pMap.put("SMS_ST", CommonUtil.onvl(pMap.get("SMS_ST") ,"") );
		pMap.put("RSLT_VAL", CommonUtil.onvl(pMap.get("RSLT_VAL") ,"") );
		pMap.put("RSRVD_ID", CommonUtil.onvl(pMap.get("RSRVD_ID") ,"") );
		pMap.put("RSRVD_WD", CommonUtil.onvl(pMap.get("RSRVD_WD") ,"") );
		pMap.put("RCV_MNO_CD", CommonUtil.onvl(pMap.get("RCV_MNO_CD") ,"") );
		pMap.put("SND_GB", CommonUtil.onvl(pMap.get("SND_GB") ,"") );
		pMap.put("SND_SKT_FG", CommonUtil.onvl(pMap.get("SND_SKT_FG") ,"") );
		pMap.put("SND_KTF_FG", CommonUtil.onvl(pMap.get("SND_KTF_FG") ,"") );
		pMap.put("SND_LGT_FG", CommonUtil.onvl(pMap.get("SND_LGT_FG") ,"") );
		pMap.put("MSG_ID", CommonUtil.onvl(pMap.get("MSG_ID") ,"") );
		pMap.put("NAT_CD", CommonUtil.onvl(pMap.get("NAT_CD") ,"") ); 
		
		int re = StaticContextAccessor.getBean(CommonCodeDao.class).insertSmsSend(pMap);	  
		return re;
		
	}
	
	
	
	
	/**
	 * MAIL 전송
	 * @param pMap
	 * 
	 * desc MAILSEND 참조
	 */
	public static int mailSend(Map<String, String> pMap ){		
		
	 
		
		pMap.put("MAILFORM_ID", CommonUtil.onvl(pMap.get("MAILFORM_ID") ,"") );
		pMap.put("SEND_COM_TYPE", CommonUtil.onvl(pMap.get("SEND_COM_TYPE") ,"") );
		pMap.put("RECV_COM_TYPE", CommonUtil.onvl(pMap.get("RECV_COM_TYPE") ,"") );
		pMap.put("SEND_COM_CODE", CommonUtil.onvl(pMap.get("SEND_COM_CODE") ,"") );
		pMap.put("SEND_USER_ID", CommonUtil.onvl(pMap.get("SEND_USER_ID") ,"") );
		pMap.put("KEY1", CommonUtil.onvl(pMap.get("KEY1") ,"") );
		pMap.put("KEY2", CommonUtil.onvl(pMap.get("KEY2") ,"") );
		pMap.put("KEY3", CommonUtil.onvl(pMap.get("KEY3") ,"") );
		pMap.put("KEY4", CommonUtil.onvl(pMap.get("KEY4") ,"") );
		pMap.put("KEY5", CommonUtil.onvl(pMap.get("KEY5") ,"") );
		pMap.put("KEY5SEQ", CommonUtil.onvl(pMap.get("KEY5SEQ") ,"N") ); // Y -> max+1 , N ->KEY5
		pMap.put("KEY6", CommonUtil.onvl(pMap.get("KEY6") ," ") );
		pMap.put("KEY7", CommonUtil.onvl(pMap.get("KEY7") ,"") );
		pMap.put("KEY8", CommonUtil.onvl(pMap.get("KEY8") ,"") );
		pMap.put("KEY9", CommonUtil.onvl(pMap.get("KEY9") ,"") );
		pMap.put("KEY10", CommonUtil.onvl(pMap.get("KEY10") ,"") );
		pMap.put("CRE_DATE", CommonUtil.onvl(pMap.get("CRE_DATE") ,"") );
		pMap.put("ERR_DATE", CommonUtil.onvl(pMap.get("ERR_DATE") ,"") );
	 
		
		int re = StaticContextAccessor.getBean(CommonCodeDao.class).insertMailSend(pMap);	  
		return re;
		
	}
	
	/**
	 * MAIL 전송(kep_mail)
	 * @param pMap
	 * 
	 * desc MAILSEND 참조
	 */
	public static int mailSendFromKepMail(Map<String, String> pMap ){		
		
		
		
		pMap.put("MAILFORM_ID", CommonUtil.onvl(pMap.get("MAILFORM_ID") ,"") );
		pMap.put("SEND_COM_TYPE", CommonUtil.onvl(pMap.get("SEND_COM_TYPE") ,"") );
		pMap.put("RECV_COM_TYPE", CommonUtil.onvl(pMap.get("RECV_COM_TYPE") ,"") );
		pMap.put("SEND_COM_CODE", CommonUtil.onvl(pMap.get("SEND_COM_CODE") ,"") );
		pMap.put("SEND_USER_ID", CommonUtil.onvl(pMap.get("SEND_USER_ID") ,"") );
		pMap.put("KEY1", CommonUtil.onvl(pMap.get("KEY1") ,"") );
		pMap.put("KEY2", CommonUtil.onvl(pMap.get("KEY2") ,"") );
		pMap.put("KEY3", CommonUtil.onvl(pMap.get("KEY3") ,"") );
		pMap.put("KEY4", CommonUtil.onvl(pMap.get("KEY4") ,"") );
		pMap.put("KEY5", CommonUtil.onvl(pMap.get("KEY5") ,"") );
		pMap.put("KEY5SEQ", CommonUtil.onvl(pMap.get("KEY5SEQ") ,"N") ); // Y -> max+1 , N ->KEY5
		pMap.put("KEY6", CommonUtil.onvl(pMap.get("KEY6") ," ") );
		pMap.put("KEY7", CommonUtil.onvl(pMap.get("KEY7") ,"") );
		pMap.put("KEY8", CommonUtil.onvl(pMap.get("KEY8") ,"") );
		pMap.put("KEY9", CommonUtil.onvl(pMap.get("KEY9") ,"") );
		pMap.put("KEY10", CommonUtil.onvl(pMap.get("KEY10") ,"") );
		pMap.put("CRE_DATE", CommonUtil.onvl(pMap.get("CRE_DATE") ,"") );
		pMap.put("ERR_DATE", CommonUtil.onvl(pMap.get("ERR_DATE") ,"") );
		
		
		int re = StaticContextAccessor.getBean(CommonCodeDao.class).insertMailSend(pMap);	  
		return re;
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

} 


    
