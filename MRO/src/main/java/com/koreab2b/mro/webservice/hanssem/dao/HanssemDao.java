/**
 * 
 */
package com.koreab2b.mro.webservice.hanssem.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HanssemDao {
	
	// 사용자 조회
	public List<Map<String,String>> selectUserId(String userId);
		
	// Hanssem 예산 이벤트 추가
	public String mergeHanssemBdgtTrxl(Map<String, Object> param) throws Exception;

}
