package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

public interface MasterMdAmWmsHomeService {
	
	// 물류센터 공지사항 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

}
