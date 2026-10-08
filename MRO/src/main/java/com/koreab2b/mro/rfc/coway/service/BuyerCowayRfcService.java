package com.koreab2b.mro.rfc.coway.service;

import java.util.List;
import java.util.Map;

/**
 * 출고확정조회 RFC 인터페이스
 * 
 * @author Swordfish
 * @remark PR번호 Receiver
 */
public interface BuyerCowayRfcService {
	public void getRfcConnection(Map<String, String> paramMap);

	public void cleanUp();

	public List<Map<String, String>> getRfc(Map<String, String> paramMap);

	public List<Map<String, String>> getRfc(Map<String, String> paramMap, List<Map<String, String>> pList);

	public Map<String, String> setRfc(Map<String, String> paramMap);

	public Map<String, String> setRfc(Map<String, String> paramMap, List<Map<String, String>> pList);
}
