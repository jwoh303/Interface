package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRegProgressDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 재소싱요청
	public String updateReSourcingData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 소싱변경 업로드
	public String batchSourcingData(Map<String,String>  formData, List<Object> gridData);
	
	// 판가변경 업로드
	public String batchUnitPriceData(Map<String,String>  formData, List<Object> gridData);
	
	// 카탈로그 등록 차수 팝업 조회
	public List<Map<String,String>> getMasterMdCmCatalogRegRevisionList(Map<String,Object> param);
	
	// 소싱제출, 판가제출 품의 상신
	public Map<String,String> updateData(Map<String,String>  formData, List<Object> gridData);
	
	// 소싱제출 품의 상신 조회
	public List<Map<String,String>> caRqResultList(Map<String,String>  formData);

	// 소싱제출 품의 요청
	public String  crsRequest(Map<String, String> param);
	
	// 소싱제출 품의 승인
	public String  crsApproval(Map<String, String> param);
	
	// 소싱제출 품의 반려
	public String  crsReject(Map<String, String> param);
	
	// 소싱제출 품의 취소
	public String  crsCancel(Map<String, String> param);
	
	// 판가제출 품의 요청
	public String  cruRequest(Map<String, String> param);
	
	// 판가제출 품의 승인
	public String  cruApproval(Map<String, String> param);
	
	// 판가제출 품의 반려
	public String  cruReject(Map<String, String> param);
	
	// 판가제출 품의 취소
	public String  cruCancel(Map<String, String> param);
}
