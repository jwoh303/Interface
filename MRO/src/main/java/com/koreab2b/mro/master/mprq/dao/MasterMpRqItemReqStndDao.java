package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqItemReqStndDao {
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	
	public void replyMail(Map<String,String> formData, List<Object> gridData);
}
