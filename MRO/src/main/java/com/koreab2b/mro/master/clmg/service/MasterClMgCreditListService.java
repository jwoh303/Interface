package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

public interface MasterClMgCreditListService {
	
		// 리스트조회
		public List<Map<String,String>> getList(Map<String,Object>  param);
		// 리스트조회
		public List<Map<String,String>> getDetailList(Map<String,Object>  param);
}
