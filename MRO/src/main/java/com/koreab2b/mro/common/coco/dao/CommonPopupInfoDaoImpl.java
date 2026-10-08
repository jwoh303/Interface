package com.koreab2b.mro.common.coco.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.koreab2b.mro.util.CommonUtil;

@Repository("commonPopupDao")
public class CommonPopupInfoDaoImpl implements CommonPopupInfoDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
	
	public List<Map<String,String>> getSidoCodeList(){
		return sqlSessionTemplate.selectList("commonPopup.getSidoCodeList", null);
	}
	public List<Map<String,String>> getSigunguCodeList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getSigunguCodeList", pMap);
	}
	
	public List<Map<String,String>> zipCodeSearch(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.zipCodeSearch", pMap);
	}
	public List<Map<String,String>> commonList(Map<String,String>  pMap){
		

		if(pMap.get("codeGubun").equals("misUserSelectAllPop2")||pMap.get("codeGubun").equals("userDisplayPop")){
			String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("commonPopup."+pMap.get("codeGubun")).getBoundSql(pMap).getSql();
			String attr_01 = "";
			for(Map.Entry<String, String>entry: pMap.entrySet()){
				attr_01 += entry.getKey() + "="+entry.getValue() + "/";
			}
			Map<String, String> data = new HashMap<String, String>();
			data.putAll(pMap);
			data.put("SYSTEM", "KOREAB2B");
			if(pMap.get("codeGubun").equals("misUserSelectAllPop2")){
				data.put("MENU", "회원사관리(팝업)");
				data.put("LOG_TYPE", "조회");				
			}else if(pMap.get("codeGubun").equals("userDisplayPop")){
				data.put("MENU", "사용자상세조회(팝업)");
				data.put("LOG_TYPE", "조회");				
			}
			data.put("ATTR_01", strSql+"/"+attr_01);
			// 조회 시 사용된 사용자 아이디 및 이름
			data.put("ATTR_02", CommonUtil.nvl3(pMap.get("user_id"), "") + " / " + CommonUtil.nvl3(pMap.get("user_name_loc"), ""));
			// 조회 시 사용된 회원사명
			data.put("ATTR_03", CommonUtil.nvl3(pMap.get("com_name"), ""));
			sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		}
		// 화면에서 보낸값에 의한 쿼리 실행
		pMap.put("group_mng_flag", CommonUtil.nvl(pMap.get("group_mng_flag"), "N"));
		return sqlSessionTemplate.selectList("commonPopup."+pMap.get("codeGubun"), pMap);
	}
	public List<Map<String,String>> commonList_v2(Map<String,Object>  pMap){
		

		if(pMap.get("codeGubun").equals("misUserSelectAllPop2")||pMap.get("codeGubun").equals("userDisplayPop")){
			String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("commonPopup."+pMap.get("codeGubun")).getBoundSql(pMap).getSql();
			String attr_01 = "";
			for(Map.Entry<String, Object>entry: pMap.entrySet()){
				attr_01 += entry.getKey() + "="+entry.getValue() + "/";
			}
			Map<String, Object> data = new HashMap<String, Object>();
			data.putAll(pMap);
			data.put("SYSTEM", "KOREAB2B");
			if(pMap.get("codeGubun").equals("misUserSelectAllPop2")){
				data.put("MENU", "회원사관리(팝업)");
				data.put("LOG_TYPE", "조회");				
			}else if(pMap.get("codeGubun").equals("userDisplayPop")){
				data.put("MENU", "사용자상세조회(팝업)");
				data.put("LOG_TYPE", "조회");				
			}
			data.put("ATTR_01", strSql+"/"+attr_01);
			// 조회 시 사용된 사용자 아이디 및 이름
			data.put("ATTR_02", CommonUtil.nvl3((String)pMap.get("user_id"), "") + " / " + CommonUtil.nvl3((String)pMap.get("user_name_loc"), ""));
			// 조회 시 사용된 회원사명
			data.put("ATTR_03", CommonUtil.nvl3((String)pMap.get("com_name"), ""));
			sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		}
		// 화면에서 보낸값에 의한 쿼리 실행
		pMap.put("group_mng_flag", CommonUtil.nvl((String)pMap.get("group_mng_flag"), "N"));
		return sqlSessionTemplate.selectList("commonPopup."+pMap.get("codeGubun"), pMap);
	}
	
	
	public Map<String,String> getCmpyInfoPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopup.getAgentInfoDiaplayPop", pMap);
	}
	public List<Map<String,String>> getAgentInfoDiaplayPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getAgentInfoDiaplayPop", pMap);
	}
	public List<Map<String,String>> getAgentInfoExDiaplayPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getAgentInfoExDiaplayPop", pMap);
	}
	public List<Map<String,String>> getUserInfoDiaplayPop(Map<String,String>  pMap){
		List<Map<String,String>> list = null;
		
		String com_code = pMap.get("st_com_code").toString();
		
		if("KRKORE0001".equals(com_code)) {
			list = sqlSessionTemplate.selectList("commonPopup.getUserRspnInfoDiaplayPop", pMap);
		}else{
			list = sqlSessionTemplate.selectList("commonPopup.getUserInfoDiaplayPop", pMap);
		}		
		
		return list;
	} 
	public List<Map<String,String>> getUserInfoDiaplayListPopCase1(Map<String,String>  pMap){
		//로그기록
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("commonPopup.getUserInfoDiaplayListPopCase1").getBoundSql(pMap).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: pMap.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(pMap);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "회원사정보(팝업)");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		
		return sqlSessionTemplate.selectList("commonPopup.getUserInfoDiaplayListPopCase1", pMap);
	} 
	public List<Map<String,String>> getUserInfoDiaplayListPopCase2(Map<String,String>  pMap){
		//로그기록
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("commonPopup.getUserInfoDiaplayListPopCase2").getBoundSql(pMap).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: pMap.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(pMap);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "회원사정보(팝업)");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				
		return sqlSessionTemplate.selectList("commonPopup.getUserInfoDiaplayListPopCase2", pMap);
	} 
	public List<Map<String,String>> getUserInfoDiaplayListPopCase3(Map<String,String>  pMap){
		//로그기록
		/*
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("commonPopup.getUserInfoDiaplayListPopCase3").getBoundSql(pMap).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: pMap.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(pMap);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "회원사정보(팝업)");
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		*/
				
		return sqlSessionTemplate.selectList("commonPopup.getUserInfoDiaplayListPopCase3", pMap);
	} 
	
	public List<Map<String,String>> commonIcomcod1List(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.commonIcomcod1List", pMap);
	}
	public List<Map<String,String>> getIcomcod1WhereList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getIcomcod1WhereList", pMap);
	}
	public List<Map<String,String>> getIcomcod2List(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getIcomcod2List", pMap);
	}
	public List<Map<String,String>> getIcomcod2List_v2(Map<String,Object>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getIcomcod2List", pMap);
	}
	
	public List<Map<String,String>> icomcdpopList(Map<String,String>  pMap) {
		String queryId = "";
		String tableNm = pMap.get("tableNm"); 
		queryId = "get"+tableNm+"List" ;
		return sqlSessionTemplate.selectList("commonPopup."+queryId, pMap);
	}
	public Map<String,String> kepManagerPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopup.kepManagerPop", pMap);
	} 
	
	public List<Map<String,String>> getInvoiceDisplayPop1(Map<String,String>  pMap){
		
		String queryId = "";
		String inv_no = pMap.get("INV_NO").toString();
		if(inv_no.substring(0,2).equals("IV")){
			queryId = "getInvoiceDisplayPop1_1";
		}else{
			queryId = "getInvoiceDisplayPop1_2";
		}
		
		return sqlSessionTemplate.selectList("commonPopup."+queryId, pMap);
	}
	public List<Map<String,String>> getInvoiceDisplayPop2(Map<String,String>  pMap){
		
		String queryId = "";
		String inv_no = pMap.get("INV_NO").toString();
		if(inv_no.substring(0,2).equals("IV")){
			queryId = "getInvoiceDisplayPop2_1";
		}else{
			queryId = "getInvoiceDisplayPop2_2";
		}
		
		
		return sqlSessionTemplate.selectList("commonPopup."+queryId, pMap);
	}
	
	public List<Map<String,String>> commonCoCoDepartmentDetailViewPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoDepartmentDetailViewPop", pMap);
	}
	public List<Map<String,String>> commonCoCoAccountItemPop(){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoAccountItemPop");
	}
	public List<Map<String,String>> commonCoCoNationCodePop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoNationCodePop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoBuyerBusnstypeClassifyPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoBuyerBusnstypeClassifyPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoGoodsDlvyClssifyPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getCommonCoCoGoodsDlvyClssifyPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoTranGoodsPop(){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoTranGoodsPop");
	}
	public List<Map<String,String>> getCommonCoCoLogisticCenterCatalogPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoLogisticCenterCatalogPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoOrderDepartmentSearchPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoOrderDepartmentSearchPop_v2(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoOrderDepartmentSearchPop", pMap);
	}
	
	public List<Map<String,String>> getCommonCoCoCompanyPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoCompanyPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoUserChoice2Pop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoUserChoice2Pop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodePop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoBudgetDepartmentCodePop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoBudgetDepartmentCodeDiffPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoBudgetDepartmentCodeDiffPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoTeamClassifyPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoTeamClassifyPop", pMap);
	}
	public List<Map<String,String>> getCommonCoCoExistingCatalogPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoExistingCatalogPop", pMap);
	}
	public List<Map<String,String>> getMasterMpSoAgntcmpyTypePop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.masterMpSoAgntcmpyTypePop", pMap);
	}
	public List<Map<String,String>> getMasterMpSoWmsSearchPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.masterMpSoWmsSearchPop", pMap);
	}
	public String getDeptCodeAdminCowayYn(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("commonPopup.selectDeptCodeAdminCowayYn", pMap);
	}
	public Map<String,String> getSysopCatalogBuyerInfo(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectOne("commonPopup.getSysopCatalogBuyerInfo", pMap);
	}
	
	
	/**
	 * 관리고객사지정
	 */
	public List<Map<String,String>> getAdminSafetyCompanyCodeLeftList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getAdminSafetyCompanyCodeLeftList", pMap);
	}
	public List<Map<String,String>> getAdminSafetyCompanyCodeRightList(Map<String,String>  pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getAdminSafetyCompanyCodeRightList", pMap);
	}
	public String saveAdminSafetyCompanyCode(Map<String,String>  pMap) {
		
		String crud = pMap.get("crud");
		String query = pMap.get("query");
		String queryArray[] = query.split("@@");
		for (int i=0; i<queryArray.length; i++){
			
			pMap.put("BUYER", queryArray[i]);
			if ("C".equals(crud)){
				sqlSessionTemplate.selectOne("commonPopup.insertAdminSafetyCompanyCode", pMap);
			}else{
				sqlSessionTemplate.selectOne("commonPopup.deleteAdminSafetyCompanyCode", pMap);
			}
		}
		
		return "UPDATE_OK";
	}
	
	public String getCheckedPoAgentList(Map<String,Object>  pMap) {
		pMap.put("arry_buyer_list", CommonUtil.StrToArray(CommonUtil.nvl((String) pMap.get("st_buyer_list"), ""), ","));
		return sqlSessionTemplate.selectOne("commonPopup.selectCheckedPoAgentList", pMap);
	}

	public String getCheckedPoAgentDeptList(Map<String,Object>  pMap) {
		return sqlSessionTemplate.selectOne("commonPopup.selectCheckedPoAgentDeptList", pMap);
	}
	
	public List<Map<String,String>> getZcodeList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("commonPopup.getZcodeList", pMap);
	}
	// K tag 출력시 프린트
	public String updateKtagList(Map<String,String>  pMap){
		String _rtnMsg = "";
		
		try{
			
			sqlSessionTemplate.update("commonPopup.updateKtagList", pMap);
			
		}catch(Exception e){
			throw new RuntimeException(" K TAG 프린트여부 업데이트가 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;	
	}
	
	// 납품가능지역
	public List<Map<String,String>> getDeliAreaList(Map<String,String>  pMap){
		List<Map<String,String>> list = null;
		
		list = sqlSessionTemplate.selectList("commonPopup.commonDeliAreaList", pMap);
		
		// 조회값 없을 시 기본값으로 조회
		if(list.size() == 0){
			pMap.put("st_com_code", "KRKORE0001");
			list = sqlSessionTemplate.selectList("commonPopup.commonDeliAreaList", pMap);
		}
		
		return list; 
	}
	
	// 예산부서 팝업
	public List<Map<String,String>> getCommonCoCoBudgetDeptPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoBudgetDeptPop", pMap);
	}
	
	// 계정 팝업
	public List<Map<String,String>> getCommonCoCoAccountPop(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonCoCoAccountPop", pMap);
	}
	
	// 물류비 책정 사유
	public List<Map<String,String>> getLogisFeeReasonPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getLogisFeeReasonPop", pMap);
	}
	//예산부서별 주문금액
	public List<Map<String,String>> getBudegtOrderAmtPop(Map<String,String>  pMap){
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(pMap);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) pMap.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}
		return sqlSessionTemplate.selectList("commonPopup.getBudegtOrderAmtPop", data);
	}
	// 고객사 메일수신지정
	public List<Map<String,String>> getUserMailRecvChoicePop(Map<String,String>  pMap){
		List<Map<String,String>> list = null;
		list = sqlSessionTemplate.selectList("commonPopup.getUserMailRecvChoicePop", pMap);
		return list; 
	}
	// 고객사 견적 입찰상세내역
	public List<Map<String,String>> getNsAgentInfoPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonNsAgentInfoPop", pMap);
	}
	// 고객사 견적상세팝업
	public List<Map<String,String>> getQuotDetailInfoPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonQuotDetailInfoPop", pMap);
	}
	// 고객사 납품가능지역 팝업
	public List<Map<String,String>> getBuyerDelyAreaInfoPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonBuyerDelyAreaInfoPop", pMap);
	}
	// 고객사 네고이력팝업
	public List<Map<String,String>> getNegoLogInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonNegoLogInfoPop", pMap);
	}
	// 개인정보처리방침 협력사리스트
	public List<Map<String,String>> getPrivacySeller(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonPrivacySeller", pMap);
	}
	// 도착지정보 리스트
	public List<Map<String,String>> commonDlyLocationList(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.commonDlyLocationList", pMap);
	}
	// 회원가입 회원사 검색 리스트
	public List<Map<String,String>> getComCodeList(Map<String,String>  pMap){
		pMap.put("h_irs_no", pMap.get("h_irs_no1")+"-"+pMap.get("h_irs_no2")+"-"+pMap.get("h_irs_no3"));
		return sqlSessionTemplate.selectList("commonPopup.getComCodeList", pMap);
	}
	// BQMS 배송조회 팝업 링크
	public List<Map<String,String>> getBqmsInvoiceSearch(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getBqmsInvoiceSearch", pMap);
	}
	// 회원 조회 리스트
	public List<Map<String,String>> getUserList(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getUserList", pMap);
	}
	public List<Map<String,String>> getUserList_v2(Map<String,Object>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getUserList", pMap);
	}
	//doc_no 로 파일 리스트 가져오기
	public List<Map<String,String>> getFileList_v2(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("commonPopup.getFileList_v2", pMap);
	}
	// 고객사 견적상세팝업_v2
	public Map<String, String> getQuotDetailInfoPop_v2(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("commonPopup.buyerQuotDetailInfoPop_v2", pMap);
	}
	// 고객사 견적상세팝업삼양사_v2
	public Map<String, String> getQuotDetailInfoPopSYS_v2(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("commonPopup.buyerQuotDetailInfoPopSYS_v2", pMap);
	}
	// 고객사 견적상세팝업_v2 - 전체품목 상품정보
	public List<Map<String, String>> getQuotDetailAllPop_v2(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("commonPopup.buyerQuotDetailAllPop_v2", pMap);
	}

	
	// 고객사 견적 단가 상세 팝업 _v2 - 상품정보
	public Map<String, String> getQuotDetailInfoPop2(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("commonPopup.commonQuotDetailInfoPop2", pMap);
	}
	
	// 고객사 담당자 찾기_v2
	public List<Map<String, String>> getCompanyInfo_v2(Map<String, String> pMap) {
		pMap.put("h_irs_no", pMap.get("h_irs_no1")+"-"+pMap.get("h_irs_no2")+"-"+pMap.get("h_irs_no3"));
		return sqlSessionTemplate.selectList("commonPopup.getCompanyInfo_v2", pMap);
	}
	public List<Map<String, String>> getKepManager_v2(Map<String, String> pMap) {
		if(pMap.get("business_cond").equals("B")) {
			return sqlSessionTemplate.selectList("commonPopup.getKepManagerB_v2", pMap);
		}else{
			return sqlSessionTemplate.selectList("commonPopup.getKepManagerS_v2", pMap);
		}
	}
}
