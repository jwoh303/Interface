package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemDao {

	// 목록 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 상세 단건 조회
	public Map<String,String> selectDetail(Map<String,Object> param);

	// 상세 - 규격 상세 속성 목록 조회
	public List<Map<String,String>> selectDetailAttrList(Map<String,Object> param);

	// 상세 - 구매정보 리스트 조회
	public List<Map<String,String>> selectDetailBuyInfoList(Map<String,Object> param);

	// 변경이력 목록 조회
	public List<Map<String,String>> selectHistoryList(Map<String,Object> param);

	// 기준가 변경이력 목록 조회
	public List<Map<String,String>> selectBasePriceHistoryList(Map<String,Object> param);

	// 기준가 변경 팝업
	public Map<String,String> selectBasePriceInfo(Map<String,Object> param);

	// 기준가 인상 = 즉시 반영
	public int applyBasePrice(Map<String,String> param);

	// 기준가 인하 = 결재 상신용 신청 생성. 채번된 PM_NO 를 돌려준다
	public String requestBasePriceDown(Map<String,String> param);
	
	public String saveBasePriceBulk(Map<String,String> param, List<Object> gridData);

	// MSDS 매핑(등록·변경)
	public String saveSelectedMsdsMapping(Map<String,String> param, List<Object> gridData);

	// MSDS 매핑해제
	public String saveSelectedMsdsClean(Map<String,String> param, List<Object> gridData);

}
