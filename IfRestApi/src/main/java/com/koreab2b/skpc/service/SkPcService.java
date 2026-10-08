/**
 * 
 */
package com.koreab2b.skpc.service;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface SkPcService {
	/**
	 * SK퓨어코어 견적, 발주, 입고
	 * @throws Exception 
	 */
	
	// 견적
	public String updateSkPcRe(Map<String,Object>  reData) throws Exception;
	
	// 발주
	public String insertSkPcPo(Map<String,Object>  poData) throws Exception;
	
	// 입고
	public String insertSkPcGr(Map<String,Object>  grData) throws Exception;

}
