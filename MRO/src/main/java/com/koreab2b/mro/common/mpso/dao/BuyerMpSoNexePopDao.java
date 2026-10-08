package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNexePopDao {

	List<Map<String, String>> selectList(Map<String, String> formData);

	List<Map<String, String>> getRefNoList(Map<String, String> formData);


}
