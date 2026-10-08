/**
 * 
 */
package com.kep.aeky.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface AekyDao {
	public List<Map<String,Object>> selectAekyArSendHd() throws Exception;
	public List<Map<String,Object>> selectAekyArSend(Map<String, Object> iMap) throws Exception;
	public List<Map<String,String>> selectParamKey() throws Exception;	
	public void updateAekyArSend(Map<String,Object>  pMap) throws Exception;
	public void insertAekyBdgt(Map<String,Object>  pMap) throws Exception;
	public List<Map<String,String>> selectParamMroKey() throws Exception;
}
