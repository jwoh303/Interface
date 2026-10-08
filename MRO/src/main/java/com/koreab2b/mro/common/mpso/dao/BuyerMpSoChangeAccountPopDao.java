package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoChangeAccountPopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);
	// 저장
	public String saveBuyerMpSoChangeAccountPop(Map<String,String>  formData);
}
