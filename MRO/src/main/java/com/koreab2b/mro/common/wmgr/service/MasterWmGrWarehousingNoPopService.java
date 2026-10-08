package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGrWarehousingNoPopService {
	// 조회
	public Map<String,String> getList1(Map<String,String>  formData);
	public List<Map<String,String>> getList2(Map<String,String>  formData);

}
