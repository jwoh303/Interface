/**
 * 
 */
package com.koreab2b.mro.webservice.hanssem.service;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HanssemService {
	/**
	 * Hanssem 예산 이벤트 추가
	 * @throws Exception 
	 */
	
	// 사용자 조회
	public List<Map<String,String>> selectUserId(String  userId);
	
	// 예산 이벤트 추가
	public String mergeHanssemBdgtTrxl(Map<String,Object>  param) throws Exception;


}
