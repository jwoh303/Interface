package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqItemReqRcptService {
	public List<Map<String,String>> getList(Map<String,Object>  pMasterMpRqItemReqRcpt);

	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public List<Map<String,String>> getListBoard(Map<String,Object>  pMasterMpRqItemReqRcpt);

	public String updateSelectedDataBoard(Map<String,String>  formData, List<Object> gridData);

}
