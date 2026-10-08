package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerProfileDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
