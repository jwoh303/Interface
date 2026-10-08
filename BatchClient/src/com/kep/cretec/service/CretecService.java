package com.kep.cretec.service;

import java.util.Map;

import org.apache.log4j.Logger;

public class CretecService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public void execute(String gubun) {
		
		CretecIfSignOn signObj = new CretecIfSignOn();
		
		Map<String, Object> loginRtn = signObj.signOn();
		
		if ("S".equals( (String)loginRtn.get("RTN_FLAG")  )) {
			String jSessionId	= (String)loginRtn.get("JSESSIONID");
			log.info("Cretec Login Success : " + jSessionId);
			
			if ("PO".equals(gubun)) {
				CretecIfPO poObj = new CretecIfPO(jSessionId);
				poObj.sendPO();
			} else if ("ITEM".equals(gubun)) {
				CretecItem itObj	= new CretecItem(jSessionId);
				itObj.checkItemInfo();
				itObj.changeItemStatus();
			} else {
				CretecIfIv itObj	= new CretecIfIv(jSessionId);
				itObj.statusIv(gubun);
			}
		} else {
			log.info("Cretec Login Fail....");
		}
	}
}