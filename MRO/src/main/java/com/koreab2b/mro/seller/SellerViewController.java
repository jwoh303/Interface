package com.koreab2b.mro.seller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("sellerViewController")
public class SellerViewController {

	@RequestMapping(value = "/sellerMain.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerMain() {
		return "seller/sellerMain";
	}

	@RequestMapping(value = "/sellerDetailMain.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerDetailMain() {
		return "seller/sellerDetailMain";
	}
	
	@RequestMapping(value = "/include/sellerHeader.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerHeader() {
		return "common/include/sellerHeader";
	}

	
	@RequestMapping(value = "/include/sellerFooter.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerFooter() {
		return "common/include/sellerFooter";
	}

	// TODO
	@RequestMapping(value = "/mdam/showSellerMdAmTodo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdAmTodo() {
		return "seller/mdam/sellerMdAmTodoList";
	}

	// 납기도래건수(납기도래품목현황)
	@RequestMapping(value = "/mdam/showSellerMdAmDeadlineAdventCnt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdAmDeadlineAdventCnt() {
		return "seller/mdam/sellerMdAmDeadlineAdventCntList";
	}
	
	// 납기지연 고객사 팝업
	@RequestMapping(value = "/mdam/showSellerMdAmDeliveryDelayListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdAmDeliveryDelayListPop() {
		return "seller/mdam/sellerMdAmDeliveryDelayListPop";
	}
	
	// 개인정보
	@RequestMapping(value = "/mdam/showSellerMdAmUserInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdAmUserInfo() {
		return "seller/mdam/sellerMdAmUserInfoList";
	}
    
	// 협력사 홈(메인) : 공통
	// 고객의 소리
	@RequestMapping(value = "/none/showSellerNoNeBuyerVoice.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerNoNeBuyerVoice() {
		return "seller/none/sellerNoNeBuyerVoice";
	}
	
	// 공지사항 목록
	@RequestMapping(value = "/none/showSellerNoNeNoticeListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerNoNeNoticeListPop() {
		return "seller/none/sellerNoNeNoticeListPop";
	}


	// 리뉴얼 자주묻는 질문
	@RequestMapping(value = "/mscs/sellerMCSCAskedQuestNotice.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMCSCAskedQuestNotice() {
		return "seller/mcsc/sellerMCSCAskedQuestNotice";
	}
	
	// 리뉴얼 공지사항 목록
	@RequestMapping(value = "/mscs/sellerMCSCNotice.do")
	public String showSellerMCSCNotice(@RequestParam(value = "tab", required = false) String tab,
	                                     @RequestParam(value = "menuId", required = false) String menuId,
	                                     @RequestParam(value = "bid", required = false) String bid,
	                                     @RequestParam(value = "btype", required = false) String btype,
	                                     @RequestParam(value = "faqId", required = false) String faqId,
	                                     org.springframework.ui.ModelMap model) {

	    // tab 파라미터가 명시적으로 전달되면 우선 사용
	    // menuId가 있고 tab이 없으면 menuId 기반 탭 매핑
	    // 파일 구조: tab1.jsp(Search3/자주묻는질문/tab3모듈), tab2.jsp(Search2/1:1문의/tab2모듈), tab3.jsp(Search1/공지사항/tab1모듈)
	    if (tab == null || tab.isEmpty()) {
	        if (menuId != null && !menuId.isEmpty()) {
	            if ("sr00701000000".equals(menuId)) {
	                tab = "1";  // 공지사항 → tab3.jsp → tab1 모듈 → Search1
	            } else if ("sr00702000000".equals(menuId)) {
	                tab = "2";  // 1:1 문의 → tab2.jsp → tab2 모듈 → Search2
	            } else if ("sr00703000000".equals(menuId)) {
	                tab = "3";  // 자주묻는질문 → tab1.jsp → tab3 모듈 → Search3
	            }
	        }
	    }

	    // tab 파라미터가 없으면 기본값 설정
	    if (tab == null || tab.isEmpty()) {
	        tab = "2";  // 기본값: 1:1 문의 탭 (tab2 모듈)
	    }

	    model.addAttribute("defaultTab", tab);
	    model.addAttribute("menuId", menuId);
	    model.addAttribute("bid", bid);
	    model.addAttribute("btype", btype);
	    model.addAttribute("faqId", faqId);
	    return "seller/mcsc/sellerMCSCNotice";
	}
	
	
	// 리뉴얼 1:1 문의
	@RequestMapping(value = "/mscs/sellerMCSCOneOnOneInquiry.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMCSCOneOnOneInquiry() {
		return "seller/mcsc/sellerMCSCOneOnOneInquiry";
	}



	
	// 공지사항 상세
	@RequestMapping(value = "/none/showSellerNoNeNoticeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerNoNeNoticeDetailPop() {
		return "seller/none/sellerNoNeNoticeDetailPop";
	}
	
	// 판촉물 제안하기
	@RequestMapping(value = "/none/showSellerNoNeSaleshookProposal.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerNoNeSaleshookProposal() {
		return "seller/none/sellerNoNeSaleshookProposal";
	}
	
	// 판촉물 제안하기_신규품목제안
	@RequestMapping(value = "/none/showSellerNoNeSaleshookProposalCreate.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerNoNeSaleshookProposalCreate() {
		return "seller/none/sellerNoNeSaleshookProposalCreate";
	}
	
	// 견적요청접수
	@RequestMapping(value = "/mprq/showSellerMpRqEstiReqList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqEstiReqList() {
		return "seller/mprq/sellerMpRqEstiReqList";
	}
	
	// 견적상세내역
	@RequestMapping(value = "/mprq/showSellerMpRqQuotaProceStateList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotaProceStateList() {
		return "seller/mprq/sellerMpRqQuotaProceStateList";
	}
	
	// 협력사 팝업 공지사항 호출
	@RequestMapping(value = "/none/showSellerNoNePopupListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showtSellerNoNePopupListPop() {
		return "seller/none/sellerNoNePopupListPop";
	}
	
	// ------- 납품관리 
	// 수주접수
	@RequestMapping(value = "/mpiv/showSellerMpIvObtnodrReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvObtnodrReceipt(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpiv/sellerMpIvObtnodrReceiptList_v2";
		} else {
			return "seller/mpiv/sellerMpIvObtnodrReceiptList";
		}
		
		
	}

	// 제작품/수입품 일정등록 조회
	@RequestMapping(value = "/mpiv/showSellerMpIvMkImScheduleRegList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvMkImScheduleRegList() {
		return "seller/mpiv/sellerMpIvMkImScheduleRegList";
	}
	
    // 거래명세서 작성
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWrite.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementWrite(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String uiVersion2 = (String) request.getSession().getAttribute("uiVersion2");
			if("renewal_S".equals(uiVersion2)) { //매입마감 관련 flag
				return "seller/mpiv/sellerMpIvTranStatementWriteList_v3";
			}else {
				return "seller/mpiv/sellerMpIvTranStatementWriteList_v2";
			}
		} else {
			return "seller/mpiv/sellerMpIvTranStatementWriteList";
		}
	}
	
	// 거래명세서 작성(일괄)
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementDivsnWrite.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementDivsnWrite() {
		return "seller/mpiv/sellerMpIvTranStatementDivsnWriteList";
	}
	
    // 거래명세서 출력 및 삭제
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementPrintDelete.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementPrintDelete() {
		return "seller/mpiv/sellerMpIvTranStatementPrintDeleteList";
	}
	
    // 납품실적등록
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRecordReg.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryRecordReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String uiVersion2 = (String) request.getSession().getAttribute("uiVersion2");
			if("renewal_S".equals(uiVersion2)) { //매입마감 관련 flag
				return "seller/mpiv/sellerMpIvDeliveryRecordRegList_v3";
			}else {
				return "seller/mpiv/sellerMpIvDeliveryRecordRegList_v2";
			}
		} else {
			return "seller/mpiv/sellerMpIvDeliveryRecordRegList";
		}
		
		
	}
	
    // 납품실적 조회 및 삭제
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRecordDelete.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryRecordDelete() {
		return "seller/mpiv/sellerMpIvDeliveryRecordDeleteList";
	}
	
    // 납품 지연 현황
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryDelayState.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryDelayState() {
		return "seller/mpiv/sellerMpIvDeliveryDelayStateList";
	}
	
    // 납품 진행현황
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryProgressState.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryProgressState(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpiv/sellerMpIvDeliveryProgressStateList_v2";
		} else {
			return "seller/mpiv/sellerMpIvDeliveryProgressStateList";
		}
	}
	
    // 선입고 납품 관리
	@RequestMapping(value = "/mpiv/showSellerMpIvPrewarhsngDeliveryManage.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvPrewarhsngDeliveryManage() {
		return "seller/mpiv/sellerMpIvPrewarhsngDeliveryManageList";
	}
	
    // 반품/교환 접수처리
	@RequestMapping(value = "/mpiv/showSellerMpIvReturnExchangeReceiptProc.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvReturnExchangeReceiptProc() {
		return "seller/mpiv/sellerMpIvReturnExchangeReceiptProcList";
	}
	
    // 반품/교환 접수조회
	@RequestMapping(value = "/mpiv/showSellerMpIvReturnExchangeReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvReturnExchangeReceipt() {
		return "seller/mpiv/sellerMpIvReturnExchangeReceiptList";
	}

	// -----------도안관리
	// 비료포장재
	@RequestMapping(value = "/mpds/showSellerMpDsFertiPckmtrl.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpDsFertiPckmtrl() {
		return "seller/mpds/sellerMpDsFertiPckmtrlList";
	}
	
    // 농약포장재
	@RequestMapping(value = "/mpds/showSellerMpDsAgrchemiPckmtrl.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpDsAgrchemiPckmtrl() {
		return "seller/mpds/sellerMpDsAgrchemiPckmtrlList";
	}
	
	// 발주진행관리
	@RequestMapping(value = "/mpds/showSellerMpDsOrderProgressManage.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpDsOrderProgressManage() {
		return "seller/mpds/sellerMpDsOrderProgressManageList";
	}
	
    // 작물보호
	@RequestMapping(value = "/mpds/showSellerMpDscropProtect.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpDscropProtect() {
		return "seller/mpds/sellerMpDscropProtectList";
	}
	
    // 종자
	@RequestMapping(value = "/mpds/showSellerMpDsSeed.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpDsSeed() {
		return "seller/mpds/sellerMpDsSeedList";
	}

	// -------------- 회원사관리
    // 회원사정보
	@RequestMapping(value = "/mdct/showSellerMdCtMbrCmpyInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtMbrCmpyInfo(HttpServletRequest request) {
	
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mdct/sellerMdCtMbrCmpyInfoList_v2";
		} else {
			return "seller/mdct/sellerMdCtMbrCmpyInfoList";
		}
	}

	// 사용자조회
	@RequestMapping(value = "/mdct/showSellerMdCtUserSearch.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtUserSearch(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mdct/sellerMdCtUserSearchList_v2";
		} else {
			return "seller/mdct/sellerMdCtUserSearchList";
		}
	}
	
	// 계약진행조회
	@RequestMapping(value = "/mdct/showSellerMdCtContractProgress.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtContractProgress() {
		return "seller/mdct/sellerMdCtContractProgressList";
	}
	
	// -----------------재고관리
	
	// 공구자재 재고현황
	@RequestMapping(value = "/mpst/showSellerMpStToolStockState.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpStToolStockState() {
		return "seller/mpst/sellerMpStToolStockStateList";
	}
	
	// 권고발주접수
	@RequestMapping(value = "/mpst/showSellerMpStRecmndOrderReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpStRecmndOrderReceipt(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpst/sellerMpStRecmndOrderReceiptList_v2";
		} else {
			return "seller/mpst/sellerMpStRecmndOrderReceiptList";
		}
	}
	
	// 납품실적조회	
    @RequestMapping(value = "/mpst/showSellerMpStDeliveryRecord.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpStDeliveryRecord(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpst/sellerMpStDeliveryRecordList_v2";
		} else {
			return "seller/mpst/sellerMpStDeliveryRecordList";
		}
	}
    
    // 재고현황조회	
    @RequestMapping(value = "/mpst/showSellerMpStStockState.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpStStockState(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpst/sellerMpStStockStateList_v2";
		} else {
			return "seller/mpst/sellerMpStStockStateList";
		}
	}
    
    // 마감조회
	@RequestMapping(value = "/mpst/showSellerMpStClosing.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpStClosing(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpst/sellerMpStClosingList_v2";
		} else {
			return "seller/mpst/sellerMpStClosingList";
		}
	}
   
	// ------------- 정산관리
	// 마감정보조회
	@RequestMapping(value = "/mpcl/showSellerMpClClosingInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClClosingInfo(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String uiVersion2 = (String) request.getSession().getAttribute("uiVersion2");
			if("renewal_S".equals(uiVersion2)) { //매입마감 관련 flag
				return "seller/mpcl/sellerMpClClosInfoList_v3";
			}else {
				return "seller/mpcl/sellerMpClClosInfoList_v2";
			}
		} else {
			return "seller/mpcl/sellerMpClClosInfoList";
		}
	}
	
	// 세금계산서 발행현황
	@RequestMapping(value = "/mpcl/showSellerMpClTaxsheetIssueState.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClTaxsheetIssueState() {
		return "seller/mpcl/sellerMpClTaxsheetIssueStateList";
	}
	
	// 물류비 상세 발행내역
	@RequestMapping(value = "/mpcl/showSellerMpClLogisRateDetail.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClLogisRateDetail() {
		return "seller/mpcl/sellerMpClLogisRateDetailList";
	}
	
	// ---------------카탈로그관리
	// 카탈로그정비관리
	@RequestMapping(value = "/mpcl/showSellerMpClCmsReqList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClCmsReqList() {
		return "seller/mpcl/sellerMpClCmsReqList";
	}
	// ---------------카탈로그관리
	// 카탈로그정비조회
	@RequestMapping(value = "/mpcl/showSellerMpClCmsList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClCmsList() {
		return "seller/mpcl/sellerMpClCmsList";
	}

	// ---------------관리자
	// 카탈로그조회
	@RequestMapping(value = "/mpcl/showSellerMpClCatalog.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClCatalog(HttpServletRequest request) {

		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpcl/sellerMpClCatalogList_v2";
		} else {
			return"seller/mpcl/sellerMpClCatalogList";
		}
		
		
	}
	
	// 직급코드
	@RequestMapping(value = "/mpcl/showSellerMpClPositionCodeList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClPositionCodeList() {
		return "seller/mpcl/sellerMpClPositionCodeList";
	}
	
	// 부서코드	
    @RequestMapping(value = "/mpcl/showSellerMpClDepartmentCodeList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClDepartmentCodeList() {
    	return "seller/mpcl/sellerMpClDepartmentCodeList";
	}
    
    // 배송차량
	@RequestMapping(value = "/mpcl/showSellerMpClDlvryCarList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClDlvryCarList() {
		return "seller/mpcl/sellerMpClDlvryCarList";
	}
    // 납품기일 변경현황
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryDateList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryDateList() {
		return "seller/mpiv/sellerMpIvDeliveryDateList";
	}
	// 수주접수
	@RequestMapping(value = "/mpiv/showSellerMpIvObtnodrMultiReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvObtnodrMultiReceipt() {
		return "seller/mpiv/sellerMpIvObtnodrMultiReceiptList";
	}
	// 물질정보 제출
	@RequestMapping(value = "/mdct/showSellerMdCmChemicalMatSendList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCmChemicalMatSendList() {
		return "seller/mdct/sellerMdCmChemicalMatSendList";
	}
	// 물질정보 진행조회
	@RequestMapping(value = "/mdct/showSellerMdCmChemicalMatMngList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCmChemicalMatMngList(HttpServletRequest request) {

		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return  "seller/mdct/sellerMdCmChemicalMatMngList_v2";
		} else {
			return  "seller/mdct/sellerMdCmChemicalMatMngList";
		}
		
		
		
	}
	// 견적요청접수
	@RequestMapping(value = "/mprq/showSellerMpRqQuotReqList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotReqList() {
		return "seller/mprq/sellerMpRqQuotReqList";
	}
	// 카탈로그 관리 재계약 제출
	@RequestMapping(value = "/mpcl/showSellerMpClCatalogRecharterList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClCatalogRecharter(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpcl/sellerMpClCatalogRecharterList_v2";
		} else {
			return "seller/mpcl/sellerMpClCatalogRecharterList";
		}
	}
	// 카탈로그 관리 재계약 제출
	@RequestMapping(value = "/mpcl/showSellerMpClCatalogRecharterMngList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClCatalogRecharterMngList() {
		return "seller/mpcl/sellerMpClCatalogRecharterMngList";
	}
	// 요청사항 진행현황
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliChangeReqList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryRequest(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "seller/mpiv/sellerMpIvDeliChangeReqList_v2";
		} else {
			return "seller/mpiv/sellerMpIvDeliChangeReqList";
		}
		
	}	
	
	
	// 리뉴얼 > 견적관리 > 일반견적
	@RequestMapping(value = "/mprq/showSellerMpRqQuotList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotList() {
		return "seller/mprq/sellerMpRqQuotList_v2";
	}
	
	// 리뉴얼 > 견적관리 > 프로젝트견적
	@RequestMapping(value = "/mprq/showSellerMpRqBulkQuotList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqBulkQuotList() {
		return "seller/mprq/sellerMpRqBulkQuotList_v2";
	}
}