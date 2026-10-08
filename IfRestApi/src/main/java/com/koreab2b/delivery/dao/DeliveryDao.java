/**
 * 
 */
package com.koreab2b.delivery.dao;

import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface DeliveryDao {
	// 추적 데이터 수신
	public String insertDeliveryResult(Map<String, Object> data) throws Exception;
	public String updateParcelSign(Map<String, Object> data) throws Exception;
	public String updateParcelSignCp(Map<String, Object> data) throws Exception;
}
