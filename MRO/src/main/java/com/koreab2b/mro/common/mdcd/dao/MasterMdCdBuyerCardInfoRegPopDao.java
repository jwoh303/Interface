package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCdBuyerCardInfoRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
