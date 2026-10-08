/**
 * 
 */
package com.koreab2b.delivery.service;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface DeliveryService {
	/**
	 * 택배 API
	 * @throws Exception 
	 */
	
	// 추적 데이터 수신
	public String insertDeliveryResult(Map<String,Object>  data) throws Exception;
	public String updateParcelSign(Map<String,Object>  data) throws Exception;
	public String updateParcelSignCp(Map<String,Object>  data) throws Exception;
}
