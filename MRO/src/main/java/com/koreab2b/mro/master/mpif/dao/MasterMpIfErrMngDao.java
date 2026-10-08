package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfErrMngDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	public String insertTotal(Map<String,Object> param);
	
	public String insertSubTotal(Map<String,String>  formData, List<Object> gridData);

	public List<Map<String, String>> selectNewList(Map<String, Object> param);

	public List<Map<String, String>> selectMpifNewErrMngPop(Map<String, Object> pMap);

	public String saveMpifNewErrMngPop(Map<String, String> pMap);

	
}
