package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNewDoctorBatchRegDao {

	public List<Map<String, Object>> selectList(Map<String, String> formData);

	public Map<String, String> setNewDoctorCreatePo(List<Map<String, String>> pList);

}
