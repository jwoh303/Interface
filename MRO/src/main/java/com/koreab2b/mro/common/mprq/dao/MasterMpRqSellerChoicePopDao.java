package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoicePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 비고 조회
	public List<Map<String,String>> selectListRemark(Map<String,Object> pMap);
	
	// 추가라운드요청
	public String saveAgentRoundReq(Map<String,String>  formData, List<Object> gridData);
}
