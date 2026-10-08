package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoice3PopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> pMap);
	public List<Map<String,String>> selectListHd(Map<String,Object> pMap);
	public List<Map<String,String>> selectListCode(Map<String,Object> pMap);
	public List<Map<String,String>> selectListReNote(Map<String,Object> pMap);
	public String updateFileUpload(Map<String,String> pMap);
	public String saveMasterMpRqClose(Map<String,String> pMap);
	public List<Map<String,String>> getBuyerRate(Map<String,Object> pMap);
	public List<Map<String,String>> getBuyerSum(Map<String,Object> pMap);
	public List<Map<String,String>> getBuyerSumB(Map<String,Object> pMap);
	public List<Map<String,String>> getProcessImportRate(Map<String,Object> pMap);
	public String saveMasterMpRqAgentSel(Map<String,String>  formData, List<Object> gridData);
	public void saveMasterMpRqMarketUnitPriceYn(Map<String,String>  formData);
}
