package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonPopupInfoDao {
	public List<Map<String,String>> getSidoCodeList();
	public List<Map<String,String>> getSigunguCodeList(Map<String,String>  pMap);
	
	public List<Map<String,String>> zipCodeSearch(Map<String,String>  pMap);
	public List<Map<String,String>> commonList(Map<String,String>  pMap);
	public List<Map<String,String>> commonList_v2(Map<String,Object>  pMap);
	
	public Map<String,String> getCmpyInfoPop(Map<String,String>  pMap);
	public List<Map<String,String>> getAgentInfoDiaplayPop(Map<String,String>  pMap);
	public List<Map<String,String>> getUserInfoDiaplayPop(Map<String,String>  pMap);
	public List<Map<String,String>> getAgentInfoExDiaplayPop(Map<String,String>  pMap);
	public List<Map<String,String>> getUserInfoDiaplayListPopCase1(Map<String,String>  pMap);
	public List<Map<String,String>> getUserInfoDiaplayListPopCase2(Map<String,String>  pMap);
	public List<Map<String,String>> getUserInfoDiaplayListPopCase3(Map<String,String>  pMap);
	
	public List<Map<String,String>> commonIcomcod1List(Map<String,String>  pMap);
	public List<Map<String,String>> getIcomcod1WhereList(Map<String,String>  pMap);
	public List<Map<String,String>> getIcomcod2List(Map<String,String>  pMap);
	public List<Map<String,String>> getIcomcod2List_v2(Map<String,Object>  pMap);
	public List<Map<String,String>> icomcdpopList(Map<String,String>  pMap);
	public Map<String,String> kepManagerPop(Map<String,String>  pMap);
	
	public List<Map<String,String>> getInvoiceDisplayPop1(Map<String,String>  pMap);
	public List<Map<String,String>> getInvoiceDisplayPop2(Map<String,String>  pMap);

	public List<Map<String,String>> commonCoCoDepartmentDetailViewPop(Map<String,String>  pMap);
	public List<Map<String,String>> commonCoCoAccountItemPop();
	public List<Map<String,String>> commonCoCoNationCodePop(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonCoCoBuyerBusnstypeClassifyPop(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonCoCoGoodsDlvyClssifyPop(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonCoCoTranGoodsPop();
	public List<Map<String,String>> getCommonCoCoLogisticCenterCatalogPop(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop(Map<String,String>  pMap);
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop_v2(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoCompanyPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoUserChoice2Pop(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodePop(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodeDiffPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoTeamClassifyPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getCommonCoCoExistingCatalogPop(Map<String,Object>  pMap);
	public List<Map<String,String>> getMasterMpSoAgntcmpyTypePop(Map<String,Object>  pMap);
	public List<Map<String,String>> getMasterMpSoWmsSearchPop(Map<String,Object>  pMap);
	public String getDeptCodeAdminCowayYn(Map<String,String>  pMap);
	public Map<String,String> getSysopCatalogBuyerInfo(Map<String,Object>  pMap);
	
	
	
	/**
	 * 관리고객사지정
	 */
	public List<Map<String,String>> getAdminSafetyCompanyCodeLeftList(Map<String,String>  pMap);
	public List<Map<String,String>> getAdminSafetyCompanyCodeRightList(Map<String,String>  pMap);
	public String saveAdminSafetyCompanyCode(Map<String,String>  pMap);

	public String getCheckedPoAgentList(Map<String,Object>  pMap);
	public String getCheckedPoAgentDeptList(Map<String,Object>  pMap);
	
	/**
	 * 코웨이 대표코드 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getZcodeList(Map<String, String> pMap);
	
	
	public String updateKtagList(Map<String, String> pMap);
	
	// 납품가능지역
	public List<Map<String,String>> getDeliAreaList(Map<String,String>  pMap);
	
	// 예산부서 팝업
	public List<Map<String,String>> getCommonCoCoBudgetDeptPop(Map<String,Object>  pMap);
	
	// 계정 팝업
	public List<Map<String,String>> getCommonCoCoAccountPop(Map<String,Object>  pMap);
	
	// 물류비 책정 사유
	public List<Map<String,String>> getLogisFeeReasonPop(Map<String,String>  pMap);
	//예산부서별 주문금액
	public List<Map<String,String>> getBudegtOrderAmtPop(Map<String,String>  pMap);
	// 고객사 메일수신지정
	public List<Map<String,String>> getUserMailRecvChoicePop(Map<String,String>  pMap);
	// 고객사 견적 입찰상세내역
	public List<Map<String,String>> getNsAgentInfoPop(Map<String,String>  pMap);
	// 고객사 견적상세팝업_제출상세
	public List<Map<String,String>> getQuotDetailInfoPop(Map<String,String>  pMap);
	// 고객사 납품가능지역 팝업
	public List<Map<String,String>> getBuyerDelyAreaInfoPop(Map<String,String>  pMap);
	// 고객사 네고이력팝업
	public List<Map<String,String>> getNegoLogInfo(Map<String,String>  pMap);
	// 개인정보처리방침 협력사리스트
	public List<Map<String,String>> getPrivacySeller(Map<String,String>  pMap);
	// 도착지정보 리스트
	public List<Map<String,String>> commonDlyLocationList(Map<String,Object>  pMap);
	// 회원가입 회원사 검색 리스트
	public List<Map<String,String>> getComCodeList(Map<String,String>  pMap);
	// BQMS 배송조회 팝업 링크
	public List<Map<String,String>> getBqmsInvoiceSearch(Map<String,String>  pMap);
	// 회원 조회 리스트
	public List<Map<String,String>> getUserList(Map<String,String>  pMap);
	public List<Map<String,String>> getUserList_v2(Map<String,Object>  pMap);
	//doc_no 로 파일 리스트 가져오기
	public List<Map<String,String>> getFileList_v2(Map<String,String>  pMap);
	//고객사 견적상세팝업_v2
	public Map<String, String> getQuotDetailInfoPop_v2(Map<String, String> pMap);
	//고객사 견적상세팝업삼양사_v2
	public Map<String, String> getQuotDetailInfoPopSYS_v2(Map<String, String> pMap);
	
	//고객사 견적상세팝업_v2 - 전체품목 상품정보
	public List<Map<String, String>> getQuotDetailAllPop_v2(Map<String, Object> pMap);
	// 고객사 견적상세팝업_상품정보
	public Map<String, String> getQuotDetailInfoPop2(Map<String, String> pMap);
	
	// 고객사 담당자 찾기_v2
	public List<Map<String,String>> getCompanyInfo_v2(Map<String,String>  pMap);
	public List<Map<String,String>> getKepManager_v2(Map<String,String>  pMap);
}
