/**
 * 
 */
package com.kep.hkInn.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HkInnDao {
	// 조회
	public List<Map<String,Object>> checkTokenVal() throws Exception;
	public void mergeHkInnToken(Map<String,Object> newToken) throws Exception;
	public void updateItemFlag() throws Exception;
	public List<Map<String,Object>> selectHkInnBrandList(Map<String,Object> cntMap) throws Exception;
	public void updateHkInnBrandData(Map<String,Object> isSuccess) throws Exception;
	public List<Map<String,Object>> selectHkInnItemList() throws Exception;
	public void updateItemRslt(Map<String,Object> resultMap) throws Exception;
	public List<Map<String,Object>> selectHkInnPoCancelIdx() throws Exception;
	public List<Map<String,Object>> selectHkInnPoCancelList(Map<String,Object> idx) throws Exception;
	public void updateHkInnDelNotInterPo() throws Exception;
	public List<Map<String,Object>> selectHkInnPoStatusIdx() throws Exception;
	public List<Map<String,Object>> selectHkInnPoStatusItem(Map<String,Object> idx) throws Exception;	
	public void updateHkInnPoStatus(Map<String,Object>  poStatusRsltData) throws Exception;
	public void updateHkInnPoCancel(Map<String,Object>  poCancelRsltData) throws Exception;
	public void updateHkInnPoCancelFail(Map<String,Object>  poCancelRsltData) throws Exception;
	public List<Map<String,Object>> selectHkInnIvList() throws Exception;
	public void updateHkInnIvData(Map<String,Object>  ivData) throws Exception;
}
