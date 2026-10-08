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
public interface HanjinDao {
	public List<Map<String,Object>> selectHanjinItemList() throws Exception;
	public void updateHanjinOrder(Map<String,Object> item) throws Exception;	
	public void updateHanjinOrderAllFail() throws Exception;
	public List<Map<String,Object>> selectHanjinCancelList() throws Exception;	
	public void updateHanjinCancel(Map<String, Object> item) throws Exception;	
	public void updateHanjinCancelAllFail() throws Exception;
	public List<Map<String,Object>> selectHanjinPrintList() throws Exception;
}
