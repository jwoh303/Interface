package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmWmsHomeDao {
	
	// 물류센터 공지사항 리스트조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

}
