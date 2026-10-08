package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvWarehousingDetailPopDao {

	// 조회
	public Map<String,String> selectList1(Map<String,String> formData);
	public List<Map<String,String>> selectList2(Map<String,String> formData);

}
