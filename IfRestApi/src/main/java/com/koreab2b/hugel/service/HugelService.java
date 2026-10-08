package com.koreab2b.hugel.service;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HugelService {
	/**
	 * 휴젤 입고 
	 * @throws Exception 
	 */
	
	// 입고
	public String insertHugelGrData(Map<String,Object>  grData) throws Exception;
}
