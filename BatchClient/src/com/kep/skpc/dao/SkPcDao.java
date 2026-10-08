/**
 * 
 */
package com.kep.skpc.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface SkPcDao {
	public List<Map<String,Object>> selectSkPcToken() throws Exception;
	public List<Map<String,Object>> selectSkPcReQuoList() throws Exception;
	public List<Map<String,Object>> selectSkPcReRtList(Map<String,Object> reItem) throws Exception;
	public void updateSkPcReRt(Map<String,Object> reItem) throws Exception;	
	public void updateSkPcReRtErr() throws Exception;
	public List<Map<String,Object>> selectSkPcIvList() throws Exception;
	public void updateSkPcIvTrxl(Map<String,Object> ivItem) throws Exception;	
	public List<Map<String,Object>> selectSkPcItList() throws Exception;
	public void updateSkPcItSend(Map<String,Object> ivItem) throws Exception;
	public void updateSkPcItErr() throws Exception;	
}
