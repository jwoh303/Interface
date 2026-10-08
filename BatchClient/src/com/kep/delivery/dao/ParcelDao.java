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
public interface ParcelDao {
	public List<Map<String,Object>> selectParcelToken() throws Exception;
	public List<Map<String,Object>> selectParcelTrkgList() throws Exception;	
	public void updateParcelTrkg(Map<String,Object> item) throws Exception;
	public void updateParcelTrkgAllFail() throws Exception;
	public List<Map<String,Object>> selectParcelSrchList() throws Exception;
	public void updateParcelSrch(Map<String,Object> item) throws Exception;
	public void updateParcelSrchAllFail(Map<String, Object> tmp) throws Exception;
	public void insertParcelSrchDt(Map<String,Object> item) throws Exception;	
}
