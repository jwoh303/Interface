/**
 * 
 */
package com.koreab2b.skmw.service;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface SkMwService {
	/**
	 * SK마이크로웍스 발주, 입고
	 * @throws Exception 
	 */
	
	// 품목 회신
	public String updateSkMwItem(Map<String,Object>  itemData) throws Exception;
	
	// 발주
	public String insertSkMwPo(Map<String,Object>  poData) throws Exception;
	
	// 입고
	public String insertSkMwGr(Map<String,Object>  grData) throws Exception;

}
