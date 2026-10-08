package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNexePopService {

	List<Map<String, String>> getList(Map<String, String> formData);

	List<Map<String, String>> getRefNoList(Map<String, String> formData);
	

}
