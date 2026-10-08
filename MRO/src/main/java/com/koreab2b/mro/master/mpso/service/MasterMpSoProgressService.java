package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProgressService {
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	public int updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public int updateFileData(Map<String,String>  formData, List<Object> gridData);
	
	public int saveIKENSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public String getMasterMpSoMyColManagePopList(Map<String,Object>  formData);
	
	public String saveMasterMpSoMyColManagePop(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getDownLoadList(Map<String,Object>  formData);
}
