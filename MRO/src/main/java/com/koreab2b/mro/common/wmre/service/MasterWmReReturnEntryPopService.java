package com.koreab2b.mro.common.wmre.service;

import java.util.List;
import java.util.Map;

public interface MasterWmReReturnEntryPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	public List<Map<String,String>> getPop(Map<String,String>  formData);
	
	public List<Map<String,String>> getUpdate(Map<String,Object>  formData);
	public List<Map<String,String>> getMasterWmReReturnEntryPopForUpdateSeller_v2(Map<String,Object>  formData);
	
	public List<Map<String,String>> getPopBuyer(Map<String,String>  formData);
	public List<Map<String,String>> getPopBuyer_v2(Map<String,String>  formData);
	
	public List<Map<String,String>> getRegPop(Map<String,String>  formData);
	
	public String saveMasterWmReReturnEntryPop(Map<String,String>  formData);
	
	public String saveMasterWmReReturnEntryCancelPop(Map<String,String>  formData);
	
	public String saveMasterWmReReturnWmNoPop(Map<String,String>  formData);
	public String saveMasterWmReReturnWmNoPop_v2(Map<String,String>  formData);
	
	
	public String cancelMasterWmReReturnWmNoPop(Map<String,String>  formData);
	
	public List<Map<String,String>> getReReturnPoInfo(Map<String,Object>  formData);
}
