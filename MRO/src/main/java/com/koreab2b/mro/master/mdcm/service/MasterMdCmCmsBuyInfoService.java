package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsBuyInfoService {

	// 목록 조회
	public List<Map<String,String>> getList(Map<String,Object> param);

	// 상세 단건 조회 (TCODE 키)
	public Map<String,String> getDetail(Map<String,Object> param);

	// 구매정보 변경이력 목록 조회 (p19)
	public List<Map<String,String>> getHistoryList(Map<String,Object> param);

	// 상세 팝업 고객사 매핑정보 목록
	public List<Map<String,String>> getDetailMapList(Map<String,Object> param);

	// 상세 팝업 규격 상세 속성 목록
	public List<Map<String,String>> getDetailAttrList(Map<String,Object> param);

	// 구매정보 상세 [변경] 반영 (인상은 품의 신청 생성)
	public String saveChange(Map<String,String> param, List<Object> gridData);

	// 구매정보 일괄수정 인상분 품의 신청 (SPM)
	public String requestBuyPriceUpBulk(Map<String,String> param, List<Object> gridData);

}
