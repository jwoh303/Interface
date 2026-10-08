/**
 * 
 */
package com.koreab2b.skpc.dao;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface SkPcDao {
	// 견적
	public String updateSkPcRe(Map<String, Object> reData) throws Exception;
		
	// 발주
	public String insertSkPcPo(Map<String, Object> poData) throws Exception;
	
	// 입고
	public String insertSkPcGr(Map<String, Object> grData) throws Exception;

}
