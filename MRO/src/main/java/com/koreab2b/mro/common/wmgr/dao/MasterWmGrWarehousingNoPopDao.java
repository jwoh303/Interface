package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrWarehousingNoPopDao {

	// 조회
	public Map<String,String> selectList1(Map<String,String> formData);
	public List<Map<String,String>> selectList2(Map<String,String> formData);

}
