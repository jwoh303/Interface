package com.koreab2b.lottecs.service;

import java.util.Map;

public interface LottecsService {
	
	/**
	 * 롯데 결재 연동  
	 * @param pMap
	 */
	public Map<String, Object> getLotteMpRqAppSend(Map<String, Object> pMap) throws Exception;


}
