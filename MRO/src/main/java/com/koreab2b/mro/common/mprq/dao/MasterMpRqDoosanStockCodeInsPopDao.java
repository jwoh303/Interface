package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDoosanStockCodeInsPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	public String saveDoosanStockCode(Map<String,String>  formData, List<Object> gridData);
}
