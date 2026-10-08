package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoicePopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	// 비고 조회
	public List<Map<String,String>> getListRemark(Map<String,Object>  formData);
	// 추가라운드요청
	public String saveAgentRoundReq(Map<String,String>  formData, List<Object> gridData);
}
