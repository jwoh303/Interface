/**
 * 
 */
package com.kep.hugel.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HugelDao {

	// 조회
	public List<Map<String,String>> selectHugelPrList() throws Exception;
	public Map<String,Object> selectHugelPrHeader(Map<String,String> obj) throws Exception;	
	public List<Map<String,Object>> selectHugelPrItemList(Map<String,String> obj) throws Exception;
	public List<Map<String,Object>> selectHugelChgDelList() throws Exception;	
	public int updatePrData(Map<String,Object>  prRsltData) throws Exception;
	public boolean updateProgress(Map<String,String>  pMap) throws Exception;	
	public void callProcHuglErr(Map<String,Object>  resultMap) throws Exception;
	public void updateResultData(Map<String,Object> obj) throws Exception;	
}
