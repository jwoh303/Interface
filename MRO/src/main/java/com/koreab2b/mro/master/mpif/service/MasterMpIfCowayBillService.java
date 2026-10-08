package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayBillService {

	/**
	 * 코웨이 마감전표내역 조회.
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getMasterMpIfCowayBillList(Map<String, Object> pMap);
	
	/**
	 * 코웨이 마감전표 전송
	 * @param pMap
	 * @return
	 */
	public String sendMasterMpIfCowayBill(Map<String, Object> pMap);
}
