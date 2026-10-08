package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsBuyInfoDao {

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 상세 단건 조회 (TCODE 키)
	public Map<String,String> selectDetail(Map<String,Object> param);

	// 구매정보 변경이력 목록 조회
	public List<Map<String,String>> selectHistoryList(Map<String,Object> param);

	// 상세 팝업 고객사 매핑정보 목록
	public List<Map<String,String>> selectDetailMapList(Map<String,Object> param);

	// 상세 팝업 규격 상세 속성 목록
	public List<Map<String,String>> selectDetailAttrList(Map<String,Object> param);

	// 구매정보 상세 [변경] 반영. 인상 매입단가는 반영하지 않고 품의 신청만 만들어 PM_NO 를 돌려준다
	public String saveBuyInfoChange(Map<String,String> param, List<Object> gridData);

	// 구매정보 일괄수정 인상분 품의 신청(SPM). 채번된 PM_NO 를 돌려준다
	public String requestBuyPriceUpBulk(Map<String,String> param, List<Object> gridData);

}
