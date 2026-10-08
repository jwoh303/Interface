package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemExcelUploadDao {

	// 카테고리별 동적 속성 컬럼 정의 조회 (실 속성 테이블 연결용 seam)
	public List<Map<String,String>> selectAttrColumns(Map<String,Object> param);

	// 담당(세션 사용자) 카테고리별 속성 조회 (CMS_CATEG_ID + ATTR1~20)
	public List<Map<String,String>> selectFormList(Map<String,Object> param);

	// 일괄수정 결과 - 업로드한 상품정보코드의 [기존](현재) 값. param 의 codeList 는 1000건 이하여야 한다.
	public List<Map<String,String>> selectBeforeList(Map<String,Object> param);

	// 일괄수정 결과 - 대체코드 실재 여부. 존재하는 코드만 돌아온다. codeList 는 1000건 이하.
	public List<String> selectCodeExists(Map<String,Object> param);

	// 일괄수정 - 제조사코드(ICOMCOD1 M104) 실재 여부. 존재하는 코드만. codeList 는 1000건 이하.
	public List<String> selectMakerExists(Map<String,Object> param);

	// 일괄수정 - 원산지코드(ICOMCOD1 M001) 실재 여부. 존재하는 코드만. codeList 는 1000건 이하.
	public List<Map<String,String>> selectMakerNames(Map<String,Object> param);

	public List<String> selectOriginExists(Map<String,Object> param);

	// 일괄수정 양식 - 상품상태 변경사유 목록(ICOMCOD1 M182). DIR / REASON_NAME / SEQ
	public List<Map<String,String>> selectReasonList();

	// 일괄수정 양식 - TR취급가능여부 목록(ICOMCOD1 M181). 양식 드롭다운 원본
	public List<Map<String,String>> selectTrHandleList();

	// 기준가 일괄수정 - 업로드/양식대상 상품정보코드의 [기존] 기준가 값. codeList 는 1000건 이하.
	public List<Map<String,String>> selectBasePriceBeforeList(Map<String,Object> param);

	// 기준가 일괄수정 - 기준가유형 목록(ICOMCOD1 M183). CODE / TYPE_NAME
	public List<Map<String,String>> selectBasePriceTypeList();

}
