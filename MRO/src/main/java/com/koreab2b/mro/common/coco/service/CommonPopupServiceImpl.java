package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.coco.dao.CommonPopupInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("commonPopupService")
public class CommonPopupServiceImpl implements CommonPopupService {

	@Autowired
	private CommonPopupInfoDao commonPopupInfoDao; 
	
	@Autowired
	private CommonInfoDao commonInfoDao; 
	
	public List<Map<String,String>> getSidoCodeList(){
		return commonPopupInfoDao.getSidoCodeList();
	}
	public List<Map<String,String>> getSigunguCodeList(Map<String,String>  pMap){
		return commonPopupInfoDao.getSigunguCodeList(pMap);
	}
	
	public List<Map<String,String>> zipCodeSearch(Map<String,String>  pMap){
		return commonPopupInfoDao.zipCodeSearch(pMap);
	}
	public List<Map<String,String>> commonList(Map<String,String>  pMap){
		return commonPopupInfoDao.commonList(pMap);
	}
	public List<Map<String,String>> commonList_v2(Map<String,Object>  pMap){
		return commonPopupInfoDao.commonList_v2(pMap);
	}
	
	public Map<String,String> getCmpyInfoPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getCmpyInfoPop(pMap);
	}
	public List<Map<String,String>> getAgentInfoDiaplayPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getAgentInfoDiaplayPop(pMap);
	}
	public List<Map<String,String>> getAgentInfoExDiaplayPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getAgentInfoExDiaplayPop(pMap);
	}
	public List<Map<String,String>> getUserInfoDiaplayPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getUserInfoDiaplayPop(pMap);
	}
	public List<Map<String,String>> getUserInfoDiaplayListPopCase1(Map<String,String>  pMap){
		return commonPopupInfoDao.getUserInfoDiaplayListPopCase1(pMap);
	}
	public List<Map<String,String>> getUserInfoDiaplayListPopCase2(Map<String,String>  pMap){
		return commonPopupInfoDao.getUserInfoDiaplayListPopCase2(pMap);
	}
	public List<Map<String, String>> getUserInfoDiaplayListPopCase3(Map<String, String> pMap) {
		return commonPopupInfoDao.getUserInfoDiaplayListPopCase3(pMap);
	}
	public List<Map<String,String>> commonIcomcod1List(Map<String,String>  pMap){
		return commonPopupInfoDao.commonIcomcod1List(pMap);
	}
	public List<Map<String,String>> getIcomcod1WhereList(Map<String,String>  pMap){
		return commonPopupInfoDao.getIcomcod1WhereList(pMap);
	}
	public List<Map<String,String>> getIcomcod2List(Map<String,String>  pMap){
		return commonPopupInfoDao.getIcomcod2List(pMap);
	}
	public List<Map<String,String>> getIcomcod2List_v2(Map<String,Object>  pMap){
		return commonPopupInfoDao.getIcomcod2List_v2(pMap);
	}
	public List<Map<String,String>> icomcdpopList(Map<String,String>  pMap){
		return commonPopupInfoDao.icomcdpopList(pMap);
	}
	public Map<String,String> kepManagerPop(Map<String,String>  pMap){
		return commonPopupInfoDao.kepManagerPop(pMap);
	}
	
	public List<Map<String,String>> getInvoiceDisplayPop1(Map<String,String>  pMap){
		
		List<Map<String, String>> data = commonPopupInfoDao.getInvoiceDisplayPop1(pMap);
		
		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(data).get(0);
		
        String rpt_url = "";

        String inv_no = pMap.get("INV_NO").toString();
        
		if(inv_no.substring(0,2).equals("IV")){
			
			map.put("USER_ID", pMap.get("USER_ID"));
	    	map.put("BUYER", pMap.get("BUYER"));
	    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
//	    	map.put("PO_NO", CommonUtil.nvl(map.get("PO_NO")));

			// 특수로직데이터를 이용해서 레포트 url 조회
			rpt_url = commonInfoDao.selectRptUrl(map);
		}		
    	
		map.put("RPT_URL", rpt_url);
		data.set(0, map);
        
		return data;
	}
	
	public List<Map<String,String>> getInvoiceDisplayPop2(Map<String,String>  pMap){
		return commonPopupInfoDao.getInvoiceDisplayPop2(pMap);
	}

	public List<Map<String,String>> commonCoCoDepartmentDetailViewPop(Map<String,String>  pMap){
		return commonPopupInfoDao.commonCoCoDepartmentDetailViewPop(pMap);
	}
	public List<Map<String,String>> commonCoCoAccountItemPop(){
		return commonPopupInfoDao.commonCoCoAccountItemPop();
	}
	public List<Map<String,String>> commonCoCoNationCodePop(Map<String,String>  pMap){
		return commonPopupInfoDao.commonCoCoNationCodePop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoBuyerBusnstypeClassifyPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getCommonCoCoBuyerBusnstypeClassifyPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoGoodsDlvyClssifyPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getCommonCoCoGoodsDlvyClssifyPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoTranGoodsPop(){
		return commonPopupInfoDao.getCommonCoCoTranGoodsPop();
	}
	public List<Map<String,String>> getCommonCoCoLogisticCenterCatalogPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getCommonCoCoLogisticCenterCatalogPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getCommonCoCoOrderDepartmentSearchPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop_v2(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoOrderDepartmentSearchPop_v2(pMap);
	}
	public List<Map<String,String>> getCommonCoCoCompanyPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoCompanyPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoUserChoice2Pop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoUserChoice2Pop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodePop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoBudgetDepartmentCodePop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodeDiffPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoBudgetDepartmentCodeDiffPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoTeamClassifyPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoTeamClassifyPop(pMap);
	}
	public List<Map<String,String>> getCommonCoCoExistingCatalogPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoExistingCatalogPop(pMap);
	}
	public List<Map<String,String>> getMasterMpSoAgntcmpyTypePop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getMasterMpSoAgntcmpyTypePop(pMap);
	}
	public List<Map<String,String>> getMasterMpSoWmsSearchPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getMasterMpSoWmsSearchPop(pMap);
	}
	public String getDeptCodeAdminCowayYn(Map<String,String>  pMap){
		return commonPopupInfoDao.getDeptCodeAdminCowayYn(pMap);
	}
	public Map<String,String> getSysopCatalogBuyerInfo(Map<String,Object>  pMap){
		return commonPopupInfoDao.getSysopCatalogBuyerInfo(pMap);
	}
	
	/**
	 * 관리고객사지정
	 */
	public List<Map<String,String>> getAdminSafetyCompanyCodeLeftList(Map<String,String>  pMap) {
		return commonPopupInfoDao.getAdminSafetyCompanyCodeLeftList(pMap);
	}
	public List<Map<String,String>> getAdminSafetyCompanyCodeRightList(Map<String,String>  pMap) {
		return commonPopupInfoDao.getAdminSafetyCompanyCodeRightList(pMap);
	}
	public String saveAdminSafetyCompanyCode(Map<String,String>  pMap) {
		return commonPopupInfoDao.saveAdminSafetyCompanyCode(pMap);
	}
	
	public String getCheckedPoAgentList(Map<String,Object>  pMap) {
		return commonPopupInfoDao.getCheckedPoAgentList(pMap);
	}
	
	public String getCheckedPoAgentDeptList(Map<String,Object>  pMap) {
		return commonPopupInfoDao.getCheckedPoAgentDeptList(pMap);
	}
	@Override
	public List<Map<String,String>> getZcodeList(Map<String, String> pMap) {
		return commonPopupInfoDao.getZcodeList(pMap);
	}
	
	// k tag 업데이트
	public String updateKtagList(Map<String,String>  pMap){
		return commonPopupInfoDao.updateKtagList(pMap);
	}
	
	// 납품가능지역
	public List<Map<String,String>> getDeliAreaList(Map<String,String>  pMap){
		return commonPopupInfoDao.getDeliAreaList(pMap);
	}
	
	// 예산부서 팝업
	public List<Map<String,String>> getCommonCoCoBudgetDeptPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoBudgetDeptPop(pMap);
	}
	
	// 계정 팝업
	public List<Map<String,String>> getCommonCoCoAccountPop(Map<String,Object>  pMap){
		return commonPopupInfoDao.getCommonCoCoAccountPop(pMap);
	}
	
	// 물류비 책정 사유
	public List<Map<String,String>> getLogisFeeReasonPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getLogisFeeReasonPop(pMap);
	}
	//예산부서별 주문금액
	public List<Map<String,String>> getBudegtOrderAmtPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getBudegtOrderAmtPop(pMap);
	}
	// 고객사 메일수신지정
	public List<Map<String,String>> getUserMailRecvChoicePop(Map<String,String>  pMap){
		return commonPopupInfoDao.getUserMailRecvChoicePop(pMap);
	}
	// 고객사 견적 입찰상세내역
	public List<Map<String,String>> getNsAgentInfoPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getNsAgentInfoPop(pMap);
	}
	// 고객사 견적상세팝업_제출상세
	public List<Map<String,String>> getQuotDetailInfoPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getQuotDetailInfoPop(pMap);
	}
	// 고객사 견적상세팝업_상품정보
	public Map<String,String> getQuotDetailInfoPop2(Map<String,String>  pMap){
		return commonPopupInfoDao.getQuotDetailInfoPop2(pMap);
	}
	// 고객사 납품가능지역 팝업
	public List<Map<String,String>> getBuyerDelyAreaInfoPop(Map<String,String>  pMap){
		return commonPopupInfoDao.getBuyerDelyAreaInfoPop(pMap);
	}
	// 고객사 네고이력팝업
	public List<Map<String,String>> getNegoLogInfo(Map<String,String>  pMap){
		return commonPopupInfoDao.getNegoLogInfo(pMap);
	}
	// 개인정보처리방침 협력사리스트
	public List<Map<String,String>> getPrivacySeller(Map<String,String>  pMap){
		return commonPopupInfoDao.getPrivacySeller(pMap);
	}
	// 도착지정보 리스트
	public List<Map<String,String>> commonDlyLocationList(Map<String,Object>  pMap){
		return commonPopupInfoDao.commonDlyLocationList(pMap);
	}
	// 회원가입 회원사 검색 리스트
	public List<Map<String,String>> getComCodeList(Map<String,String>  pMap){
		return commonPopupInfoDao.getComCodeList(pMap);
	}
	// BQMS 배송조회 팝업 링크
	public List<Map<String,String>> getBqmsInvoiceSearch(Map<String,String>  pMap){
		return commonPopupInfoDao.getBqmsInvoiceSearch(pMap);
	}
	//회원 조회 리스트
	public List<Map<String,String>> getUserList(Map<String,String>  pMap){
		return commonPopupInfoDao.getUserList(pMap);
	}
	public List<Map<String,String>> getUserList_v2(Map<String,Object>  pMap){
		return commonPopupInfoDao.getUserList_v2(pMap);
	}
	//doc_no 로 파일 리스트 가져오기
	public List<Map<String,String>> getFileList_v2(Map<String,String>  pMap){
		return commonPopupInfoDao.getFileList_v2(pMap);
	}
	// 고객사 견적상세팝업_v2
	public Map<String,String> getQuotDetailInfoPop_v2(Map<String,String>  pMap){
		return commonPopupInfoDao.getQuotDetailInfoPop_v2(pMap);
	}
	// 고객사 견적상세팝업삼양사_v2
	public Map<String,String> getQuotDetailInfoPopSYS_v2(Map<String,String>  pMap){
		return commonPopupInfoDao.getQuotDetailInfoPopSYS_v2(pMap);
	}
	
	// 고객사 견적상세팝업_v2 - 전체품목 상품정보
	public List<Map<String, String>> getQuotDetailAllPop_v2(Map<String, Object> pMap) {
		return commonPopupInfoDao.getQuotDetailAllPop_v2(pMap);
	}
	
	// 고객사 담당자찾기_v2
	
	public List<Map<String,String>> getCompanyInfo_v2(Map<String,String>  pMap){
		return commonPopupInfoDao.getCompanyInfo_v2(pMap);
	}
	public List<Map<String,String>> getKepManager_v2(Map<String,String>  pMap){
		return commonPopupInfoDao.getKepManager_v2(pMap);
	}
	
}
