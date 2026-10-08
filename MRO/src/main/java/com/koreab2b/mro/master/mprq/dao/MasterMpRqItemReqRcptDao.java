package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqItemReqRcptDao {
	public List<Map<String,String>> selectList(Map<String,Object> pSample);

	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public List<Map<String,String>> selectListBoard(Map<String,Object> pSample);

	public String updateSelectedDataBoard(Map<String,String>  formData, List<Object> gridData);

}
