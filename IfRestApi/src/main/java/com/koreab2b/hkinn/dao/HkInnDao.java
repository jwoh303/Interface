/**
 * 
 */
package com.koreab2b.hkinn.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HkInnDao {
	// 발주
	public String insertHkInnPoData(Map<String, Object> poData) throws Exception;
	
	// 입고
	public String insertHkInnGrData(Map<String, Object> grData) throws Exception;
	
	// 브랜드 조회
	public List<Map<String, Object>> selectBrandLst() throws Exception;
}
