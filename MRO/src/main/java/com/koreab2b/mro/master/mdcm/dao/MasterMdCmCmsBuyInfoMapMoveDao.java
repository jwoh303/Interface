package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

/**
 * 표준DB 구매정보 > 고객사 매핑 이관 (s32~s36)
 *
 * 매핑 축 = ICOMCQDT 의 CMS_CATLG_ID + CATLG_SEQ + CSV_YN.
 */
public interface MasterMdCmCmsBuyInfoMapMoveDao {

	// 표준DB 단건 정보 (기존/변경 패널 공용)
	public Map<String,String> selectStdInfo(Map<String,Object> param);

	// 이관 대상 고객사 매핑정보 목록
	public List<Map<String,String>> selectCustList(Map<String,Object> param);

	// 변경 표준DB 조회 (s34)
	public List<Map<String,String>> selectStdSelList(Map<String,Object> param);

	// 매핑 이관 실행. 반영 건수를 돌려준다
	public int moveMapping(Map<String,String> param, List<Object> gridData);

	// 매핑변경 양식 행 (체크한 구매정보코드들의 고객사 매핑 전개)
	public List<Map<String,String>> selectMapFormList(Map<String,Object> param);

	// 업로드 검증용 - 변경 구매정보코드의 실재 여부와 협력사
	public List<Map<String,String>> selectMapTargetList(Map<String,Object> param);
}
