package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemExcelUploadService {

	// 카테고리별 동적 속성 컬럼 정의 조회 (속성1·속성2…) — 엑셀양식/그리드 공용
	public List<Map<String,String>> getAttrColumns(Map<String,Object> param);

	// 담당(세션 사용자) 카테고리별 속성 조회 (CMS_CATEG_ID + ATTR1~20)
	public List<Map<String,String>> getFormList(Map<String,Object> param);

	// 조회된 행들에서 사용된 속성(ATTR1~20)의 최대 개수 — 동적 속성 컬럼 개수
	public int getMaxAttrCount(List<Map<String,String>> rows);

	// 일괄수정 결과 - 상품정보코드별 [기존] 값. 건수 제한 없이 받는다(내부에서 1000건씩 잘라 조회).
	public List<Map<String,String>> getBeforeList(List<String> codes);

	// 일괄수정 결과 - 실재하는 상품정보코드만 걸러 돌려준다(대체코드 미존재 판정용).
	public List<String> getExistingCodes(List<String> codes);

	// 일괄수정 - 실재하는 제조사코드(ICOMCOD1 M104)만 걸러 돌려준다.
	public List<String> getExistingMakerCodes(List<String> codes);

	// 일괄수정 - 실재하는 원산지코드(ICOMCOD1 M001)만 걸러 돌려준다.
	public List<Map<String,String>> getMakerNames(List<String> codes);

	public List<String> getExistingOriginCodes(List<String> codes);

	/*
	 * 일괄수정 양식 다운로드 - 선택한 상품정보코드의 양식 1행씩.
	 * 입력 순서를 그대로 유지하고, 없는 코드는 상품정보코드만 채운 행으로 돌려준다.
	 */
	public List<Map<String,String>> getModFormRows(List<String> codes);

	// 일괄수정 양식 - 상품상태 변경사유 목록. [0] = 미사용 방향, [1] = 사용 방향.
	public List<List<String>> getStatusReasonLists();

	// 양식 드롭다운용 TR취급가능여부 명칭 목록
	public List<String> getTrHandleNames();

	/*
	 * 기준가 일괄수정 양식 다운로드 - 선택한 상품정보코드의 양식 1행씩.
	 * 입력 순서를 그대로 유지하고, 없는 코드는 상품정보코드만 채운 행으로 돌려준다.
	 */
	public List<Map<String,String>> getBasePriceFormRows(List<String> codes);

	// 기준가 일괄수정 결과 - 업로드한 상품정보코드의 [기존] 기준가 값.
	public List<Map<String,String>> getBasePriceBeforeList(List<String> codes);

	// 기준가 일괄수정 - 기준가유형 명칭 목록(ICOMCOD1 M183). 양식 드롭다운·업로드 검증 공용.
	public List<String> getBasePriceTypeNames();

}
