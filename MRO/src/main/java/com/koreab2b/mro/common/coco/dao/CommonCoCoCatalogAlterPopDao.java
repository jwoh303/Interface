package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonCoCoCatalogAlterPopDao {
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
}
