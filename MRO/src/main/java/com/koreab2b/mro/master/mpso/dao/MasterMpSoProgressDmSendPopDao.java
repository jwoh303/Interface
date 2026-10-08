package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProgressDmSendPopDao {

	List<Map<String, String>> getPoList(Map<String, Object> param);

	List<Map<String, String>> getUserList(Map<String, Object> param);

	String DmSend(Map<String, String> formData, List<Object> gridData);
	
	
}
