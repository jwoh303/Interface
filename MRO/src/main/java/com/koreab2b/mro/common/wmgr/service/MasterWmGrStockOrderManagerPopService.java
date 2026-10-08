package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

public interface MasterWmGrStockOrderManagerPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 발주 pop조회
	public List<Map<String,String>> getPop(Map<String,String>  formData);
	
	//발주삭제
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPoDel(Map<String,String>  formData, List<Object> gridData);

	// 단가변경
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopPriceChange(Map<String,String>  formData, List<Object> gridData);
	
	//공급사변경
	@Transactional
	public String deleteMasterWmGrStockOrderManagerPopAgentChange(Map<String,String>  formData, List<Object> gridData);
}
