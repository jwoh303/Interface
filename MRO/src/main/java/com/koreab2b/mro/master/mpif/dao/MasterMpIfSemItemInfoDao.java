package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSemItemInfoDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 품목정보 저장/수정
	public String updateItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 재견적 진행
	public String requotItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 견적취소.
	public String cancelItemInfo(Map<String, String> pFormData, List<Object> pGridData);
}
