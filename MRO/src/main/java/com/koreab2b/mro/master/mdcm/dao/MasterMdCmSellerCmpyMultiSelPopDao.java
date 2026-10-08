package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmSellerCmpyMultiSelPopDao {

	// 협력사 목록 조회 - 페이징 없음
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
