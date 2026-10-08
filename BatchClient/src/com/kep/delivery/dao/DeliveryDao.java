/**
 * 
 */
package com.kep.delivery.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface DeliveryDao {
	public List<Map<String,Object>> selectDeliveryItemList() throws Exception;
	public void updateDeliveryItem(List<Map<String,Object>> item) throws Exception;
	public void updateDeliAllFail() throws Exception;
}
