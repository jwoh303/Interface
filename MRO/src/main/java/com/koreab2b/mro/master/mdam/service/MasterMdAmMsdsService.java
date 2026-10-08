package com.koreab2b.mro.master.mdam.service;

import java.util.List;

import java.util.Map;

public interface MasterMdAmMsdsService {
	
	// 리스트조회 ,엑셀다운로드
	public List<Map<String,String>> getList(Map<String,Object>  param);

}
