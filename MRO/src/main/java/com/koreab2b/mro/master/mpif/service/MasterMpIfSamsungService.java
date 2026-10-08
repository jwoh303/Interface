package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSamsungService {

	public List<Map<String, String>> getSamsungPoList(Map<String, Object> pMap);
	
	public String saveMasterMpifSamsungPoReturn(Map<String, String> formData, List<Object> gridData);
}
