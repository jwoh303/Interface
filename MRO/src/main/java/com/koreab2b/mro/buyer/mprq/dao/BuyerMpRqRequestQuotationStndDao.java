package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestQuotationStndDao {

	public String updateSelectedDataNoPass(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataPass(Map<String,String> formData, List<Object> gridData);
	public String updateSelectedDataNoPass_v2(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataPass_v2(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedData_v2(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataTemp(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataTemp_v2(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataTempGpl(Map<String,String> formData);
}
