package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsBuyInfoExcelUploadService {

	// 일괄등록 결과 - 업로드한 상품정보코드의 기본정보(품목명·모델번호·규격·제조사·단위). 실재 판정도 이 결과로 한다.
	public List<Map<String,String>> getItemList(List<String> codes);

	// 일괄등록 결과 - 업로드한 상품에 이미 달려 있는 구매정보의 중복 판정 키.
	public List<Map<String,String>> getExistingKeyList(List<String> codes);

	// 일괄등록 결과 - 실재하는 협력사(ICOMCMPY BUSINESS_COND='S')의 코드·명.
	public List<Map<String,String>> getAgentList(List<String> codes);

	// 일괄등록 - 품목구분 코드 목록(ICOMCOD1 M132). 양식 드롭다운·업로드 검증 공용.
	public List<String> getItemMakeTypeCodes();

	// 일괄등록 - 입고TR(물류센터) 목록. 반환 계약 CODE / WAREHOUSE_NAME. 양식 드롭다운·업로드 검증 공용.
	public List<Map<String,String>> getWarehouseList();

	// 일괄수정 결과 - 업로드한 구매정보코드의 현재값. 양식 다운로드와 같은 조회를 쓴다.
	public List<Map<String,String>> getModBeforeList(List<String> buyInfoIds);

	/*
	 * 일괄수정 양식 다운로드 - 선택한 구매정보코드의 양식 1행씩.
	 * 입력 순서를 그대로 유지하고, 없는 코드는 구매정보코드만 채운 행으로 돌려준다.
	 */
	public List<Map<String,String>> getModFormRows(List<String> buyInfoIds);

	// 일괄수정 - 공급상태 변경사유 목록(CODE/REASON_NAME/DIRECTION/ALT_REQUIRED).
	public List<Map<String,String>> getSupplyReasonList();

	// 일괄수정 양식 - 변경사유 드롭다운에 쓸 명칭 목록.
	public List<String> getSupplyReasonNames();

	// 일괄수정 - 과세구분 목록(CODE/TAX_NAME).
	public List<Map<String,String>> getTaxTypeList();

	// 일괄수정 양식 - 품목구분 드롭다운에 쓸 명칭 목록.
	public List<String> getItemMakeTypeNames();

	// 일괄수정 - 실재하는 상품정보코드만 걸러 돌려준다(대체코드 미존재 판정용).
	public List<String> getExistingCatlgCodes(List<String> codes);

	// 일괄등록 양식 - 입고TR 드롭다운에 쓸 센터명 목록.
	public List<String> getWarehouseNames();

	// 일괄수정 [확인] - 화면이 걸러 낸 정상 건을 CMSPRICE 에 반영한다. 반환은 반영 건수.
	public int saveModBulk(String userId, List<Object> gridData);

	// 일괄등록 [확인] - 화면이 걸러 낸 정상 건을 CMSPRICE 에 넣는다. 반환은 등록 건수.
	public int saveRegBulk(String userId, List<Object> gridData);

}
