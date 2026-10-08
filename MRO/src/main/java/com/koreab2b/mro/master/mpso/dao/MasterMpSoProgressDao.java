package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProgressDao {
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	public int updateSelectedData(Map<String,String> formData, List<Object> gridData);
	
	public int updateFileData(Map<String,String> formData, List<Object> gridData);
	
	public int saveIKENSelectedData(Map<String,String> formData, List<Object> gridData);
	
	public String selectMasterMpSoMyColManagePopList(Map<String,Object> formData);
	
	public String insertMasterMpSoMyColManagePop(Map<String,String> pMap);
	
	public List<Map<String,String>> selectDownLoadList(Map<String,Object> formData);
	
}
