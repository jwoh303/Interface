package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsBuyInfoExcelUploadDao {

	// 일괄등록 결과 - 업로드한 상품정보코드의 기본정보
	public List<Map<String,String>> selectItemList(Map<String,Object> param);

	// 일괄등록 결과 - 그 상품에 이미 달린 구매정보의 중복 판정 키
	public List<Map<String,String>> selectExistingKeyList(Map<String,Object> param);

	// 일괄등록 결과 - 협력사 실재 여부·명칭
	public List<Map<String,String>> selectAgentList(Map<String,Object> param);

	// 일괄등록 - 품목구분 목록(ICOMCOD1 M132)
	public List<Map<String,String>> selectItemMakeTypeList();

	// 일괄등록 - 입고TR(물류센터) 목록(ICOMCOD1 W001)
	public List<Map<String,String>> selectWarehouseList();

	// 일괄수정 - 구매정보코드별 현재값
	public List<Map<String,String>> selectModBeforeList(Map<String,Object> param);

	// 일괄수정 - 공급상태 변경사유 목록(ICOMCOD1 M185)
	public List<Map<String,String>> selectSupplyReasonList();

	// 일괄수정 - 과세구분 목록(ICOMCOD1 TX17)
	public List<Map<String,String>> selectTaxTypeList();

	// 일괄수정 - 대체코드(상품정보코드) 실재 확인
	public List<String> selectCatlgExists(Map<String,Object> param);

	// 일괄수정 [확인] - 구매정보 1건 반영
	public int updateBuyInfoMod(Map<String,Object> param);

	// 일괄등록 [확인] - 구매정보 1건 등록
	public int insertBuyInfo(Map<String,Object> param);

}
