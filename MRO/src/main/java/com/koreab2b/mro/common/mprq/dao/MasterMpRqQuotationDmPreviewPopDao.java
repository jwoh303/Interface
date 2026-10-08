package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqQuotationDmPreviewPopDao {
	// 견적내용 조회
	public List<Map<String,String>> selectList(Map<String,Object> pMap);
}
