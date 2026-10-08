package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoice3PopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> getListHd(Map<String,Object>  formData);
	public List<Map<String,String>> getListCode(Map<String,Object>  formData);
	public List<Map<String,String>> getListReNote(Map<String,Object>  formData);
	public String updateFileUpload(Map<String,String>  formData);
	public String saveMasterMpRqClose(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerRate(Map<String,Object>  formData);
	public List<Map<String,String>> getBuyerSum(Map<String,Object>  formData);
	public List<Map<String,String>> getBuyerSumB(Map<String,Object>  formData);
	public List<Map<String,String>> getProcessImportRate(Map<String,Object>  formData);
	public String saveMasterMpRqAgentSel(Map<String,String>  formData, List<Object> gridData);
	public void saveMasterMpRqMarketUnitPriceYn(Map<String,String>  formData);

}
