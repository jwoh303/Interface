package com.koreab2b.mro.master.mpiv.service;

import java.util.List;

import java.util.Map;

public interface MasterMpIvDeliveryDelayListService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
}
