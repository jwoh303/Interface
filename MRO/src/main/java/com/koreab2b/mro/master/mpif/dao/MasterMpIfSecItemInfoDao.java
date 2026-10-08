package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSecItemInfoDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 이벤트 삭제
	public String deleteItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 품목정보 수정
	public String updateItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 재견적 진행
	public String requotItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 재등록.
	public String registItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	// 견적취소.
	public String cancelItemInfo(Map<String, String> pFormData, List<Object> pGridData);
	/*
	 * 단가 미회신 내역에 대해서 재전송함.
	 */
	public String resendPrice(Map<String, String> pFormData, List<Object> pGridData);
}
