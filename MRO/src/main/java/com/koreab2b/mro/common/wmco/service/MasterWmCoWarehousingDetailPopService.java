package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

public interface MasterWmCoWarehousingDetailPopService {
	// TR입과 확정 조회 
	public List<Map<String,String>> getDetail(Map<String,Object>  formData);
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	// TR입고 확정
	public String updateSelectedData(Map<String, String> formData,List<Object> gridData);
	public String updateSelectedData_v2(Map<String, String> formData,List<Object> gridData);
	//TR 출고
	public String updateSelectedDataIvt(Map<String, String> formData,List<Object> gridData);
}
