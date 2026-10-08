package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProgressDmSendPopService {

	List<Map<String, String>> getPoList(Map<String, Object> param);

	List<Map<String, String>> getUserList(Map<String, Object> param);

	String DmSend(Map<String, String> formData, List<Object> gridData);
	
}
