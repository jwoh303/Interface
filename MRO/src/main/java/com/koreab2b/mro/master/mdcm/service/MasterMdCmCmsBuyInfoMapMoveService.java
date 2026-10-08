package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsBuyInfoMapMoveService {

	// 표준DB 단건 정보 (기존/변경 패널 공용)
	public Map<String,String> getStdInfo(Map<String,Object> param);

	// 이관 대상 고객사 매핑정보 목록
	public List<Map<String,String>> getCustList(Map<String,Object> param);

	// 변경 표준DB 조회 (s34)
	public List<Map<String,String>> getStdSelList(Map<String,Object> param);

	// 매핑 이관 실행
	public int moveMapping(Map<String,String> param, List<Object> gridData);

	// 매핑변경 양식 행
	public List<Map<String,String>> getMapFormList(List<String> codes);

	// 업로드 검증용 - 변경 구매정보코드의 실재 여부와 협력사
	public List<Map<String,String>> getMapTargetList(List<String> codes);
}
