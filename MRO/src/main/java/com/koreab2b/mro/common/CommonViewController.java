package com.koreab2b.mro.common;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogAlterService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("commonViewController")
public class CommonViewController {
	
	@Autowired
	MasterMdCmCatalogAlterService masterMdCmCatalogAlterService;

	@RequestMapping(value = "/common/sample.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sample() {
		return "sample/popup";
	}

	@RequestMapping(value = "/common/reasonPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String reasonPop() {
		return "common/popup/reasonPop";
	}

	@RequestMapping(value = "/common/countryCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String countryCodePop() {
		return "common/popup/countryCodePop";
	}

	@RequestMapping(value = "/common/roleCodeSearchPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String roleCodeSearchPop() {
		return "common/popup/roleCodeSearchPop";
	}

	@RequestMapping(value = "/common/deptCodeAdminPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String deptCodeAdminPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/deptCodeAdminPop_v2";
		} else {
			return "common/popup/deptCodeAdminPop";
		}
	}
	@RequestMapping(value = "/common/deptCodeAdminPCOPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String deptCodeAdminPCOPop() {
		return "common/popup/deptCodeAdminPCOPop";
	}	
	@RequestMapping(value = "/common/deptCodeAdminBuyerPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String deptCodeAdminBuyerPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/deptCodeAdminBuyerPop_v2";
		}else{
			return "common/popup/deptCodeAdminBuyerPop";
		}
	}

	@RequestMapping(value = "/common/agentRegMakerCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String agentRegMakerCodePop() {
		return "common/popup/agentRegMakerCodePop";
	}

	@RequestMapping(value = "/common/agentInfoDisplayPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String agentInfoDisplayPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/agentInfoDisplayPop_v2";
		} else {
			return "common/popup/agentInfoDisplayPop";
		}
		
		
	}

	@RequestMapping(value = "/common/misUserSelectAllPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String misUserSelectAllPop() {
		return "common/popup/misUserSelectAllPop";
	}
	@RequestMapping(value = "/common/misUserSelectDeptPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String misUserSelectDeptPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/misUserSelectDeptPop_v2";
		}else{
			return "common/popup/misUserSelectDeptPop";
		}
	}
	@RequestMapping(value = "/common/misUserSelectAllPop2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String misUserSelectAllPop2(HttpServletRequest request) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String businessCond = _sessionInfo.getBusinessCond();
		String sslurl		= CommonUtil.getSslURL(request, "http");
		//운영사만 화면 호출되도록 처리.
		if(businessCond.equals("M")){
			return "common/popup/misUserSelectAllPop2";	
		}else{
			return "redirect:"+sslurl+"/main.do";
		}
	}

	@RequestMapping(value = "/common/safetyCompanyCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String safetyCompanyCodePop() {
		return "common/popup/safetyCompanyCodePop";
	}

	@RequestMapping(value = "/common/companyCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String companyCodePop() {
		return "common/popup/companyCodePop";
	}

	@RequestMapping(value = "/common/processTypePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String processTypePop() {
		return "common/popup/processTypePop";
	}

	@RequestMapping(value = "/common/standardcatalogidPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String standardcatalogidPop() {
		return "common/popup/standardcatalogidPop";
	}

	@RequestMapping(value = "/common/calendarAndHourPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String calendarAndHourPop() {
		return "common/popup/calendarAndHourPop";
	}
	
	@RequestMapping(value = "/common/preGrCalendarPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String preGrCalendarPop() {
		return "common/popup/preGrCalendarPop";
	}

	@RequestMapping(value = "/common/positionCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String positionCodePop() {
		return "common/popup/positionCodePop";
	}

	@RequestMapping(value = "/common/delLocationPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String delLocationPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/delLocationPop_v2";
		} else {
			return "common/popup/delLocationPop";
		}
	}
	@RequestMapping(value = "/common/delLocationTwoTabPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String delLocationTwoTabPop_v2(HttpServletRequest request) {
		return "common/popup/delLocationTwoTabPop_v2";
	}

	@RequestMapping(value = "/common/comCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String comCodePop() {
		return "common/popup/comCodePop";
	}

	@RequestMapping(value = "/common/cityCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String cityCodePop() {
		return "common/popup/cityCodePop";
	}

	@RequestMapping(value = "/common/bankCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String bankCodePop() {
		return "common/popup/bankCodePop";
	}

	@RequestMapping(value = "/common/unitMeasurePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String unitMeasurePop() {
		return "common/popup/unitMeasurePop";
	}

	@RequestMapping(value = "/common/currencyCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String currencyCodePop() {
		return "common/popup/currencyCodePop";
	}

	@RequestMapping(value = "/common/accTypeCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String accTypeCodePop() {
		return "common/popup/accTypeCodePop";
	}

	@RequestMapping(value = "/common/userDisplayPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String userDisplayPop() {
		return "common/popup/userDisplayPop";
	}

	@RequestMapping(value = "/common/getlocationSearchPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getlocationSearchPop() {
		return "common/popup/getlocationSearchPop";
	}

	@RequestMapping(value = "/common/deptUserPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String deptUserPop() {
		return "common/popup/deptUserPop";
	}

	@RequestMapping(value = "/common/icomcdPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String icomcdPop() {
		return "common/popup/icomcdPop";
	}

	@RequestMapping(value = "/common/belowComorgPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String belowComorgPop() {
		return "common/popup/belowComorgPop";
	}

	@RequestMapping(value = "/common/fileUploadPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String fileUploadPop() {
		return "common/popup/fileUploadPop";
	}
	@RequestMapping(value = "/common/fileUploadPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String fileUploadPop_v2() {
		return "common/popup/fileUploadPop_v2";
	}
	@RequestMapping(value = "/common/imageUploadPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String imageUploadPop_v2() {
		return "common/popup/imageUploadPop_v2";
	}

	@RequestMapping(value = "/common/calendarPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String calendarPop() {
		return "common/popup/calendarPop";
	}

	@RequestMapping(value = "/common/multiSamplePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String multiSamplePop() {
		return "common/popup/multiSamplePop";
	}

	@RequestMapping(value = "/common/excelUploadPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String excelUploadPop() {
		return "common/popup/excelUploadPop";
	}

	@RequestMapping(value = "/common/remarkPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkPop() {
		return "common/popup/remarkPop";
	}
	
	@RequestMapping(value = "/common/confirmRemarkPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String confirmRemarkPop() {
		return "common/popup/confirmRemarkPop";
	}	

	@RequestMapping(value = "/common/remarkBtoAPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkBtoAPop() {
		return "common/popup/remarkBtoAPop";
	}

	@RequestMapping(value = "/common/remarkBtoA2Pop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkBtoA2Pop() {
		return "common/popup/remarkBtoA2Pop";
	}

	@RequestMapping(value = "/common/remarkAtoSPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkAtoSPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/remarkAtoSPop_v2";
		} else {
			return "common/popup/remarkAtoSPop";
		}
		
	} /* 비고팝업(A-S) */

	@RequestMapping(value = "/common/remarkStoAPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkStoAPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/remarkStoAPop_v2";
		} else {
			return "common/popup/remarkStoAPop";
		}
	} /* 비고팝업(A-S) */

	@RequestMapping(value = "/common/remarkAtoS2Pop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkAtoS2Pop() {
		return "common/popup/remarkAtoS2Pop";
	} /* 비고팝업(A-S) */

	@RequestMapping(value = "/common/remarkBASPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkBASPop() {
		return "common/popup/remarkBASPop";
	} /* 비고팝업(B-A-S) */

	@RequestMapping(value = "/common/remarkCancelPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkCancelPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/remarkCancelPop_v2";
		} else {
			return "common/popup/remarkCancelPop";
		}
	}

	@RequestMapping(value = "/common/remarkHistoryPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkHistoryPop() {
		return "common/popup/remarkHistoryPop";
	}

	@RequestMapping(value = "/common/viewDbOffPoHistoryPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String viewDbOffPoHistoryPop() {
		return "common/popup/viewDbOffPoHistoryPop";
	}

	@RequestMapping(value = "/common/remarkReturnPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkReturnPop() {
		return "common/popup/remarkReturnPop";
	}

	@RequestMapping(value = "/common/remarkReturn2Pop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkReturn2Pop() {
		return "common/popup/remarkReturn2Pop";
	}

	@RequestMapping(value = "/common/remarkReqChangePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkReqChangePop() {
		return "common/popup/remarkReqChangePop";
	}

	@RequestMapping(value = "/common/viewPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String viewPop() {
		return "common/popup/viewPop";
	}

	@RequestMapping(value = "/common/tableinfoPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String tableinfoPop() {
		return "common/popup/tableinfoPop";
	}

	@RequestMapping(value = "/common/icomcmpyPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String icomcmpyPop() {
		return "common/popup/icomcmpyPop";
	}

	@RequestMapping(value = "/common/icomcmpyTempPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String icomcmpyTempPop() {
		return "common/popup/icomcmpyTempPop";
	}

	@RequestMapping(value = "/common/catalogDetailPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String catalogDetailPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/catalogDetailPop_v2";
		} else {
			return "common/popup/catalogDetailPop";
		}
		
		
	}

	@RequestMapping(value = "/common/deptPOInfoPunchOutDetailPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String deptPOInfoPunchOutDetailPop() {
		return "common/popup/deptPOInfoPunchOutDetailPop";
	}

	@RequestMapping(value = "/common/categoryPunchOutDetailPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String categoryPunchOutDetailPop() {
		return "common/popup/categoryPunchOutDetailPop";
	}

	@RequestMapping(value = "/common/buyerSourcingItemGubunPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerSourcingItemGubunPop() {
		return "common/popup/buyerSourcingItemGubunPop";
	}

	@RequestMapping(value = "/common/buyerSourcingItemPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerSourcingItemPop() {
		return "common/popup/buyerSourcingItemPop";
	}

	@RequestMapping(value = "/common/buyerSourcingStdDescPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerSourcingStdDescPop() {
		return "common/popup/buyerSourcingStdDescPop";
	}

	@RequestMapping(value = "/common/buyerSourcingCtgNmPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerSourcingCtgNmPop() {
		return "common/popup/buyerSourcingCtgNmPop";
	}

	@RequestMapping(value = "/common/buyerSourcingCtgIdPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerSourcingCtgIdPop() {
		return "common/popup/buyerSourcingCtgIdPop";
	}

	@RequestMapping(value = "/common/catalogDetailDongbuPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String catalogDetailDongbuPop() {
		return "common/popup/catalogDetailDongbuPop";
	}

	/**
	 * 전체공통
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/viewPop2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String viewPop2() {
		return "common/popup/viewPop2";
	}

	/**
	 * Item Display
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoItemDisplayPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoItemDisplayPop() {
		return "common/coco/commonCoCoItemDisplayPop";
	}

	/**
	 * SCM조치내역
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoScmActionDetailPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoScmActionDetailPop() {
		return "common/coco/commonCoCoScmActionDetailPop";
	}

	/**
	 * 계정항목
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoAccountItemPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoAccountItemPop() {
		return "common/coco/commonCoCoAccountItemPop";
	}

	/**
	 * 고객사 카탈로그 상세조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBuyerCatalogDetailPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBuyerCatalogDetailPop() {
		return "common/coco/commonCoCoBuyerCatalogDetailPop";
	}

	/**
	 * 고객사 카테고리 선택
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBuyerCategoryChoicePop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBuyerCategoryChoicePop() {
		return "common/coco/commonCoCoBuyerCategoryChoicePop";
	}

	/**
	 * 국가코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoNationCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoNationCodePop() {
		return "common/coco/commonCoCoNationCodePop";
	}

	/**
	 * 기간선택
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoTermChoicePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoTermChoicePop() {
		return "common/popup/coco/commonCoCoTermChoicePop";
	}

	/**
	 * 기존카탈로그 조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoExistingCatalogPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoExistingCatalogPop() {
		return "common/popup/coco/commonCoCoExistingCatalogPop";
	}

	/**
	 * 단가변경품의 결재선
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoUnitpriceAlterConsltApprovalPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoUnitpriceAlterConsltApprovalPop() {
		return "common/coco/commonCoCoUnitpriceAlterConsltApprovalPop";
	}

	/**
	 * 발주부서 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoOrderDepartmentSearchPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoOrderDepartmentSearchPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/coco/commonCoCoOrderDepartmentSearchPop_v2";
		} else {
			return "common/popup/coco/commonCoCoOrderDepartmentSearchPop";
		}
	}

	/**
	 * 배송처
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoDlvryPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoDlvryPop() {
		return "common/coco/commonCoCoDlvryPop";
	}

	/**
	 * 배송처 선택
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoDlvryChoicePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoDlvryChoicePop() {
		return "common/coco/commonCoCoDlvryChoicePop";
	}

	/**
	 * 부서상세보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoDepartmentDetailViewPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoDepartmentDetailViewPop() {
		return "common/coco/commonCoCoDepartmentDetailViewPop";
	}

	/**
	 * 부서코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoDepartmentCodePop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoDepartmentCodePop() {
		return "common/coco/commonCoCoDepartmentCodePop";
	}

	/**
	 * 사용자 선택 2
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoUserChoice2Pop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoUserChoice2Pop() {
		return "common/popup/coco/commonCoCoUserChoice2Pop";
	}

	/**
	 * 상품 이미지 보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoGoodsImageViewPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoGoodsImageViewPop() {
		return "common/coco/commonCoCoGoodsImageViewPop";
	}

	/**
	 * 예산부서 코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBudgetDepartmentCodePop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBudgetDepartmentCodePop() {
		return "common/popup/coco/commonCoCoBudgetDepartmentCodePop";
	}

	/**
	 * 예산부서 코드(다름)
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBudgetDepartmentCodeDiffPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBudgetDepartmentCodeDiffPop() {
		return "common/popup/coco/commonCoCoBudgetDepartmentCodeDiffPop";
	}

	/**
	 * 요청부서 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoRequestDepartmentSearchPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoRequestDepartmentSearchPop() {
		return "common/coco/commonCoCoRequestDepartmentSearchPop";
	}

	/**
	 * 이미지 확대보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoImageExpandViewPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoImageExpandViewPop() {
		return "common/coco/commonCoCoImageExpandViewPop";
	}

	/**
	 * 카탈로그 상세보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCatalogDetailViewPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoCatalogDetailViewPop() {
		return "common/coco/commonCoCoCatalogDetailViewPop";
	}

	/**
	 * 표준카달로그검색(CMS)
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoStndrdCatalogSearchPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoStndrdCatalogSearchPop() {
		return "common/coco/commonCoCoStndrdCatalogSearchPop";
	}

	/**
	 * 하위조직코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBottomOrgCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoBottomOrgCodePop() {
		return "common/coco/commonCoCoBottomOrgCodePop";
	}

	/**
	 * 회원사 상세보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoMbrCmpyDetailViewPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoMbrCmpyDetailViewPop() {
		return "common/coco/commonCoCoMbrCmpyDetailViewPop";
	}

	/**
	 * 회원사상세정보
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoMbrCmpyDetailInfoPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoMbrCmpyDetailInfoPop() {
		return "common/coco/commonCoCoMbrCmpyDetailInfoPop";
	}

	/**
	 * 회원정보 보기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoUserInfoViewPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoUserInfoViewPop() {
		return "common/coco/commonCoCoUserInfoViewPop";
	}

	/**
	 * 파일메니저
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoFileManagerPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoFileManagerPop() {
		return "common/coco/commonCoCoFileManagerPop";
	}

	/**
	 * 엑셀파일 선택
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoExcelFileChoicePop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoExcelFileChoicePop() {
		return "common/coco/commonCoCoExcelFileChoicePop";
	}

	/**
	 * 직급코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoPositionCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoPositionCodePop() {
		return "common/coco/commonCoCoPositionCodePop";
	}

	/**
	 * 도시코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCityCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoCityCodePop() {
		return "common/coco/commonCoCoCityCodePop";
	}

	/**
	 * 도착지 정보
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoDestinationInfoPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoDestinationInfoPop() {
		return "common/coco/commonCoCoDestinationInfoPop";
	}

	/**
	 * 결재자지정
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoApprovalAppointPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoApprovalAppointPop() {
		return "common/popup/coco/commonCoCoApprovalAppointPop";
	}

	/**
	 * 권한등록
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoAuthorityRegPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoAuthorityRegPop() {
		return "common/popup/coco/commonCoCoAuthorityRegPop";
	}

	/**
	 * 고객사/협력사 선택 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCompanyPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoCompanyPop() {
		return "common/popup/coco/commonCoCoCompanyPop";
	}

	/**
	 * 업체코드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCompanyCodePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoCompanyCodePop() {
		return "common/coco/commonCoCoCompanyCodePop";
	}

	/**
	 * 제품조달방법-거래유형
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoGoodsDlvyClssifyPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoGoodsDlvyClssifyPop() {
		return "common/coco/commonCoCoGoodsDlvyClssifyPop";
	}

	/**
	 * 물류센터 카탈로그 조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoLogisticCenterCatalogPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoLogisticCenterCatalogPop() {
		return "common/popup/coco/commonCoCoLogisticCenterCatalogPop";
	}

	/**
	 * 담당팀구분
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoTeamClassifyPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoTeamClassifyPop() {
		return "common/popup/coco/commonCoCoTeamClassifyPop";
	}

	/**
	 * 고객사 업종구분표
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBuyerBusnstypeClassifyPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBuyerBusnstypeClassifyPop() {
		return "common/coco/commonCoCoBuyerBusnstypeClassifyPop";
	}

	/**
	 * 소재지역명 상세
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoLocationDetailPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoLocationDetailPop() {
		return "common/popup/coco/commonCoCoLocationDetailPop";
	}

	/**
	 * 품목정보
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCmscatalogChangePop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoCmscatalogChangePop() {
		return "common/coco/commonCoCoCmscatalogChangePop";
	}

	/**
	 * 고객사 카탈로그 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCatalogAlterPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoCatalogAlterPop() {
		return "common/popup/coco/commonCoCoCatalogAlterPop";
	}
	/**
	 * MSDS 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoMsdsPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoMsdsPop() {
		return "common/popup/coco/commonCoCoMsdsPop";
	}
	/**
	 * MSDS 상세 등록
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoMsdsDetailRegPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoMsdsDetailRegPop() {
		return "common/popup/coco/commonCoCoMsdsDetailRegPop";
	}
	/**
	 * MSDS 상세 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoMsdsDetailPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoMsdsDetailPop(HttpServletRequest request, @RequestParam Map<String, Object> pMap,ModelMap pModel) {
		return "common/popup/coco/commonCoCoMsdsDetailPop";
	}
	//단순 보기용 MSDS 상세 조회 팝업(고객사,협력사)
	@RequestMapping(value = "/coco/showCommonCoCoMsdsDetailPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoBuyerMsdsDetailPop_v2(HttpServletRequest request, @RequestParam Map<String, Object> pMap,ModelMap pModel) {
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.geMsdsDetailList(pMap);
		List<Map<String,String>> _hdata = masterMdCmCatalogAlterService.geMsdsHeadDetailList_v2(pMap);
		List<Map<String,String>> _detailData = masterMdCmCatalogAlterService.getMasterMsdsDetailList_v2(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAttribute("hdata", _hdata);
		pModel.addAttribute("detaildata", _detailData);
		return "common/popup/coco/commonCoCoMsdsDetailPop_v2";
	}
	/**
	 * 구매사 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeBuyerChoiceMultiPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonNoNeBuyerChoiceMultiPop() {
		return "common/popup/none/commonNoNeBuyerChoiceMultiPop";
	}

	/**
	 * 나의 메뉴지정
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeBuyerMyMenuPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonNoNeBuyerMyMenuPop() {
		return "common/popup/none/commonNoNeBuyerMyMenuPop";
	}
	
	
	/**
	 * 나의 메뉴지정 리뉴얼
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeMyMenuPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonNoNeMyMenuPop() {
		return "common/popup/none/commonNoNeMyMenuPop_v2";
	}

	/**
	 * VOC 요청
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoVocBuyerReqCreateRegPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoVocBuyerReqCreateRegPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/coco/commonCoCoVocBuyerReqCreateRegPop_v2";
		} else {
			return "common/popup/coco/commonCoCoVocBuyerReqCreateRegPop";
		}
	}

	@RequestMapping(value = "/board/boardViewList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String boardViewList() {
		return "common/board/boardList";
	}

	@RequestMapping(value = "/board/boardWriteForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String boardWriteForm() {
		return "common/board/boardWriteForm";
	}
	
	
	@RequestMapping(value = "/board/boardWriteForm_new.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String boardWriteForm_new() {
		return "common/board/boardWriteForm_new";
	}

	@RequestMapping(value = "/board/codeMasterViewList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String codeMasterViewList() {
		return "common/board/codeMasterViewList";
	}

	/**
	 * 엑셀다운로드
	 * 
	 * @return
	 */
	@RequestMapping(value = "/directDown2Excel.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String directDown2Excel() {
		return "common/ibsheet/jsp/DirectDown2Excel";
	}

	@RequestMapping(value = "/error/errorAuthoriy.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String errorAuthoriy() {
		return "common/error/errorAuthoriy";
	}

	@RequestMapping(value = "/common/zcodeSelectPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String zcodeSelectPop() {
		return "common/popup/zcodeSelectPop";
	}
	@RequestMapping(value = "/common/getComCode2Pop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getComCode2Pop() {
		return "common/popup/comCode2PopSearch";
	}
	@RequestMapping(value = "/common/addMyCatalogPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String addMyCatalogPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/addMyCatalogPop_v2";
		} else {
			return "common/popup/addMyCatalogPop";
		}
	}
	// voc 관리자 전용 요청자 검색 팝업
	@RequestMapping(value = "/common/vocUserSelectPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String vocUserSelectPop() {
		return "common/popup/vocUserSelectPop";
	}
	//개인정보취급방침
	@RequestMapping(value = "/common/pop_privacy.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy() {
		return "common/popup/pop_privacy";
	}
	@RequestMapping(value = "/common/pop_privacy_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_v2() {
		return "common/popup/pop_privacy_v2";
	}
	//물류센터안내
	@RequestMapping(value = "/common/pop_centerInfo.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_centerInfo() {
		return "common/popup/pop_centerInfo";
	}
	//메일수집거부
	@RequestMapping(value = "/common/pop_email.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_email() {
		return "common/popup/pop_email";
	}
	@RequestMapping(value = "/common/pop_email_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_email_v2() {
		return "common/popup/pop_email_v2";
	}
	//ISMS
	@RequestMapping(value = "/common/pop_isms.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_isms() {
		return "common/popup/pop_isms";
	}
	//개인정보취급방침_201408
	@RequestMapping(value = "/common/pop_privacy_201408.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201408() {
		return "common/popup/pop_privacy_201408";
	}
	//개인정보취급방침_201509
	@RequestMapping(value = "/common/pop_privacy_201509.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201509() {
	    return "common/popup/pop_privacy_201509";
	}

	@RequestMapping(value = "/common/pop_privacy_201509_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201509_v2() {
	    return "common/popup/pop_privacy_201509_v2";
	}

	//개인정보취급방침_201604
	@RequestMapping(value = "/common/pop_privacy_201604.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201604() {
	    return "common/popup/pop_privacy_201604";
	}

	@RequestMapping(value = "/common/pop_privacy_201604_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201604_v2() {
	    return "common/popup/pop_privacy_201604_v2";
	}

	//개인정보취급방침_201607
	@RequestMapping(value = "/common/pop_privacy_201607.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201607() {
	    return "common/popup/pop_privacy_201607";
	}

	@RequestMapping(value = "/common/pop_privacy_201607_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201607_v2() {
	    return "common/popup/pop_privacy_201607_v2";
	}

	//개인정보취급방침_201708
	@RequestMapping(value = "/common/pop_privacy_201708.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201708() {
	    return "common/popup/pop_privacy_201708";
	}

	@RequestMapping(value = "/common/pop_privacy_201708_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201708_v2() {
	    return "common/popup/pop_privacy_201708_v2";
	}

	//개인정보취급방침_201808
	@RequestMapping(value = "/common/pop_privacy_201808.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201808() {
	    return "common/popup/pop_privacy_201808";
	}

	@RequestMapping(value = "/common/pop_privacy_201808_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_201808_v2() {
	    return "common/popup/pop_privacy_201808_v2";
	}

	//개인정보취급방침_20180830
	@RequestMapping(value = "/common/pop_privacy_20180830.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20180830() {
	    return "common/popup/pop_privacy_20180830";
	}

	@RequestMapping(value = "/common/pop_privacy_20180830_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20180830_v2() {
	    return "common/popup/pop_privacy_20180830_v2";
	}

	//개인정보취급방침_20190314
	@RequestMapping(value = "/common/pop_privacy_20190314.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20190314() {
	    return "common/popup/pop_privacy_20190314";
	}

	@RequestMapping(value = "/common/pop_privacy_20190314_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20190314_v2() {
	    return "common/popup/pop_privacy_20190314_v2";
	}

	//개인정보취급방침_20200108
	@RequestMapping(value = "/common/pop_privacy_20200108.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20200108() {
	    return "common/popup/pop_privacy_20200108";
	}

	@RequestMapping(value = "/common/pop_privacy_20200108_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20200108_v2() {
	    return "common/popup/pop_privacy_20200108_v2";
	}

	//개인정보취급방침_20210827
	@RequestMapping(value = "/common/pop_privacy_20210827.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20210827() {
	    return "common/popup/pop_privacy_20210827";
	}

	@RequestMapping(value = "/common/pop_privacy_20210827_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20210827_v2() {
	    return "common/popup/pop_privacy_20210827_v2";
	}

	//개인정보취급방침_20220923
	@RequestMapping(value = "/common/pop_privacy_20220923.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20220923() {
	    return "common/popup/pop_privacy_20220923";
	}

	@RequestMapping(value = "/common/pop_privacy_20220923_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20220923_v2() {
	    return "common/popup/pop_privacy_20220923_v2";
	}

	//개인정보취급방침_20240618
	@RequestMapping(value = "/common/pop_privacy_20240618.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20240618() {
	    return "common/popup/pop_privacy_20240618";
	}

	@RequestMapping(value = "/common/pop_privacy_20240618_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20240618_v2() {
	    return "common/popup/pop_privacy_20240618_v2";
	}

	//개인정보취급방침_20240717
	@RequestMapping(value = "/common/pop_privacy_20240717.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20240717() {
	    return "common/popup/pop_privacy_20240717";
	}

	@RequestMapping(value = "/common/pop_privacy_20240717_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20240717_v2() {
	    return "common/popup/pop_privacy_20240717_v2";
	}

	//개인정보취급방침_20250530
	@RequestMapping(value = "/common/pop_privacy_20250530.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20250530() {
	    return "common/popup/pop_privacy_20250530";
	}

	@RequestMapping(value = "/common/pop_privacy_20250530_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20250530_v2() {
	    return "common/popup/pop_privacy_20250530_v2";
	}
	
	//개인정보취급방침_20260828
	@RequestMapping(value = "/common/pop_privacy_20260828.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20260828() {
	    return "common/popup/pop_privacy_20260828";
	}

	@RequestMapping(value = "/common/pop_privacy_20260828_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String pop_privacy_20260828_v2() {
	    return "common/popup/pop_privacy_20260828_v2";
	}
	
	@RequestMapping(value = "/common/remarkAtoAPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkAtoAPop() {
		return "common/popup/remarkAtoAPop";
	}
	@RequestMapping(value = "/common/remarkAtoBPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkAtoBPop() {
		return "common/popup/remarkAtoBPop";
	}
	/**
	 * 사용자 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeUserChoiceMultiPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showCommonNoNeUserChoiceMultiPop() {
		return "common/popup/none/commonNoNeUserChoiceMultiPop";
	}
	
	// ICOMCOD3 이용(TYPE = 'BSAL') 고객사팝업
	@RequestMapping(value = "/common/icomcmpyBsalPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String icomcmpyBsalPop() {
		return "common/popup/icomcmpyBsalPop";
	}
	@RequestMapping(value = "/common/addImagePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String addImagePop() {
		return "common/popup/addImagePop";
	}
	
	// 예산부서 팝업(고객사 > 관리자 > 마감현황 > 예산부서)
	@RequestMapping(value = "/coco/showCommonCoCoBudgetDeptPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoBudgetDeptPop() {
		return "common/popup/coco/commonCoCoBudgetDeptPop";
	}
	
	// 계정 팝업(고객사 > 관리자 > 마감현황 > 계정)
	@RequestMapping(value = "/coco/showCommonCoCoAccountPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoAccountPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/coco/commonCoCoAccountPop_v2";
		}else{
			return "common/popup/coco/commonCoCoAccountPop";
		}
	}
	/**
	 * 고객사카탈로그팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoSamsungByitPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoSamsungByitPop() {
		return "common/popup/coco/commonCoCoSamsungByitPop";
	}
	/**
	 * MSDS정보
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/msdsInfoPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String msdsInfoPop() {
		return "common/popup/msdsInfoPop";
	}
	/**
	 * 고객사 환율조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoBuyerCurrencyPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoBuyerCurrencyPop() {
		return "common/popup/coco/commonCoCoBuyerCurrencyPop";
	}
	/**
	 * 환율조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoCurrencyPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoCurrencyPop() {
		return "common/popup/coco/commonCoCoCurrencyPop";
	}
	/**
	 * 이미지 첨부
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/imageFileUploadPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String imageFileUploadPop() {
		return "common/popup/imageFileUploadPop";
	}
	/**
	 * 단독입찰 사유팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/remarkSoloAngetPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String remarkSoloAngetPop() {
		return "common/popup/remarkSoloAngetPop";
	}
	/**
	 * 운영사 사용자 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/kepUserSelectAllPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String kepUserSelectAllPop() {
		return "common/popup/kepUserSelectAllPop";
	}
	/**
	 * 주문별예산 금액
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/budegtOrderAmtPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getBudegtOrderAmtPop() {
		return "common/popup/budegtOrderAmtPop";
	}
	/**
	 * 보낸문자함
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeSentSmsPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showCommonNoNeSentSmsPop() {
		return "common/popup/none/commonNoNeSentSmsPop";
	}
	/**
	 * 협력사 커뮤니티 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoAgentCommunitySelectPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String commonCoCoAgentCommunityPop() {
		return "common/popup/coco/commonCoCoAgentCommunitySelectPop";
	}
	/**
	 * 협력사 커뮤니티 등록 및 상세조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoAgentCommunityInsertPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showCommonCoCoAgentCommunityInsertPop() {
		return "common/popup/coco/commonCoCoAgentCommunityInsertPop";
	}
	
	/**
	 * ICOMCOD2List 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/commonIcomcod2List.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonIcomcod2List(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/geticomcod2Pop_v2";
		}else{
			return "common/popup/geticomcod2Pop";
		}
	}
	
	/**
	 * ICOMCOD1List 조회 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/commonIcomcod1WhereList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonIcomcod1WhereList() {
		return "common/popup/geticomcod1Pop";
	}
	/**
	 * 주문최근배송지 조회 팝업
	 * 
	 * @return
	 */	
	@RequestMapping(value = "/common/orderDelLocationPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String orderDelLocationPop() {
		return "common/popup/orderDelLocationPop";
	}
	/**
	 * 도착지입력기능
	 * 
	 * @return
	 */		
	@RequestMapping(value = "/common/delLocationAddPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String delLocationAddPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/delLocationAddPop_v2";
		} else {
			return "common/popup/delLocationAddPop";
		}
	}
	
	/**
	 * 고객사별 멀티 부서 검색
	 * 
	 * @return
	 */
	@RequestMapping(value = "/none/showCommonNoNeDeptChoiceMultiPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonNoNeDeptChoiceMultiPop() {
		return "common/popup/none/commonNoNeDeptChoiceMultiPop";
	}
	
	/**
	 * 협력사별 발주관리 팝업
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/agentPoMngPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String agentPoMngPop() {
		return "common/popup/mpso/masterMpSoAgentPoMngPop";
	}
	
	/**
	 * 운영이슈 등록
	 * 
	 * @return
	 */
	@RequestMapping(value = "/coco/showCommonCoCoIssueRegPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String commonCoCoIssueRegPop() {
		return "common/popup/coco/commonCoCoIssueRegPop";
	}
	/**
	 * 텍스트 변환기
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/textConverterPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String textConverterPop() {
		return "common/popup/textConverterPop";
	}
	
	/**
	 * 아모레 부서코드 조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/deptCodeAmorePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String deptCodeAmorePop() {
		return "common/popup/deptCodeAmorePop";
	}
	
	/**
	 * 운영사 산업분류명 조회
	 * 
	 * @return
	 */
	@RequestMapping(value = "/common/getKepIndTypePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getKepIndTypePop() {
		return "common/popup/kepIndTypePop";
	}
	
	// 원산지팝업_v2
	@RequestMapping(value = "/common/countryCodePop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String countryCodePop_v2() {
		return "common/popup/countryCodePop_v2";
	}
	
	// PR, PX 품목별 비고 조회 팝업
	@RequestMapping(value = "/common/showPrRemarkPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showPrRemarkPop() {
		return "common/popup/prRemarkPop";
	}
}
