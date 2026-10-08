package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerJoinAlterRequestApprovalPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 리스트 조회
	public List<Map<String,String>> selectChargeEntryList(Map<String,Object> param);
		
	// 고객사 정보수정
	public String updateSelectedData(Map<String,String> formData);

	// 비밀번호 룰 적용
	public String selectPwdValidCheck(Map<String,String> formData);
	
	// KeP담당자 저장
	public String updateChargeEntryData(Map<String,String>  formData, List<Object> gridData);
		
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// sg별 매익율 리스트조회
	public List<Map<String,String>> selectSgMarginList(Map<String,Object> param);
	
	// sg별 매익율 저장
	public String updateSgMargin(Map<String,String>  formData, List<Object> gridData);
}
