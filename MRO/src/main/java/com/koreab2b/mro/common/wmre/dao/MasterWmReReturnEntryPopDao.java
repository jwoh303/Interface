package com.koreab2b.mro.common.wmre.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmReReturnEntryPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	public List<Map<String,String>> selectPopList(Map<String,String> formData);
	
	public List<Map<String,String>> selectUpdateList(Map<String,Object> formData);
	public List<Map<String,String>> getMasterWmReReturnEntryPopForUpdateSeller_v2(Map<String,Object> formData);
	
	
	public List<Map<String,String>> selectPopBuyerList(Map<String,String> formData);
	public List<Map<String,String>> getPopBuyer_v2(Map<String,String> formData);
	
	public List<Map<String,String>> selectRegPopList(Map<String,String> formData);
	
	public String saveMasterWmReReturnEntryPop(Map<String,String> formData);
	
	public String saveMasterWmReReturnEntryCancelPop(Map<String,String> formData);
	
	public String saveMasterWmReReturnWmNoPop(Map<String,String> formData);
	public String saveMasterWmReReturnWmNoPop_v2(Map<String,String> formData);
	
	public String cancelMasterWmReReturnWmNoPop(Map<String,String> formData);
	
	
	public List<Map<String,String>> selectReturnPoInfo(Map<String,Object> formData);
}
