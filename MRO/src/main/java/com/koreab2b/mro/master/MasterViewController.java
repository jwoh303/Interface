package com.koreab2b.mro.master;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterViewController")
public class MasterViewController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterViewController.class);

	@RequestMapping(value = "/include/masterHeader.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterHeader() {
		return "common/include/masterHeader";
	}

	@RequestMapping(value = "/include/masterFooter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterFooter() {
		return "common/include/masterFooter";
	}

	@RequestMapping(value = "/master/masterFrame.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterFrame() {
		return "master/masterFrame";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmProxyMainWorkProcess.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmProxyMainWorkProcess() {
		return "master/mdam/masterMdAmProxyMainWorkProcess";
	}

	@RequestMapping(value = "/mdcd/showMasterMdCdBuyerCardManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCdBuyerCardManage() {
		return "master/mdcd/masterMdCdBuyerCardManageList";
	}

	@RequestMapping(value = "/mdcd/showMasterMdCdBuyerCardSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCdBuyerCardSearch() {
		return "master/mdcd/masterMdCdBuyerCardSearchList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmCommonManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmCommonManage() {
		return "master/mdam/masterMdAmCommonManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmBuyerCommonCode.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmBuyerCommonCode() {
		return "master/mdam/masterMdAmBuyerCommonCodeList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMakerManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMakerManage() {
		return "master/mdam/masterMdAmMakerManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMenuManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMenuManage() {
		return "master/mdam/masterMdAmMenuManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmUserManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmUserManage() {
		return "master/mdam/masterMdAmUserManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmUserFirstPage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmUserFirstPage() {
		return "master/mdam/masterMdAmUserFirstPageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmRoleManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmRoleManage() {
		return "master/mdam/masterMdAmRoleManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmAuthorityManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmAuthorityManage() {
		return "master/mdam/masterMdAmAuthorityManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMasterCodeManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMasterCodeManage() {
		return "master/mdam/masterMdAmMasterCodeManageList";
	}

	@RequestMapping(value = "/master/mdam/showMasterMdAmMasterCodeManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmMasterCodeManage() {
		return "master/mdam/masterMdAmMasterCodeManageList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMasterCodePosition.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMasterCodePosition() {
		return "master/mdam/masterMdAmMasterCodePositionList";
	}

	@RequestMapping(value = "/master/mdam/showMasterMdAmMasterCodePosition.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmMasterCodePosition() {
		return "master/mdam/masterMdAmMasterCodePositionList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMasterCodeDepartment.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMasterCodeDepartment() {
		return "master/mdam/masterMdAmMasterCodeDepartmentList";
	}

	@RequestMapping(value = "/master/mdam/showMasterMdAmMasterCodeDepartment.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmMasterCodeDepartment() {
		return "master/mdam/masterMdAmMasterCodeDepartmentList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMasterCodeAccount.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMasterCodeAccount() {
		return "master/mdam/masterMdAmMasterCodeAccountList";
	}

	@RequestMapping(value = "/master/mdam/showMasterMdAmMasterCodeAccount.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmMasterCodeAccount() {
		return "master/mdam/masterMdAmMasterCodeAccountList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmMasterCodeRefNo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmMasterCodeRefNo() {
		return "master/mdam/masterMdAmMasterCodeRefNoList";
	}

	@RequestMapping(value = "/master/mdam/showMasterMdAmMasterCodeRefNo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmMasterCodeRefNo() {
		return "master/mdam/masterMdAmMasterCodeRefNoList";
	}

	@RequestMapping(value = "/mdam/showMasterMdAmInfoReferenceWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmInfoReferenceWrite() {
		return "master/mdam/masterMdAmInfoReferenceWrite";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrNewReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrNewReq() {
		return "master/mdsr/masterMdSrSrNewReqList";
	}
	@RequestMapping(value = "/mdsr/showMasterMdSrSrDataReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrDataReq() {
		return "master/mdsr/masterMdSrSrDataReqList";
	}
	@RequestMapping(value = "/mdsr/showMasterMdSrSrState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrState() {
		return "master/mdsr/masterMdSrSrStateList";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrCmsReceiptSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrCmsReceiptSearch() {
		return "master/mdsr/masterMdSrSrCmsReceiptList";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrCmsReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrCmsReceipt() {
		return "master/mdsr/masterMdSrSrCmsReceiptList";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrCmsStateSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrCmsStateSearch() {
		return "master/mdsr/masterMdSrSrCmsStateList";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrCmsState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrCmsState() {
		return "master/mdsr/masterMdSrSrCmsStateList";
	}

	@RequestMapping(value = "/mdsr/showMasterMdSrSrReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdSrSrReceipt() {
		return "master/mdsr/masterMdSrSrReceiptList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoDashBoard.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoDashBoard() {
		return "master/mpvo/masterMpVoDashBoardList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoVocReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoVocReceipt() {
		return "master/mpvo/masterMpVoVocReceiptList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoVocProgressState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoVocProgressState() {
		return "master/mpvo/masterMpVoVocProgressStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoVocState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoVocState() {
		return "master/mpvo/masterMpVoVocStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoVocLeadTime.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoVocLeadTime() {
		return "master/mpvo/masterMpVoVocLeadTimeList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoBizTeamState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoBizTeamState() {
		return "master/mpvo/masterMpVoBizTeamStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoBuyerState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoBuyerState() {
		return "master/mpvo/masterMpVoBuyerStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoAgntcmpyState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoAgntcmpyState() {
		return "master/mpvo/masterMpVoAgntcmpyStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoChargeReceiptState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoChargeReceiptState() {
		return "master/mpvo/masterMpVoChargeReceiptStateList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoStateDownload.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoStateDownload() {
		return "master/mpvo/masterMpVoStateDownloadList";
	}

	@RequestMapping(value = "/mpvo/showMasterMpVoVocDailySummary.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpVoVocDailySummary() {
		return "master/mpvo/masterMpVoVocDailySummaryList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqItemReqStnd.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqItemReqStnd() {
		return "master/mprq/masterMpRqItemReqStndList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqItemReqRcpt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqItemReqRcpt() {
		return "master/mprq/masterMpRqItemReqRcptList";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqItemReqStndBoard.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqItemReqStndBoard() {
		return "master/mprq/masterMpRqItemReqStndBoardList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqItemReqRcptBoard.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqItemReqRcptBoard() {
		return "master/mprq/masterMpRqItemReqRcptBoardList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqBuyerReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBuyerReq() {
		return "master/mprq/masterMpRqBuyerReqList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqReqQuotReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqReqQuotReceipt() {
		return "master/mprq/masterMpRqReqQuotReceiptList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingPurchase.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqDailySourcingPurchase() {
		return "master/mprq/masterMpRqDailySourcingPurchaseList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingBusiness.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqDailySourcingBusiness() {
		return "master/mprq/masterMpRqDailySourcingBusinessList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingDbManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqDailySourcingDbManage() {
		return "master/mprq/masterMpRqDailySourcingDbManageList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqReqNegoReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqReqNegoReceipt() {
		return "master/mprq/masterMpRqReqNegoReceiptList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqQuotationReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationReceipt() {
		return "master/mprq/masterMpRqQuotationReceiptList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDssSellerSel.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqDssSellerSel() {
		return "master/mprq/masterMpRqDssSellerSelList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqCmpySelQuotationSend.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqCmpySelQuotationSend() {
		return "master/mprq/masterMpRqCmpySelQuotationSendList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqQuotationReceiptSendLis.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationReceiptSendLis() {
		return "master/mprq/masterMpRqQuotationReceiptSendLisList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqQuotationReceiptSend.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationReceiptSend() {
		return "master/mprq/masterMpRqQuotationReceiptSendList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqQuotationProceState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationProceState() {
		return "master/mprq/masterMpRqQuotationProceStateList";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqQuotationReturnMsds.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationReturnMsds() {
		return "master/mprq/masterMpRqQuotationReturnMsds";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqUnitpriceAgrmntProxy.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqUnitpriceAgrmntProxy() {
		return "master/mprq/masterMpRqUnitpriceAgrmntProxyList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoProgress() {
		return "master/mpso/masterMpSoProgressList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTrProgressManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoTrProgressManage() {
		return "master/mpso/masterMpSoTrProgressManageList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderStandby.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderStandby() {
		return "master/mpso/masterMpSoOrderStandbyList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoClosingDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoClosingDetail() {
		return "master/mpso/masterMpSoClosingDetailList";
	}
	@RequestMapping(value = "/mpso/showMasterMpSoSellerDi.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoSellerDi(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoSellerDiList_v2";
		}else{
			return "master/mpso/masterMpSoSellerDiList_v2";
		}

	}
	@RequestMapping(value = "/mpso/showMasterMpSoOrderProgressHistory.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderProgressHistory() {
		return "master/mpso/masterMpSoOrderProgressHistoryList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderInfoAlter() {
		return "master/mpso/masterMpSoOrderInfoAlterList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoMultiAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderInfoMultiAlter(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoOrderInfoAlterMultiList_v2";
		}else {
			return "master/mpso/masterMpSoOrderInfoAlterMultiList";
		}
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderQuantityDivsn.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderQuantityDivsn() {
		return "master/mpso/masterMpSoOrderQuantityDivsnList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoBuyerOrderCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoBuyerOrderCreation(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoBuyerOrderCreationList_v2";
		}else {
			return "master/mpso/masterMpSoBuyerOrderCreationList";
		}
	}
	
	@RequestMapping(value = "/mpso/showMasterMpSoOrderIvGrCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderIvGrCreation(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoOrderIvGrCreationList_v2";
		}else {
			return "master/mpso/masterMpSoOrderIvGrCreationList";
		}
	}

	@RequestMapping(value = "/mpso/showMasterMpSoSellerWorkProxy.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoSellerWorkProxy(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoSellerWorkProxyList_v2";
		}else {
			return "master/mpso/masterMpSoSellerWorkProxyList";
		}
	}

	@RequestMapping(value = "/mpso/showMasterMpSoBuyerWarhsngProc.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoBuyerWarhsngProc(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoBuyerWarhsngProcList_v2";
		}else {
			return "master/mpso/masterMpSoBuyerWarhsngProcList";
		}
	}

	@RequestMapping(value = "/mpso/showMasterMpSoMonthClosingInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoMonthClosingInfo() {
		return "master/mpso/masterMpSoMonthClosingInfoList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOfficeSuppliesClosing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOfficeSuppliesClosing() {
		return "master/mpso/masterMpSoOfficeSuppliesClosingList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoPrewarhsngOrderManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoPrewarhsngOrderManage() {
		return "master/mpso/masterMpSoPrewarhsngOrderManageList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoSubmtrlRequest.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoSubmtrlRequest() {
		return "master/mpso/masterMpSoSubmtrlRequestList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoSubmtrlState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoSubmtrlState() {
		return "master/mpso/masterMpSoSubmtrlStateList";
	}

	@RequestMapping(value = "/mpso//mpso/showMasterMpSoReturnManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoReturnManage() {
		return "master/mpso/masterMpSoReturnManageList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoStock.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoStock() {
		return "master/mpso/masterMpSoStockList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoProductSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoProductSearch() {
		return "master/mpso/masterMpSoProductSearchList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoStockSuppleOrder.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoStockSuppleOrder() {
		return "master/mpso/masterMpSoStockSuppleOrderList";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoStockMovemntRequestReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoStockMovemntRequestReg() {
		return "master/mpso/masterMpSoStockMovemntRequestRegList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfOrderStandby.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfOrderStandby() {
		return "master/mpif/masterMpIfOrderStandbyList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfOrderQuantityDivsn.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfOrderQuantityDivsn() {
		return "master/mpif/masterMpIfOrderQuantityDivsnList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfSeq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfSeq() {
		return "master/mpif/masterMpIfSeqList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfProgressStateMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfProgressStateMain() {
		return "master/mpif/masterMpIfProgressStateMainList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfSourcing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfSourcing() {
		return "master/mpif/masterMpIfSourcingList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfErrorStateMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfErrorStateMain() {
		return "master/mpif/masterMpIfErrorStateMainList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfDlvrysttmnt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfDlvrysttmnt() {
		return "master/mpif/masterMpIfDlvrysttmntList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfWarehousing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfWarehousing() {
		return "master/mpif/masterMpIfWarehousingList";
	}

	@RequestMapping(value = "/mpif/showMasterMpIfBefr.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfBefr() {
		return "master/mpif/masterMpIfBefrList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsOrderManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDsOrderManage() {
		return "master/mpds/masterMpDsOrderManageList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDscropProtect.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDscropProtect() {
		return "master/mpds/masterMpDscropProtectList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsSeed.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDsSeed() {
		return "master/mpds/masterMpDsSeedList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsFertiPckmtrl.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDsFertiPckmtrl() {
		return "master/mpds/masterMpDsFertiPckmtrlList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsAgrchemiPckmtrl.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDsAgrchemiPckmtrl() {
		return "master/mpds/masterMpDsAgrchemiPckmtrlList";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsUser.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpDsUser() {
		return "master/mpds/masterMpDsUserList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogReg() {
		return "master/mdcm/masterMdCmCatalogRegList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogAlter() {
		return "master/mdcm/masterMdCmCatalogAlterList";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogMultiAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogMultiAlter() {
		return "master/mdcm/masterMdCmCatalogAlterMultiList";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogExistingAlterPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogExistingAlterPop() {
		return "common/popup/mdcm/masterMdCmCatalogExistingAlterPop";
	}


	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogSearch() {
		return "master/mdcm/masterMdCmCatalogSearchList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmStockCatalog.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmStockCatalog() {
		return "master/mdcm/masterMdCmStockCatalogList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCmsCatalog.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsCatalog() {
		return "master/mdcm/masterMdCmCmsCatalogList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCmsCatalogReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsCatalogReg() {
		return "master/mdcm/masterMdCmCmsCatalogRegList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCmsMappping.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsMappping() {
		return "master/mdcm/masterMdCmCmsMapppingList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmPromotionMarketCatalog.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmPromotionMarketCatalog() {
		return "master/mdcm/masterMdCmPromotionMarketCatalogList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmPromotionOnlineReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmPromotionOnlineReq() {
		return "master/mdcm/masterMdCmPromotionOnlineReqList";
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmPopularKeyword.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmPopularKeyword() {
		return "master/mdcm/masterMdCmPopularKeywordList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtBuyerRegManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerRegManage() {
		return "master/mdct/masterMdCtBuyerRegManageList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtCorpGroupManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtCorpGroupManage() {
		return "master/mdct/masterMdCtCorpGroupManageList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtBuyerGroupManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerGroupManage() {
		return "master/mdct/masterMdCtBuyerGroupManageList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtBuyerChargeEntry.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerChargeEntry() {
		return "master/mdct/masterMdCtBuyerChargeEntryList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtBuyerCorpRegNoManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerCorpRegNoManage() {
		return "master/mdct/masterMdCtBuyerCorpRegNoManageList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpUser.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpUser() {
		return "master/mdcp/masterMdCpUserList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpUserRegRequestReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpUserRegRequestReceipt() {
		return "master/mdcp/masterMdCpUserRegRequestReceiptList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpBuyerRegManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpBuyerRegManage() {
		return "master/mdcp/masterMdCpBuyerRegManageList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpBudgetDepartment.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpBudgetDepartment() {
		return "master/mdcp/masterMdCpBudgetDepartmentList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpDepartmentAccount.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpDepartmentAccount() {
		return "master/mdcp/masterMdCpDepartmentAccountList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpBudgetCompilation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpBudgetCompilation() {
		return "master/mdcp/masterMdCpBudgetCompilationList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpBudget.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpBudget() {
		return "master/mdcp/masterMdCpBudgetList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpAgntcmpyApprovalRequest.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAgntcmpyApprovalRequest() {
		return "master/mdcp/masterMdCpAgntcmpyApprovalRequestList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpAgntcmpyFinalApproval.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAgntcmpyFinalApproval() {
		return "master/mdcp/masterMdCpAgntcmpyFinalApprovalList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpAgntcmpy.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAgntcmpy() {
		return "master/mdcp/masterMdCpAgntcmpyList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpSellerPaymentCondition.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpSellerPaymentCondition() {
		return "master/mdcp/masterMdCpSellerPaymentConditionList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpBuyerPaymentCondition.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpBuyerPaymentCondition() {
		return "master/mdcp/masterMdCpBuyerPaymentConditionList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpSAgntcmpyRegManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpSAgntcmpyRegManage() {
		return "master/mdcp/masterMdCpSAgntcmpyRegManageList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpSgMakerManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpSgMakerManage() {
		return "master/mdcp/masterMdCpSgMakerManageList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpUserView.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpUserView() {
		return "master/mdcp/masterMdCpUserViewList";
	}

	@RequestMapping(value = "/mdcp/showMasterMdCpAdminApprovalObjct.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAdminApprovalObjct() {
		return "master/mdcp/masterMdCpAdminApprovalObjctList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtStndrdContract.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtStndrdContract() {
		return "master/mdct/masterMdCtStndrdContractList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtContractObjct.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtContractObjct() {
		return "master/mdct/masterMdCtContractObjctList";
	}

	@RequestMapping(value = "/mdct/showMasterMdCtContractProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtContractProgress() {
		return "master/mdct/masterMdCtContractProgressList";
	}

	@RequestMapping(value = "/mdct/showMasterSapInterfaceManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterSapInterfaceManage() {
		return "master/mdct/masterSapInterfaceManageList";
	}

	@RequestMapping(value = "/mdct/showMasterMdctBuyerIrsnManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdctBuyerIrsnManage() {
		return "master/mdct/masterMdctBuyerIrsnManageList";
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrTrGrCre.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrTrGrCre(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/wmgr/masterWmGrTrGrCreList_v2";
		}else {
			return "master/wmgr/masterWmGrTrGrCreList";
		}
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrStockGrCre.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrStockGrCre() {
		return "master/wmgr/masterWmGrStockGrCreList";
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrVmiWarhsng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrVmiWarhsng() {
		return "master/wmgr/masterWmGrVmiWarhsngList";
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrTrWarhsngProgressManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrTrWarhsngProgressManage(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/wmgr/masterWmGrTrWarhsngProgressManageList_v2";
		}else {
			return "master/wmgr/masterWmGrTrWarhsngProgressManageList";
		}
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrStockVmiWareHousingProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrStockVmiWareHousingProgress() {
		return "master/wmgr/masterWmGrStockVmiWareHousingProgressList";
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiReleaseDirectionsTran.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiReleaseDirectionsTran() {
		return "master/wmgi/masterWmGiReleaseDirectionsTranList";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiBpReleaseDirectionsTran.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiBpReleaseDirectionsTran() {
		return "master/wmgi/masterWmGiBpReleaseDirectionsTranList";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiProgressManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiProgressManage(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/wmgi/masterWmGiProgressManageList_v2";
		}else {
			return "master/wmgi/masterWmGiProgressManageList";
		}
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiOrderDelete.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiOrderDelete() {
		return "master/wmgi/masterWmGiOrderDeleteList";
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiDaehanBarcodePrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiDaehanBarcodePrint() {
		return "master/wmgi/masterWmGiDaehanBarcodePrintList";
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiTrReleaseRecord.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGiTrReleaseRecord() {
		return "master/wmgi/masterWmGiTrReleaseRecordList";
	}

	@RequestMapping(value = "/wmdl/showMasterWmDlIntervalsInfoReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmDlIntervalsInfoReg() {
		return "master/wmdl/masterWmDlIntervalsInfoRegList";
	}

	@RequestMapping(value = "/wmdl/showMasterWmDlIntervalsProgressState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmDlIntervalsProgressState() {
		return "master/wmdl/masterWmDlIntervalsProgressStateList";
	}

	@RequestMapping(value = "/wmdl/showMasterWmDlPackingListPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmDlPackingListPrint() {
		return "master/wmdl/masterWmDlPackingListPrintList";
	}

	@RequestMapping(value = "/wmdl/showMasterWmDlDlvryConfirm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmDlDlvryConfirm() {
		return "master/wmdl/masterWmDlDlvryConfirmList";
	}

	@RequestMapping(value = "/wmdl/showMasterWmDlBuyerWarhsng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmDlBuyerWarhsng() {
		return "master/wmdl/masterWmDlBuyerWarhsngList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReReturnReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/wmre/masterWmReReturnRegList_v2";
		}else {
			return "master/wmre/masterWmReReturnRegList";
		}
	}

	@RequestMapping(value = "/wmre/showMasterWmReAgntcmpyReturnRequestDirections.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReAgntcmpyReturnRequestDirections() {
		return "master/wmre/masterWmReAgntcmpyReturnRequestDirectionsList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnStatementPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReReturnStatementPrint() {
		return "master/wmre/masterWmReReturnStatementPrintList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReExchangeManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReExchangeManage(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "master/wmre/masterWmReExchangeManageList_v2";
		}else{
			return "master/wmre/masterWmReExchangeManageList";
		}
	}

	@RequestMapping(value = "/wmre/showMasterWmReAgntcmpyExchangeRequestDirections.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReAgntcmpyExchangeRequestDirections() {
		return "master/wmre/masterWmReAgntcmpyExchangeRequestDirectionsList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReExchangeStatementPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReExchangeStatementPrint() {
		return "master/wmre/masterWmReExchangeStatementPrintList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReAgntcmpyDelayManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReAgntcmpyDelayManage() {
		return "master/wmre/masterWmReAgntcmpyDelayManageList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnProgressState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReReturnProgressState() {
		return "master/wmre/masterWmReReturnProgressStateList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReReturnDetail() {
		return "master/wmre/masterWmReReturnDetailList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReExchangeDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReExchangeDetail() {
		return "master/wmre/masterWmReExchangeDetailList";
	}

	@RequestMapping(value = "/wmre/showMasterWmReAgntcmpyDelayDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReAgntcmpyDelayDetail() {
		return "master/wmre/masterWmReAgntcmpyDelayDetailList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStStock.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStStock() {
		return "master/wmst/masterWmStStockList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStStockMovemnt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStStockMovemnt() {
		return "master/wmst/masterWmStStockMovemntList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStLocationManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStLocationManage() {
		return "master/wmst/masterWmStLocationManageList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStAssmblCmpntsttmnt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStAssmblCmpntsttmnt() {
		return "master/wmst/masterWmStAssmblCmpntsttmntList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStAssmblDirections.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStAssmblDirections() {
		return "master/wmst/masterWmStAssmblDirectionsList";
	}

	@RequestMapping(value = "/wmpg/showMasterWmPgPrewarhsngTranStatementPrint.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmPgPrewarhsngTranStatementPrint() {
		return "master/wmpg/masterWmPgPrewarhsngTranStatementPrintList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStDailyReleaseList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStDailyReleaseList() {
		return "master/wmst/masterWmStDailyReleaseList";
	}

	@RequestMapping(value = "/wmst/showMasterWmStDailyBlncingaccntList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStDailyBlncingaccntList() {
		return "master/wmst/masterWmStDailyBlncingaccntList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClMenu.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClMenu() {
		return "master/cmcl/masterCmClMenuList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClClosingStndrdSetting.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClClosingStndrdSetting() {
		return "master/cmcl/masterCmClClosingStndrdSettingList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClIndividual.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClIndividual(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClIndividualList_v2";
		}else {
			return "master/cmcl/masterCmClIndividualList";
		}
	}

	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxSum.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxSum() {
		return "master/cmcl/masterCmClSalesTaxSumList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetUploadingCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxsheetUploadingCreation() {
		return "master/cmcl/masterCmClSalesTaxsheetUploadingCreationList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxsheetCreation() {
		return "master/cmcl/masterCmClSalesTaxsheetCreationList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetIssueReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxsheetIssueReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClSalesTaxsheetIssueRegList_v2";
		}else {
			return "master/cmcl/masterCmClSalesTaxsheetIssueRegList";
		}
	}

	@RequestMapping(value = "/cmcl/showMasterCmClSalesLogisticCostReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesLogisticCostReg() {
		return "master/cmcl/masterCmClSalesLogisticCostRegList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClPurchaseTaxsheetIndividualCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClPurchaseTaxsheetIndividualCreation(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClPurchaseTaxsheetIndividualCreationList_v2";
		}else {
			return "master/cmcl/masterCmClPurchaseTaxsheetIndividualCreationList";
		}
	}

	@RequestMapping(value = "/cmcl/showMasterCmClPurchaseTaxsheetAgntcmpySumCreation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClPurchaseTaxsheetAgntcmpySumCreation(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClPurchaseTaxsheetAgntcmpySumCreationList_v2";
		}else {
			return "master/cmcl/masterCmClPurchaseTaxsheetAgntcmpySumCreationList";
		}
	}

	@RequestMapping(value = "/cmcl/showMasterCmClPurchaseTaxsheetIssueReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClPurchaseTaxsheetIssueRegList_v2";
		}else {
			return "master/cmcl/masterCmClPurchaseTaxsheetIssueRegList";
		}
	}

	@RequestMapping(value = "/cmcl/showMasterCmClPurchaseTaxsheetSimulation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClPurchaseTaxsheetSimulation() {
		return "master/cmcl/masterCmClPurchaseTaxsheetSimulationList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClPurchaseDscntReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClPurchaseDscntReg() {
		return "master/cmcl/masterCmClPurchaseDscntRegList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClBuyerClosingState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClBuyerClosingState() {
		return "master/cmcl/masterCmClBuyerClosingStateList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClClosingTotal.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClClosingTotal() {
		return "master/cmcl/masterCmClClosingTotalList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClTeamBuyerSalesStatement.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClTeamBuyerSalesStatement() {
		return "master/cmcl/masterCmClTeamBuyerSalesStatementList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClProxyRecinpayStatement.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClProxyRecinpayStatement() {
		return "master/cmcl/masterCmClProxyRecinpayStatementList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClRecinpayTotal.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClRecinpayTotal() {
		return "master/cmcl/masterCmClRecinpayTotalList";
	}

	@RequestMapping(value = "/cmcl/showMasterCmClDeptClosing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClDeptClosing() {
		return "master/cmcl/masterCmClDeptClosingList";
	}

	@RequestMapping(value = "/wmco/showWmsReportViewer.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showWmsReportViewer() {
		return "common/popup/reportViewer";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvOrderReceiptDelayList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvOrderReceiptDelayList() {
		return "master/mpiv/masterMpIvOrderReceiptDelayList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeadlineDelayForecastOrderAction.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvDeadlineDelayForecastOrderAction() {
		return "master/mpiv/masterMpIvDeadlineDelayForecastOrderActionList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvBuyerNywarhsngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvBuyerNywarhsngList() {
		return "master/mpiv/masterMpIvBuyerNywarhsngListList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryDateAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvDeliveryDateAlter() {
		return "master/mpiv/masterMpIvDeliveryDateAlterList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryRecordManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvDeliveryRecordManage() {
		return "master/mpiv/masterMpIvDeliveryRecordManageList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvScmManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvScmManage() {
		return "master/mpiv/masterMpIvScmManageList";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvQuotationSendDelayPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvQuotationSendDelayPop() {
		return "common/popup/mpiv/masterMpIvQuotationSendDelayPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvQuotationSendLngtermDelayPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvQuotationSendLngtermDelayPop() {
		return "common/popup/mpiv/masterMpIvQuotationSendLngtermDelayPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvQuotationSendDelayReasonPop.jsp.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvQuotationSendDelayReasonPop() {
		return "common/popup/mpiv/masterMpIvQuotationSendDelayReasonPop";
	}

	@RequestMapping(value = "/mpst/showMasterMpStWarehousing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStWarehousing() {
		return "master/mpst/masterMpStWarehousingList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStHeadTeamResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStHeadTeamResult() {
		return "master/mpst/masterMpStHeadTeamResultList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStBuyerResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerResult() {
		return "master/mpst/masterMpStBuyerResultList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStSellerResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStSellerResult() {
		return "master/mpst/masterMpStSellerResultList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStMakerResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStMakerResult() {
		return "master/mpst/masterMpStMakerResultList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStSgResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStSgResult() {
		return "master/mpst/masterMpStSgResultList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStReverseMarginStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStReverseMarginStats() {
		return "master/mpst/masterMpStReverseMarginStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStQuotationStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStQuotationStats() {
		return "master/mpst/masterMpStQuotationStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStPaymentStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStPaymentStats() {
		return "master/mpst/masterMpStPaymentStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStDeptPaymentStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptPaymentStats() {
		return "master/mpst/masterMpStDeptPaymentStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStBuyerPaymentStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerPaymentStats() {
		return "master/mpst/masterMpStBuyerPaymentStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStDeptQuotationStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptQuotationStats() {
		return "master/mpst/masterMpStDeptQuotationStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStBuyerQuotationStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerQuotationStats() {
		return "master/mpst/masterMpStBuyerQuotationStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStDeptKpiStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptKpiStats() {
		return "master/mpst/masterMpStDeptKpiStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStBuyerKpiStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerKpiStats() {
		return "master/mpst/masterMpStBuyerKpiStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStDeptMarginStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptMarginStats() {
		return "master/mpst/masterMpStDeptMarginStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStBuyerMarginStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerMarginStats() {
		return "master/mpst/masterMpStBuyerMarginStatsList";
	}
	
	@RequestMapping(value = "/mpst/showMasterMpStCmpyStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStCmpyStats() {
		return "master/mpst/masterMpStCmpyStatsList";
	}

	@RequestMapping(value = "/mpst/showMasterMpStCategoryRecordPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStCategoryRecordPop() {
		return "common/popup/mpst/masterMpStCategoryRecordPop";
	}

	@RequestMapping(value = "/mpsm/showMasterMpSmStatsHome.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSmStatsHome() {
		return "master/mpsm/masterMpSmStatsHome";
	}
	
	@RequestMapping(value = "/mpsm/showMasterDeadlineMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterDeadlineMain() {
		return "master/masterDeadlineMain";
	}
	
	@RequestMapping(value = "/mpsm/showMasterVocMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterVocMain() {
		return "master/masterVocMain";
	}	
	@RequestMapping(value = "/mpsm/showMasterStatisticsMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterStatisticsMain() {
		return "master/masterStatisticsMain";
	}
	@RequestMapping(value = "/mpsm/showMasterProxbuyMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterProxbuyMain() {
		return "master/masterProxbuyMain";
	}
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationBulkHistroy.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationBulkHistroy() {
		return "master/mprq/masterMpRqQuotationBulkHistoryList";
	}
	
	// 제작품/수입품 일정등록 조회
	@RequestMapping(value = "/mpiv/showMasterMpIvMkImScheduleRegList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIvMkImScheduleRegList() {
		return "master/mpiv/masterMpIvMkImScheduleRegList";
	}
	
	// 기본 여신한도 등록
	@RequestMapping(value = "/clmg/showMasterClMgBasicCreditReg.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgBasicCreditReg() {
		return "master/clmg/masterClMgBasicCreditReg";
	}
	
	// 추가여신 등록
	@RequestMapping(value = "/clmg/showMasterClMgAddCreditReg.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgAddCreditReg() {
		return "master/clmg/masterClMgAddCreditReg";
	}
	
	// 여신한도 조회
	@RequestMapping(value = "/clmg/showMasterClMgCreditList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditList() {
		return "master/clmg/masterClMgCreditList";
	}
	
	// 여신한도 조회(사업팀)
	@RequestMapping(value = "/clmg/showMasterClMgCreditDeptList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditDeptList() {
		return "master/clmg/masterClMgCreditDeptList";
	}
	
	// 여신한도 조회(고객사)
	@RequestMapping(value = "/clmg/showMasterClMgCreditBuyerList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditBuyerList() {
		return "master/clmg/masterClMgCreditBuyerList";
	}
	
	// 여신한도 조회(그룹)
	@RequestMapping(value = "/clmg/showMasterClMgCreditGroupList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditGroupList() {
		return "master/clmg/masterClMgCreditGroupList";
	}
	
	// 여신한도 조회(법인)
	@RequestMapping(value = "/clmg/showMasterClMgCreditCorpList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditCorpList() {
		return "master/clmg/masterClMgCreditCorpList";
	}
	//로그관리
	@RequestMapping(value = "/mdam/showMasterMdAmlogManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmlogManage() {
		return "master/mdam/masterMdAmLogManageList";
	}
	
	// 장기재고
	@RequestMapping(value = "/mpst/showMasterMpStLongTermStck.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStLongTermStck() {
		return "master/mpst/masterMpStLongTermStckList";
	}
	
	// 장기재고 상세 조회
	@RequestMapping(value = "/mpst/showMasterMpStLongTermStckDt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStLongTermStckDt() {
		return "master/mpst/masterMpStLongTermStckDtList";
	}
	
	// 재고현황 추이
	@RequestMapping(value = "/mpst/showMasterMpStLongTermStckFlow.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStLongTermStckFlow() {
		return "master/mpst/masterMpStLongTermStckFlowList";
	}
	// 재고 에이징
	@RequestMapping(value = "/mpst/showMasterMpStAgingList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStAgingList() {
		return "master/mpst/masterMpStAgingList";
	}
	
	// 납기일변경
	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryDateList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIvDeliveryDateList() {
		return "master/mpiv/masterMpIvDeliveryDateList";
	}
	
	// 개선제안 메인
	@RequestMapping(value = "/mdpp/showMasterMdPpPropMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdPpPropMain() {
		return "master/masterMdPpPropMain";
	}
	
	// 개선제안 등록
	@RequestMapping(value = "/mdpp/showMasterMdPpPropRegList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdPpPropReg() {
		return "master/mdpp/masterMdPpPropRegList";
	}
	
	// 개선제안 현황
	@RequestMapping(value = "/mdpp/showMasterMdPpPropList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdPpPropList() {
		return "master/mdpp/masterMdPpPropList";
	}
	

	/**
	 * 코웨이 닥터 AS 리스트 처리 화면
	 * @return
	 */
	@RequestMapping(value = "/mpif/showMasterMpIfCowayDoctorASList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfCowayDoctorAs() {
		return "master/mpif/masterMpIfCowayDoctorAsList";
	}

	/**
	 * 코웨이 전표 조회 화명
	 * @return
	 */
	@RequestMapping(value = "/mpif/showMasterMpIfCowayBillList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfCowayBillList() {
		return "master/mpif/masterMpIfCowayBillList";
	}

	/**
	 * 코웨이 전표 조회 화명
	 * @return
	 */
	@RequestMapping(value = "/mpif/showMasterMpIfCowayChargeList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfCowayChargeList() {
		return "master/mpif/masterMpIfCowayChargeList";
	}
	//매출매입계산서Mappgin
	@RequestMapping(value = "/cmcl/showMasterCmClClArApMapping.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClClArApMapping() {
		return "master/cmcl/masterCmClClArApMappingList";
	}
	
	// 표준카테고리 추천
	@RequestMapping(value = "/mdcm/showMasterMdCmStndCategRcmdList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmStndCategRcmdList() {
		return "master/mdcm/masterMdCmStndCategRcmdList";
	}
	//세금계산서 조회
	@RequestMapping(value = "/cmcl/showMasterCmClTaxMapping.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClTaxMapping() {
		return "master/cmcl/masterCmClTaxMappingList";
	}
	//표준카탈로그조회
	@RequestMapping(value = "/mdcm/showmasterMdCmStndCatalogList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showmasterMdCmStndCatalogList() {
		return "master/mdcm/masterMdCmStndCatalogList";
	}
	//표준카탈로그등록
	@RequestMapping(value = "/mdcm/showMasterMdCmStndCatalogReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmStndCatalogReg() {
		return "master/mdcm/masterMdCmStndCatalogRegList";
	}
	//마감이월내역조회
	@RequestMapping(value = "/mpso/showMasterMpSoClosingMove.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoClosingMove() {
		return "master/mpso/masterMpSoClosingMoveList";
	}
	// 협력사별 매입실적
	@RequestMapping(value = "/mpst/showMasterMpStSellerApResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStSellerApResult() {
		return "master/mpst/masterMpStSellerApResultList";
	}
	// 상품이미지승인
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogImgReqList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogImgReqList() {
		return "master/mdcm/masterMdCmCatalogImgReqList";
	}
	// 표준카탈로그승인
	@RequestMapping(value = "/mdcm/showMasterMdCmStndCatalogConfirm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmStndCatalogConfirm() {
		return "master/mdcm/masterMdCmStndCatalogConfirm";
	}
	// 재고 에이징(입고)
	@RequestMapping(value = "/mpst/showMasterMpStAgingGrList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStAgingGrList() {
		return "master/mpst/masterMpStAgingGrList";
	}
	// 장기재고 증감현황
	@RequestMapping(value = "/mpst/showMasterMpStLongTermStckIncrList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStLongTermStckIncrList() {
		return "master/mpst/masterMpStLongTermStckIncrList";
	}
	// 재고에이징 상세(입고)
	@RequestMapping(value = "/mpst/showMasterMpStAgingGrDtList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStAgingGrDtList() {
		return "master/mpst/masterMpStAgingGrDtList";
	}
	// 반품통계
	@RequestMapping(value = "/mpst/showMasterMpStReturnStatsList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStReturnStatsList() {
		return "master/mpst/masterMpStReturnStatsList";
	}
	// 협력사 관리
	@RequestMapping(value = "/mdcd/showMasterMdCdAgentCardManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCdAgentCardManage() {
		return "master/mdcd/masterMdCdAgentCardManageList";
	}
	// 협력사 관리 (조회)
	@RequestMapping(value = "/mdcd/showMasterMdCdAgentCardSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCdAgentCardSearch() {
		return "master/mdcd/masterMdCdAgentCardSearchList";
	}
	// 반품 일괄 등록
	@RequestMapping(value = "/wmre/showMasterWmReReturnMultiReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmReReturnMultiReg() {
		return "master/wmre/masterWmReReturnMultiReg";
	}
	// 고객사카탈로그 매핑
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogMappingList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogMappingList() {
		return "master/mdcm/masterMdCatalogMappingList";
	}
	//매출세금계산서 합산 삼성 고객사
	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxGroupSum.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxGroupSum() {
		return "master/cmcl/masterCmClSalesTaxGroupSumList";
	}
	//매출세금계산서 삼성 역발행
	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetRaIssueReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxRAIssue() {
		return "master/cmcl/masterCmClSalesTaxsheetRaIssueRegList";
	}
	//삼성전자 품목정보 I/F
	@RequestMapping(value = "/mpif/showMasterMpIfSecItemInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfSecItemInfo() {
		return "master/mpif/masterMpIfSecItemInfoList";
	}
	//삼성전기 품목정보 I/F
	@RequestMapping(value = "/mpif/showMasterMpIfSemItemInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfSemItemInfo() {
		return "master/mpif/masterMpIfSemItemInfoList";
	}		
	// 고객사 통계 > 마감현황
	@RequestMapping(value = "/mpsm/showMasterMpSmClosingStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSmClosingStats() {
		return "master/mpsm/masterMpSmClosingStats";
	}
	// 물류비세금계산서생성(건별)
	@RequestMapping(value = "/cmcl/showMasterCmClSalesLogisTax.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesLogisTax(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClSalesLogisTaxList_v2";
		}else {
			return "master/cmcl/masterCmClSalesLogisTaxList";
		}
	}
	// 물류비세금계산서생성(협력사별합산)
	@RequestMapping(value = "/cmcl/showMasterCmClSalesLogisTaxAgentSum.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesLogisTaxAgentSum(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClSalesLogisTaxAgentSumList_v2";
		}else {
			return "master/cmcl/masterCmClSalesLogisTaxAgentSumList";
		}
	}
	// 물류비세금계산서발행/등록
	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetIssueLogisReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxsheetIssueLogisReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClSalesTaxsheetIssueLogisRegList_v2";
		}else {
			return "master/cmcl/masterCmClSalesTaxsheetIssueLogisRegList";
		}
	}
	// 물류수수료 통계 > 물류수수료(부서별)
	@RequestMapping(value = "/mpst/showMasterMpStLogisFeeDeptList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStLogisFeeDeptList() {
		return "master/mpst/masterMpStLogisFeeDeptList";
	}
	// 물류수수료 통계 > 물류수수료(고객사별)
	@RequestMapping(value = "/mpst/showMasterMpStLogisFeeBuyerList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStLogisFeeBuyerList() {
		return "master/mpst/masterMpStLogisFeeBuyerList";
	}
	// 물류수수료 통계 > 물류수수료(사유별)
	@RequestMapping(value = "/mpst/showMasterMpStLogisFeeReasonList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStLogisFeeReasonList() {
		return "master/mpst/masterMpStLogisFeeReasonList";
	}
	// 바코드 입출고 조회 리스트
	@RequestMapping(value = "/wmgr/showMasterWmGrBarcodeList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmGrBarcodeList() {
		return "master/wmgr/masterWmGrBarcodeList";
	}
	//카탈로그표준화통계(고객사)
	@RequestMapping(value = "/mpst/showMasterMpStBuyerCatlgStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerCatlgStats() {
		return "master/mpst/masterMpStBuyerCatlgStatsList";
	}
	//기존카탈로그표준화통계(부서)
	@RequestMapping(value = "/mpst/showMasterMpStDeptCatlgStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptCatlgStats() {
		return "master/mpst/masterMpStDeptCatlgStatsList";
	}
	// 환연동계약정보관리
	@RequestMapping(value = "/mdcm/showMasterMdCmExpMngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmExpMngList() {
		return "master/mdcm/masterMdCmExpMngList";
	}
	//신규카탈로그표준화통계(부서)
	@RequestMapping(value = "/mpst/showMasterMpStDeptNewCatlgStats.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStDeptNewCatlgStats() {
		return "master/mpst/masterMpStDeptNewCatlgStatsList";
	}
	
	// 여신한도 조회(사업팀)
	@RequestMapping(value = "/clmg/showMasterClMgCreditMngBuyerList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditMngBuyerList() {
		return "master/clmg/masterClMgCreditMngBuyerList";
	}
	
	// 표준카탈로그 추천
	@RequestMapping(value = "/mdcm/showMasterMdCmStndCatlgRcmdList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmStndCatlgRcmdList() {
		return "master/mdcm/masterMdCmStndCatlgRcmdList";
	}
	//주문정보 수정(환율)
	@RequestMapping(value = "/mpso/showMasterMpSoOrderExchangeRateAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoOrderExchangeRateAlter() {
		return "master/mpso/masterMpSoOrderExchangeRateAlterList";
	}
	//매출세금계산서 수출
	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxExportSum.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxExportSum() {
		return "master/cmcl/masterCmClSalesTaxExportSumList";
	}
	//고객사입고관리
	@RequestMapping(value = "/mpso/showMasterMpSoGrDetail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoGrDetail(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoGrDetailList_v2";
		}else {
			return "master/mpso/masterMpSoGrDetailList";
		}
	}
	// 외자납품 관리(PO기준)
	@RequestMapping(value = "/mpso/showMasterMpSoExportProgressPo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoExportProgressPo() {
		return "master/mpso/masterMpSoExportProgressPo";
	}
	// SG담당자별 견적관리
	@RequestMapping(value = "/mprq/showMasterMpRqSgUserMng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqSgUserMng() {
		return "master/mprq/masterMpRqSgUserMng";
	}
	// 고객사 SG별 실적조회
	@RequestMapping(value = "/mpst/showMasterMpStBuyerSgResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerSgResult() {
		return "master/mpst/masterMpStBuyerSgResultList";
	}
	// 협력사 SG별 실적조회
	@RequestMapping(value = "/mpst/showMasterMpStAgentSgResult.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStAgentSgResult() {
		return "master/mpst/masterMpStAgentSgResultList";
	}
	//신규고객사 관리
	@RequestMapping(value = "/mdct/showMasterMdCtNewCustomerMng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtNewCustomerMng() {
		return "master/mdct/masterMdCtNewCustomerManageList";
	}
	//인터페이스 발주생성
	@RequestMapping(value = "/mpif/showMasterMpIfOrderCreateList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfOrderCreateList() {
		return "master/mpif/masterMpIfOrderCreateList";
	}
	//인터페이스 모니터링(구)
	@RequestMapping(value = "/mpif/showMasterMpifErrMng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpifErrMng() {
		return "master/mpif/masterMpifErrMng";
	}
	//인터페이스 모니터링(신)
	@RequestMapping(value = "/mpif/showMasterNewMpifErrMng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterNewMpifErrMng() {
		return "master/mpif/masterNewMpifErrMng";
	}
	//인터페이스 오비맥주 발주 정보 수정
	@RequestMapping(value = "/mpif/showMasterMpIfObPoAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfObPoAlter() {
		return "master/mpif/MasterMpIfObPoAlter";
	}
	//인터페이스 협력사 크레텍 발주 정보 수정
	@RequestMapping(value = "/mpif/showMasterMpIfCretecPoList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfCretecPoList() {
		return "master/mpif/masterMpIfCretecPoList";
	}
	//물질정보 등록 관리
	@RequestMapping(value = "/mdcm/showMasterMdCmChemicalMatMngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmChemicalMatMngList() {
		return "master/mdcm/masterMdCmChemicalMatMngList";
	}
	//유해화학물질 실적조회
	@RequestMapping(value = "/mdcm/showMasterMdCmHarmfulChemistryList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmHarmfulChemistryList() {
		return "master/mdcm/masterMdCmHarmfulChemistryList";
	}
	// MSDS 메일수신자 관리
	@RequestMapping(value = "/mdcm/showMasterMdCmMsdsEmailManageList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmMsdsEmailManageList() {
		return "master/mdcm/masterMdCmMsdsEmailManageList";
	}
	// MSDS 조회 
	@RequestMapping(value = "/mdcm/showMasterMsdsList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMsdsList() {
		return "master/mdcm/masterMdCmMsdsList";
	}
	// MSDS 메일 전송이력 조회
	@RequestMapping(value = "/mdcm/showMasterMdCmMsdsEmailSentList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmMsdsEmailSentList() {
		return "master/mdcm/masterMdCmMsdsEmailSentList";
	}
	// MSDS 메일 전송 팝업
	@RequestMapping(value = "/mdcm/showMasterMdCmMsdsMailSendPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmMsdsMailSendPop() {
		return "master/mdcm/masterMdCmMsdsMailSendPop";
	}
	// 카탈로그 상품정보 변경
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogInfoMultiAlter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogInfoMultiAlter() {
		return "master/mdcm/masterMdCmCatalogInfoMultiAlter";
	}
	// 협력사 납기지연사유 관리
	@RequestMapping(value = "/mpiv/showMasterMpIvDeliDelayReasonManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvDeliDelayReasonManage() {
		return "master/mpiv/masterMpIvDeliDelayReasonManageList";
	}
	// 납기지연 리스트
	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryDelayList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIvDeliveryDelayListManage() {
		return "master/mpiv/masterMpIvDeliveryDelayList";
	}
	//인터페이스 발주생성
	@RequestMapping(value = "/mpif/showMasterMpIfGrCreate.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfGrCreate() {
		return "master/mpif/masterMpIfGrCreate";
	}
	// 고객사카탈로그 재계약
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogRecharterList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogRecharterList() {
		return "master/mdcm/masterMdCmCatalogRecharterList";
	}
	// 유니폼 진행관리(운영사, 협력사)
	@RequestMapping(value = "/master/mdam/showMasterMdAmUniformProgressList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmUniformProgressList() {
		return "master/mdam/masterMdAmUniformProgressList";
	}
	// 유니폼 진행관리(고객사)
	@RequestMapping(value = "/mdam/showMasterMdAmUniformProgressList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmUniformProgressList() {
		return "master/mdam/masterMdAmUniformProgressList";
	}
	// 유니폼 재고 월입고현황(운영사, 협력사)
	@RequestMapping(value = "master/mdam/showMasterMdAmUniformMonthGrList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmUniformMonthGrList() {
		return "master/mdam/masterMdAmUniformMonthGrList";
	}
	// 유니폼 재고 월입고현황(고객사)
	@RequestMapping(value = "/mdam/showMasterMdAmUniformMonthGrList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmUniformMonthGrList() {
		return "master/mdam/masterMdAmUniformMonthGrList";
	}
	// 유니폼 재고현황(운영사, 협력사)
	@RequestMapping(value = "master/mdam/showMasterMdAmUniformStockList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdAmUniformStockList() {
		return "master/mdam/masterMdAmUniformStockList";
	}
	// 유니폼 재고현황(고객사)
	@RequestMapping(value = "/mdam/showMasterMdAmUniformStockList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterMdAmUniformStockList() {
		return "master/mdam/masterMdAmUniformStockList";
	}
	// 견적 최저가 예외 현황
	@RequestMapping(value = "/mpst/showMasterMpStQuotExceptionList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStQuotExceptionList() {
		return "master/mpst/masterMpStQuotExceptionList";
	}
	// 견적 최저가 예외 상세
	@RequestMapping(value = "/mpst/showMasterMpStQuotExceptionDetailList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStQuotExceptionDetailList() {
		return "master/mpst/masterMpStQuotExceptionDetailList";
	}
	// 주문 단가조정 현황
	@RequestMapping(value = "/mpst/showMasterMpStPoPriceAdjustList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStPoPriceAdjustList() {
		return "master/mpst/masterMpStPoPriceAdjustList";
	}
	// 주문 단가조정 상세
	@RequestMapping(value = "/mpst/showMasterMpStPoPriceAdjustDetailList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStPoPriceAdjustDetailList() {
		return "master/mpst/masterMpStPoPriceAdjustDetailList";
	}
	// 삼성전자발주현황
	@RequestMapping(value = "/mpif/showMasterMpifSamsungPoList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpifSamsungPoList() {
		return "master/mpif/masterMpifSamsungPoList";
	}
	// 매출세금계산서적요업로드
	@RequestMapping(value = "/cmcl/showMasterCmClSalesTaxsheetRemarkUploadList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesTaxsheetRemarkUploadList() {
		return "master/cmcl/masterCmClSalesTaxsheetRemarkUploadList";
	}
	// 매출계산서메일수신자업로드
	@RequestMapping(value = "/cmcl/showMasterCmClSalesReceiverUploadList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClSalesReceiverUploadList() {
		return "master/cmcl/masterCmClSalesReceiverUploadList";
	}
	//기업정보관리
	@RequestMapping(value = "/mdct/showMasterMdCtCustomerInfoMng.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtCustomerInfoMng() {
		return "master/mdct/masterMdCtCustomerInfoMngList";
	}
	//협력사재고관리
	@RequestMapping(value = "/wmst/showMasterWmStAgentStock.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmStAgentStock() {
		return "master/wmst/masterWmStAgentStockList";
	}
	//카탈로그 소싱 요청
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogRegReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogRegReq() {
		return "master/mdcm/masterMdCmCatalogRegReqList";
	}
	//카탈로그 소싱 진행
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogRegProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCatalogRegProgress() {
		return "master/mdcm/masterMdCmCatalogRegProgressList";
	}
	//고객사 프로파일
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerProfile.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerProfile() {
		return "master/mdct/masterMdCtBuyerProfileList";
	}
	//재계약관리
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerReContract.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerReContract() {
		return "master/mdct/masterMdCtBuyerReContractList";
	}
	//리포트관리현황
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerReportMngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtBuyerReportMngList() {
		return "master/mdct/masterMdCtBuyerReportMngList";
	}
	//고객사별견적비고관리
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerRemarkList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBuyerRemarkList() {
		return "master/mprq/masterMpRqBuyerRemarkList";
	}
	// 운영발주관리
	@RequestMapping(value = "/mpso/showMasterMpSoIssueManageList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoIssueManageList() {
		return "master/mpso/masterMpSoIssueManageList";
	}
	//경영실적
	@RequestMapping(value = "/mpst/showMasterMpStPerformanceList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpStBuyerPerformance() {
		return "master/mpst/masterMpStPerformanceList";
	}
	//재계약 신규고객 현황(전체)
	@RequestMapping(value = "/mdct/showMasterMdCtNewReBuyerAllList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtNewReBuyerAllList() {
		return "master/mdct/masterMdCtNewReBuyerAllList";
	}
	//재계약 신규고객 현황(개인)
	@RequestMapping(value = "/mdct/showMasterMdCtNewReBuyerIndvList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCtNewReBuyerIndvList() {
		return "master/mdct/masterMdCtNewReBuyerIndvList";
	}
	// 지급이슈 등록 및 조회
	@RequestMapping(value = "/mpso/showMasterMpSoPayRegMngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoSubmitIssueList() {
		return "master/mpso/masterMpSoPayRegMngList";
	}
	
	// 지급이슈 등록 조회 팝업
	@RequestMapping(value = "/mpso/showMasterMpSoPayRegMngUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoPayRegMngUploadList() {		
		return "common/popup/mpso/masterMpSoPayRegMngUploadPop";
	}
	
	// 지급이슈 발주 조회 팝업
	@RequestMapping(value = "/mpso/showMasterMpSoPayRegMngUploadPoSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoPayRegMngUploadPoSearchPop() {
		return "common/popup/mpso/masterMpSoPayRegMngUploadPoSearchPop";
	}
	
	//증빙제외발주등록
	@RequestMapping(value = "/mpso/showMasterMpSoInvExceptReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoInvExceptReg(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/mpso/masterMpSoInvExceptRegList_v2";
		}else{
			return "master/mpso/masterMpSoInvExceptRegList_v2";
		}
	}

	// 물류수수료율 등록
	@RequestMapping(value = "/cmcl/showMasterCmClLogisRateMngList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClLogisRateMngList() {
		return "master/cmcl/masterCmClLogisRateMngList";
	}
	
	// 물류수수료율 등록 팝업
	@RequestMapping(value = "/cmcl/showMasterCmClLogisRateMngUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClLgstUploadList() {		
		return "common/popup/cmcl/masterCmClLogisRateMngUploadPop";
	}
	
	// 물류비 상세 발행내역
	@RequestMapping(value = "/cmcl/showMasterCmClLogisRateDetailList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClLogisRateDetailList(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClLogisRateDetailList_v2";
		}else {
			return "master/cmcl/masterCmClLogisRateDetailList";
		}
	}

	// 월별 마감확정내역(매출)
	@RequestMapping(value = "/cmcl/showMasterCmClArCloseConfirmList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClArCloseConfirmList() {
		return "master/cmcl/masterCmClArCloseConfirmList";
	}
	
	// 월별 마감확정내역(매입)
	@RequestMapping(value = "/cmcl/showMasterCmClApCloseConfirmList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClApCloseConfirmList(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "master/cmcl/masterCmClApCloseConfirmList_v2";
		}else {
			return "master/cmcl/masterCmClApCloseConfirmList";
		}
	}
	
	// 삼성전자 단가변경(IF)
	@RequestMapping(value = "/mpif/showMasterMpIfSamsungCatalogUploadList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpIfSamsungCatalogUploadList() {
		return "master/mpif/masterMpIfSamsungCatalogUploadList";
	}
	// 벌크소싱 프로젝트 관리
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationProjectList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBulkQuotationProjectList() {
		return "master/mprq/masterMpRqBulkQuotationProjectList";
	}
	
	// 벌크소싱 품목 관리
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationItemList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBulkQuotationItemList() {
		return "master/mprq/masterMpRqBulkQuotationItemList";
	}
	
	// 벌크소싱 견적요청
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationReceiptList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBulkQuotationReceiptList() {
		return "master/mprq/masterMpRqBulkQuotationReceiptList";
	}
	
	// 벌크소싱 견적현황
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationProceList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqBulkQuotationProceList() {
		return "master/mprq/masterMpRqBulkQuotationProceList";
	}
	
	// 상품정보 조회 및 관리
	@RequestMapping(value = "/mdcm/showMasterMdcmCmsItemList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdcmCmsItemList() {
		return "master/mdcm/masterMdCmCmsItemList";
	}

	// 상품정보 수정요청 (DB관리파트 승인화면)
	@RequestMapping(value = "/mdcm/showMasterMdcmCmsItemChangeReqList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdcmCmsItemChangeReqList() {
		return "master/mdcm/masterMdCmCmsItemChangeReqList";
	}

	// 상품정보 수정요청 현황 (요청자 화면)
	@RequestMapping(value = "/mdcm/showMasterMdcmCmsItemChangeReqStatusList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdcmCmsItemChangeReqStatusList() {
		return "master/mdcm/masterMdCmCmsItemChangeReqStatusList";
	}

	// 구매정보 조회 및 관리
	@RequestMapping(value = "/mdcm/showMasterMdcmCmsBuyInfoList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdcmCmsBuyInfoList() {
		return "master/mdcm/masterMdCmCmsBuyInfoList";
	}

	// 매입단가유효일 관리
	@RequestMapping(value = "/mdcm/showMasterMdcmCmsPriceValidList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdcmCmsPriceValidList() {
		return "master/mdcm/masterMdCmCmsPriceValidList";
	}
	
	// 리뉴얼 실적/정산현황
	@RequestMapping(value = "/mpsm/showMasterMpSmStats_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSmStats_v2(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());

		pModel.addAttribute("tab_data", _data);
		return "master/mpsm/masterMpSmStats_v2";
	}
}
