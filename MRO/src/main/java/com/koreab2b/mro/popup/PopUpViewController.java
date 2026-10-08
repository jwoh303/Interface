package com.koreab2b.mro.popup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.coco.service.CommonApprovalService;
import com.koreab2b.mro.common.coco.service.CommonRefPrNoPopupService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("popUpViewController")
public class PopUpViewController {

	@Autowired
	CommonApprovalService commonApprovalService;
	
	@Autowired
	CommonRefPrNoPopupService commonRefPrNoPopupService;
	
	// 고객카드관리
	@RequestMapping(value = "/mdcd/showMasterMdCdBuyerCardInfoRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCdBuyerCardInfoRegPop() {
		return "common/popup/mdcd/masterMdCdBuyerCardInfoRegPop";
	}
	
	@RequestMapping(value = "/mdct/showSellerMdCtStndrdContractPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtStndrdContractPop() {
		return "common/popup/mdct/sellerMdCtStndrdContractPop";
	}
	
	@RequestMapping(value = "/mdct/showSellerMdCtContractWritePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtContractWritePop() {
		return "common/popup/mdct/sellerMdCtContractWritePop";
	}
	
	@RequestMapping(value = "/mdct/showMasterMdCtCorpGroupChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtCorpGroupChoicePop() {
		return "common/popup/mdct/masterMdCtCorpGroupChoicePop";
	}
	
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerGroupChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtBuyerGroupChoicePop() {
		return "common/popup/mdct/masterMdCtBuyerGroupChoicePop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpPrivateInfoAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpPrivateInfoAlterPop() {
		return "common/popup/mdcp/masterMdCpPrivateInfoAlterPop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpCreditEvaluationInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpCreditEvaluationInfoPop() {
		return "common/popup/mdcp/masterMdCpCreditEvaluationInfoPop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpBuyerPaymentConditionRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpBuyerPaymentConditionRegPop() {
		return "common/popup/mdcp/masterMdCpBuyerPaymentConditionRegPop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpBuyerPaymentConditionAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpBuyerPaymentConditionAlterPop() {
		return "common/popup/mdcp/masterMdCpBuyerPaymentConditionAlterPop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpPaymentAccountFormPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpPaymentAccountFormPop() {
		return "common/popup/mdcp/masterMdCpPaymentAccountFormPop";
	}
	
	@RequestMapping(value = "/mdcp/showMasterMdCpRejectReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCpRejectReasonPop() {
		return "common/popup/mdcp/masterMdCpRejectReasonPop";
	}
	
	@RequestMapping(value = "/mdct/showMasterMdCtStndrdContractPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtStndrdContractPop() {
		return "common/popup/mdct/masterMdCtStndrdContractPop";
	}
	
	@RequestMapping(value = "/mdct/showMasterMdCtContractCancleRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtContractCancleRegPop() {
		return "common/popup/mdct/masterMdCtContractCancleRegPop";
	}
	
	@RequestMapping(value = "/mdct/showMasterMdctBuyerCorpGroupPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdctBuyerCorpGroupPop() {
		return "common/popup/mdct/masterMdctBuyerCorpGroupPop";
	}
	// 상품관리
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogBuyerChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogBuyerChoicePop() {
		return "common/popup/mdcm/masterMdCmCatalogBuyerChoicePop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmGroupViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmGroupViewPop() {
		return "common/popup/mdcm/masterMdCmGroupViewPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmAllUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmAllUploadPop() {
		return "common/popup/mdcm/masterMdCmAllUploadPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmUnitpriceAlterHistoryPop() {
		return "common/popup/mdcm/masterMdCmUnitpriceAlterHistoryPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogImageRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogImageRegPop() {
		return "common/popup/mdcm/masterMdCmCatalogImageRegPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmSellerCmpyChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmSellerCmpyChoicePop() {
		return "common/popup/mdcm/masterMdCmSellerCmpyChoicePop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogAddPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogAddPop() {
		return "common/popup/mdcm/masterMdCmCatalogAddPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmStndrdCatalogDetailViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmStndrdCatalogDetailViewPop() {
		return "common/popup/mdcm/masterMdCmStndrdCatalogDetailViewPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmImageViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmImageViewPop() {
		return "common/popup/mdcm/masterMdCmImageViewPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmGoodsInfoDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmGoodsInfoDetailPop() {
		return "common/popup/mdcm/masterMdCmGoodsInfoDetailPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmFinalOrderDateViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmFinalOrderDateViewPop() {
		return "common/popup/mdcm/masterMdCmFinalOrderDateViewPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmFileUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmFileUploadPop() {
		return "common/popup/mdcm/masterMdCmFileUploadPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmCopyCountPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCopyCountPop() {
		return "common/popup/mdcm/masterMdCmCopyCountPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmChangeReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmChangeReasonPop() {
		return "common/popup/mdcm/masterMdCmChangeReasonPop";
	}
	
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsCatalogRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmCmsCatalogRemarkPop() {
		return "common/popup/mdcm/masterMdCmCmsCatalogRemarkPop";
	}
    
	@RequestMapping(value = "/mdcm/showMasterMdCmItemDetailInfoModifyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmItemDetailInfoModifyPop() {
		return "master/mdcm/masterMdCmItemDetailInfoModifyPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmItemDetailInfoViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmItemDetailInfoViewPop() {
		return "master/mdcm/masterMdCmItemDetailInfoViewPop";
	}
	// 견적
    @RequestMapping(value = "/common/mprq/quotationReDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String quotationReDetailPop() {
		return "common/popup/mprq/quotationReDetailPop";
	}
	
	@RequestMapping(value = "/common/mprq/quotationInitListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String quotationInitListPop() {
		return "common/popup/mprq/masterMpRqQuotationInitListPop";
	}
	// 견적
	@RequestMapping(value = "/common/mprq/newSourcingBuyerListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String newSourcingBuyerListPop() {
		return "common/popup/mprq/newSourcingBuyerListPop";
	}
	
	@RequestMapping(value = "/common/mprq/newSourcingNegoBuyerListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String newSourcingNegoBuyerListPop() {
		return "common/popup/mprq/newSourcingNegoBuyerListPop";
	}
	
	@RequestMapping(value = "/common/mprq/reAgentSelectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String reAgentSelectPop() {
		return "common/popup/mprq/reAgentSelectPop";
	}
	
	@RequestMapping(value = "/common/mprq/estimateAbandonmentReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String estimateAbandonmentReasonPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mprq/estimateAbandonmentReasonPop_v2";
		} else {
			return "common/popup/mprq/estimateAbandonmentReasonPop";
		}
	}
	
	@RequestMapping(value = "/common/mprq/masterMpRqContractLisPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String masterMpRqContractLisPop() {
		return "common/popup/mprq/masterMpRqContractLisPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqSouringBidSucessCodePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSouringBidSucessCodePop() {
		return "common/popup/mprq/masterMpRqSouringBidSucessCodePop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqMarginReSelectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqMarginReSelectPop() {
		return "common/popup/mprq/masterMpRqMarginReSelectPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqExcelUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqExcelUploadPop() {
		return "common/popup/mprq/buyerMpRqExcelUploadPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqCatalogRegYnPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqCatalogRegYnPop() {
		return "common/popup/mprq/buyerMpRqCatalogRegYnPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqNegoReqPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqNegoReqPop() {
		return "common/popup/mprq/buyerMpRqNegoReqPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqClosePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqClosePop() {
		return "common/popup/mprq/buyerMpRqClosePop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqUserRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqUserRemarkPop() {
		return "common/popup/mprq/buyerMpRqUserRemarkPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqDepartmentTotalPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqDepartmentTotalPop() {
		return "common/popup/mprq/buyerMpRqDepartmentTotalPop";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqQuotationPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqQuotationPrintPop() {
		return "common/popup/mprq/buyerMpRqQuotationPrintPop";
	}
	
	@RequestMapping(value = "/mprq/showSellerMpRqQuotationPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotationPrintPop() {
		return "common/popup/mprq/sellerMpRqQuotationPrintPop";
	}
	
	@RequestMapping(value = "/mprq/showSellerMpRqUnitPriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqUnitPriceHistoryPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mprq/sellerMpRqUnitPriceHistoryPop_v2";
		} else {
			return "common/popup/mprq/sellerMpRqUnitPriceHistoryPop";
		}
		
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqNegoViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqNegoViewPop() {
		return "common/popup/mprq/buyerMpRqNegoViewPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqPumPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqPumPrintPop() {
		return "common/popup/mprq/masterMpRqPumPrintPop";
	}
	
	@RequestMapping(value = "/mprq/showSellerMpRqQuotationSendUnitpriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotationSendUnitpriceHistoryPop() {
		return "common/popup/mprq/sellerMpRqQuotationSendUnitpriceHistoryPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqContractLisPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqContractLisPop() {
		return "common/popup/mprq/masterMpRqContractLisPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqDbStndrdProgressPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDbStndrdProgressPop() {
		return "common/popup/mprq/masterMpRqDbStndrdProgressPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqKepStndrdCategorySelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqKepStndrdCategorySelPop() {
		return "common/popup/mprq/masterMpRqKepStndrdCategorySelPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqStndrdCatalogSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqStndrdCatalogSearchPop() {
		return "common/popup/mprq/masterMpRqStndrdCatalogSearchPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqGoodsDetailInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqGoodsDetailInfoPop() {
		return "common/popup/mprq/masterMpRqGoodsDetailInfoPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqMapppingReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqMapppingReasonPop() {
		return "common/popup/mprq/masterMpRqMapppingReasonPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqPop() {
		return "common/popup/mprq/masterMpRqPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqStndrdCatalogPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqStndrdCatalogPop() {
		return "common/popup/mprq/masterMpRqStndrdCatalogPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerCatalogPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBuyerCatalogPop() {
		return "common/popup/mprq/masterMpRqBuyerCatalogPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqSellerSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerSelPop() {
		return "common/popup/mprq/masterMpRqSellerSelPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqDssSellerSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDssSellerSelPop() {
		return "master/mprq/masterMpRqDssSellerSelList";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerQuotationReceiptSendCntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBuyerQuotationReceiptSendCntPop() {
		return "common/popup/mprq/masterMpRqBuyerQuotationReceiptSendCntPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqReqUserSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqReqUserSelPop() {
		return "common/popup/mprq/masterMpRqReqUserSelPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqSellerQuotationRequestFormPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerQuotationRequestFormPop() {
		return "common/popup/mprq/masterMpRqSellerQuotationRequestFormPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationUnitpriceHistoryPop() {
		return "common/popup/mprq/masterMpRqQuotationUnitpriceHistoryPop";
	}
	
	@RequestMapping(value = "/mprq/showPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showPop() {
		return "common/popup/mprq/pop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationPrintPop() {
		return "common/popup/mprq/masterMpRqQuotationPrintPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqComprQuotationPrintPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqComprQuotationPrintPop() {
		return "common/popup/mprq/masterMpRqComprQuotationPrintPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqSellerChoice2Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerChoice2Pop() {
		return "common/popup/mprq/masterMpRqSellerChoice2Pop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqSellerChoice3Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerChoice3Pop() {
		return "common/popup/mprq/masterMpRqSellerChoice3Pop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqSellerChoice4Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerChoice4Pop() {
		return "common/popup/mprq/masterMpRqSellerChoice4Pop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqSellerChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSellerChoicePop() {
		return "common/popup/mprq/masterMpRqSellerChoicePop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerQuotationSendPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBuyerQuotationSendPop() {
		return "common/popup/mprq/masterMpRqBuyerQuotationSendPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationInitHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationInitHistoryPop() {
		return "common/popup/mprq/masterMpRqQuotationInitHistoryPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationAgrmntDtRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationAgrmntDtRegPop() {
		return "common/popup/mprq/masterMpRqQuotationAgrmntDtRegPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerSalesprofitRatePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBuyerSalesprofitRatePop() {
		return "common/popup/mprq/masterMpRqBuyerSalesprofitRatePop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqDoosanStockCodeInsPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDoosanStockCodeInsPop() {
		return "common/popup/mprq/masterMpRqDoosanStockCodeInsPop";
	}
	
	@RequestMapping(value = "/mprq/showMasterMpRqBuyerFinalUnitpriceAgrmntCntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBuyerFinalUnitpriceAgrmntCntPop() {
		return "common/popup/mprq/masterMpRqBuyerFinalUnitpriceAgrmntCntPop";
	}
	
	@RequestMapping(value = "/coco/showCommonCoCoBuyerCategoryChoiceDooPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonCoCoBuyerCategoryChoiceDooPop() {
		return "common/popup/coco/commonCoCoBuyerCategoryChoiceDooPop";
	}
	
	@RequestMapping(value = "/coco/showCommonCoCoCateSearchDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonCoCoCateSearchDetailPop() {
		return "common/popup/coco/commonCoCoCateSearchDetailPop";
	}

	@RequestMapping(value = "/common/mpso/poDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String poDetailPop() {
		return "common/popup/mpso/poDetailPop";
	}

	@RequestMapping(value = "/common/mpso/poDetailHistPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String poDetailHistPop() {
		return "common/popup/mpso/poDetailHistPop";
	}

	@RequestMapping(value = "/common/mpiv/invoiceDisplayPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String invoiceDisplayPop() {
		return "common/popup/mpiv/invoiceDisplayPop";
	}

	@RequestMapping(value = "/common/mpiv/catePriceHistory.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String catePriceHistory(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/catePriceHistoryPop_v2";
		} else {
			return "common/popup/mpiv/catePriceHistoryPop";
		}
	}
	
	@RequestMapping(value = "/common/mpiv/catePriceBuyerHistory.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String cateBuyerPriceHistory(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/catePriceBuyerHistoryPop_v2";
		} else {
			return "common/popup/mpiv/catePriceBuyerHistoryPop";
		}
	}
	@RequestMapping(value = "/mpso/showBuyerMpSoBudgetItmPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String buyerMpSoBudgetItmPop() {
		return "common/popup/mpso/buyerMpSoBudgetItmPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoFagkbcAccountPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoFagkbcAccountPop() {
		return "common/popup/mpso/buyerMpSoFagkbcAccountPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoConsmAccountPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoConsmAccountPop() {
		return "common/popup/mpso/buyerMpSoConsmAccountPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoKyongDongCostCenterPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoKyongDongCostCenterPop() {
		return "common/popup/mpso/buyerMpSoKyongDongCostCenterPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoHiteJinroSiteConsmTeamPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoHiteJinroSiteConsmTeamPop() {
		return "common/popup/mpso/buyerMpSoHiteJinroSiteConsmTeamPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoKolonGlobalCostCenterPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoKolonGlobalCostCenterPop() {
		return "common/popup/mpso/buyerMpSoKolonGlobalCostCenterPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoGuessTempCarTechCostCenterPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoGuessTempCarTechCostCenterPop() {
		return "common/popup/mpso/buyerMpSoGuessTempCarTechCostCenterPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoYuHanKimChonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoYuHanKimChonPop() {
		return "common/popup/mpso/buyerMpSoYuHanKimChonPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoPartInfoPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoPartInfoPop() {
		return "common/popup/mpso/buyerMpSoPartInfoPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoGraduateDetailDeptCodePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoGraduateDetailDeptCodePop() {
		return "common/popup/mpso/buyerMpSoGraduateDetailDeptCodePop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoAccountSelPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoAccountSelPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoAccountSelPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoAccountSelPop";
		}
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoAccountSel1Pop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoAccountSel1Pop() {
		return "common/popup/mpso/buyerMpSoAccountSel1Pop";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoAccountSelIFPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoAccountSelIFPop() {
		return "common/popup/mpso/buyerMpSoAccountSelIFPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoCategoryTotalViewPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoCategoryTotalViewPop() {
		return "common/popup/mpso/buyerMpSoCategoryTotalViewPop";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoBudgetListPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoBudgetListPop() {
		return "common/popup/mpso/buyerMpSoBudgetListPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoStockMovemntStdcatlgPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoStockMovemntStdcatlgPop() {
		return "common/popup/mpso/masterMpSoStockMovemntStdcatlgPop";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoOrderRemarkInsPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoOrderRemarkInsPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mppo/buyerMpPoOrderRemarkInsPop_v2";
		}else{
			return "common/popup/mppo/buyerMpPoOrderRemarkInsPop";
		}
	}
	@RequestMapping(value = "/mppo/showBuyerMpPoDocTypeRemarkPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoDocTypeRemarkPop_v2(HttpServletRequest request) {
		return "common/popup/mppo/buyerMpPoDocTypeRemarkPop_v2";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoApprovalReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoApprovalReasonPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mppo/buyerMpPoApprovalReasonPop_v2";
		} else {
			return "common/popup/mppo/buyerMpPoApprovalReasonPop";
		}
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoRejectReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoRejectReasonPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mppo/buyerMpPoRejectReasonPop_v2";
		}else{
			return "common/popup/mppo/buyerMpPoRejectReasonPop";
		}
	}

	@RequestMapping(value = "/mppo/showBuyerPrRecvReturnReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerPrRecvReturnReasonPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mppo/buyerPrRecvReturnReasonPop_v2";
		}else{
			return "common/popup/mppo/buyerPrRecvReturnReasonPop";
		}
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoOrderDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoOrderDetailPop() {
		return "common/popup/mppo/buyerMpPoOrderDetailPop";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoGoodsAddPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoGoodsAddPop() {
		return "common/popup/mppo/buyerMpPoGoodsAddPop";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoDvlyAgrmntHistoryPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoDvlyAgrmntHistoryPop() {
		return "common/popup/mppo/buyerMpPoDvlyAgrmntHistoryPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsOrderInfoCheckPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsOrderInfoCheckPop() {
		return "common/popup/mpds/buyerMpDsOrderInfoCheckPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsOrderCreationPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsOrderCreationPop() {
		return "common/popup/mpds/buyerMpDsOrderCreationPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsDeliveryPlanPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsDeliveryPlanPop() {
		return "common/popup/mpds/buyerMpDsDeliveryPlanPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsPckpaprDesignManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsPckpaprDesignManagePop() {
		return "common/popup/mpds/buyerMpDsPckpaprDesignManagePop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsPckpaprDesignRejectStatePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsPckpaprDesignRejectStatePop() {
		return "common/popup/mpds/buyerMpDsPckpaprDesignRejectStatePop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsPckpaprDesignSeedManagePop() {
		return "common/popup/mpds/buyerMpDsPckpaprDesignSeedManagePop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsItemInspPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsItemInspPop() {
		return "common/popup/mpds/buyerMpDsItemInspPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsQualityCmplnOccurFactorDeductPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsQualityCmplnOccurFactorDeductPop() {
		return "common/popup/mpds/buyerMpDsQualityCmplnOccurFactorDeductPop";
	}

	@RequestMapping(value = "/mpds/showBuyerMpDsInspDetailItemPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpDsInspDetailItemPop() {
		return "common/popup/mpds/buyerMpDsInspDetailItemPop";
	}

	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetDepartmentChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMdAmBudgetDepartmentChoicePop() {
		return "common/popup/mdam/buyerMdAmBudgetDepartmentChoicePop";
	}
	
	@RequestMapping(value = "/mdam/showMasterMdAmMakerManageRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMdAmMakerManageRegPop() {
		return "common/popup/mdam/MasterMdAmMakerManageRegPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsItemResultPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsItemResultPop() {
		return "common/popup/mpds/sellerMpDsItemResultPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsQualityCmplnOccurFactorDeductPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsQualityCmplnOccurFactorDeductPop() {
		return "common/popup/mpds/sellerMpDsQualityCmplnOccurFactorDeductPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsInspDetailItemPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsInspDetailItemPop() {
		return "common/popup/mpds/sellerMpDsInspDetailItemPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsOrderObtnodrReceiptPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsOrderObtnodrReceiptPop() {
		return "common/popup/mpds/sellerMpDsOrderObtnodrReceiptPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsTranStatementCreationPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsTranStatementCreationPop() {
		return "common/popup/mpds/sellerMpDsTranStatementCreationPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsDongbuPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsDongbuPckpaprDesignCropProtectManagePop() {
		return "common/popup/mpds/sellerMpDsDongbuPckpaprDesignCropProtectManagePop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsDongbuPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsDongbuPckpaprDesignSeedManagePop() {
		return "common/popup/mpds/sellerMpDsDongbuPckpaprDesignSeedManagePop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsProductPlanViewPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsProductPlanViewPop() {
		return "common/popup/mpds/sellerMpDsProductPlanViewPop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsPckpaprDesignCropProtectManagePop() {
		return "common/popup/mpds/sellerMpDsPckpaprDesignCropProtectManagePop";
	}

	@RequestMapping(value = "/mpds/showSellerMpDsPckpaprDesignSeedBizManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpDsPckpaprDesignSeedBizManagePop() {
		return "common/popup/mpds/sellerMpDsPckpaprDesignSeedBizManagePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderStandbyOrderReqDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderStandbyOrderReqDetailPop() {
		return "common/popup/mpso/masterMpSoOrderStandbyOrderReqDetailPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoDlvyAgrmntHistoryManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoDlvyAgrmntHistoryManagePop() {
		return "common/popup/mpso/masterMpSoDlvyAgrmntHistoryManagePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoStockApplyPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoStockApplyPop() {
		return "common/popup/mpso/masterMpSoStockApplyPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoHistoryViewPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderInfoHistoryViewPop() {
		return "common/popup/mpso/masterMpSoOrderInfoHistoryViewPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoBuyerLisPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoBuyerLisPop() {
		return "common/popup/mpso/masterMpSoBuyerLisPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTrWarhsngDeletePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTrWarhsngDeletePop() {
		return "common/popup/mpso/masterMpSoTrWarhsngDeletePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTrReleaseDeletePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTrReleaseDeletePop() {
		return "common/popup/mpso/masterMpSoTrReleaseDeletePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoDlvryConfirmDeletePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoDlvryConfirmDeletePop() {
		return "common/popup/mpso/masterMpSoDlvryConfirmDeletePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoAlterBeforePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderInfoAlterBeforePop() {
		return "common/popup/mpso/masterMpSoOrderInfoAlterBeforePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoAlterAfterPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderInfoAlterAfterPop() {
		return "common/popup/mpso/masterMpSoOrderInfoAlterAfterPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderInfoAlterAfterQtyPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderInfoAlterAfterQtyPop() {
		return "common/popup/mpso/masterMpSoOrderInfoAlterAfterQtyPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTeamClassifyPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTeamClassifyPop() {
		return "common/popup/mpso/masterMpSoTeamClassifyPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderDeleteReasonInsPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderDeleteReasonInsPop() {
		return "common/popup/mpso/masterMpSoOrderDeleteReasonInsPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsOrderCreationPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsOrderCreationPop() {
		return "common/popup/mpds/masterMpDsOrderCreationPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsClosingDateChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsClosingDateChoicePop() {
		return "common/popup/mpds/masterMpDsClosingDateChoicePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsDongbuPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsDongbuPckpaprDesignCropProtectManagePop() {
		return "common/popup/mpds/masterMpDsDongbuPckpaprDesignCropProtectManagePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignCropProtectManagePop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignCropProtectManagePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsSeedKindPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsSeedKindPop() {
		return "common/popup/mpds/masterMpDsSeedKindPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsSeedKindMultiPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsSeedKindMultiPop() {
		return "common/popup/mpds/masterMpDsSeedKindMultiPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsSeedProductKindPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsSeedProductKindPop() {
		return "common/popup/mpds/masterMpDsSeedProductKindPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsDongbuPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsDongbuPckpaprDesignSeedManagePop() {
		return "common/popup/mpds/masterMpDsDongbuPckpaprDesignSeedManagePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignSeedManagePop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignSeedManagePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignRejectStatePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignRejectStatePop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignRejectStatePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignRemarkHistoryPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignRemarkHistoryPop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignRemarkHistoryPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsOrderAlterStatePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsOrderAlterStatePop() {
		return "common/popup/mpds/masterMpDsOrderAlterStatePop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsOrderInfoConfirmPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsOrderInfoConfirmPop() {
		return "common/popup/mpds/masterMpDsOrderInfoConfirmPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsProductPlanViewPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsProductPlanViewPop() {
		return "common/popup/mpds/masterMpDsProductPlanViewPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignManageRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignManageRegPop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignManageRegPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsPckpaprDesignManageSeedRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsPckpaprDesignManageSeedRegPop() {
		return "common/popup/mpds/masterMpDsPckpaprDesignManageSeedRegPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsItemResultPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsItemResultPop() {
		return "common/popup/mpds/masterMpDsItemResultPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsQualityCmplnOccurFactorDeductPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsQualityCmplnOccurFactorDeductPop() {
		return "common/popup/mpds/masterMpDsQualityCmplnOccurFactorDeductPop";
	}

	@RequestMapping(value = "/mpds/showMasterMpDsInspDetailItemPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpDsInspDetailItemPop() {
		return "common/popup/mpds/masterMpDsInspDetailItemPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvOdrreqDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvOdrreqDetailPop() {
		return "common/popup/mpiv/commonMpIvOdrreqDetailPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvDestinationInfoPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvDestinationInfoPop() {
		return "common/popup/mpiv/commonMpIvDestinationInfoPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvOrderDetailViewPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvOrderDetailViewPop() {
		return "common/popup/mpiv/commonMpIvOrderDetailViewPop";
	}

	@RequestMapping(value = "/mpso/showBuyerCowayUserBudgetAccountListPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerCowayUserBudgetAccountListPop() {
		return "common/popup/mpso/buyerCowayUserBudgetAccountListPop";
	}

	@RequestMapping(value = "/mpso/showBuyerUserCowayBudgetAccountListPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerUserCowayBudgetAccountListPop() {
		return "common/popup/mpso/buyerUserCowayBudgetAccountListPop";
	}

	@RequestMapping(value = "/mpso/showBuyerUserCowayBudgetOrderListPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerUserCowayBudgetOrderListPop() {
		return "common/popup/mpso/buyerUserCowayBudgetOrderListPop";
	}

	@RequestMapping(value = "/wmgr/showBuyerWmGrCreditCardSalesStatementPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerWmGrCreditCardSalesStatementPop() {
		return "common/popup/wmgr/buyerWmGrCreditCardSalesStatementPop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvObtnodrReceiptDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvObtnodrReceiptDetailPop() {
		return "common/popup/mpiv/sellerMpIvObtnodrReceiptDetailPop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDivsnDeliveryPlanEntryPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvDivsnDeliveryPlanEntryPop_v2";
		} else {
			return "common/popup/mpiv/sellerMpIvDivsnDeliveryPlanEntryPop";
		}
		
		
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvKtagPlanEntryPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvKtagPlanEntryPop() {
		return "common/popup/mpiv/sellerMpIvKtagPlanEntryPop";
	}
	
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliveryDelayReasonPop() {
		return "common/popup/mpiv/sellerMpIvDeliveryDelayReasonPop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWritePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementWritePop() {
		return "common/popup/mpiv/sellerMpIvTranStatementWritePop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementAlterPrintPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementAlterPrintPop() {
		return "common/popup/mpiv/sellerMpIvTranStatementAlterPrintPop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryDelayStateReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliveryDelayStateReasonPop() {
		return "common/popup/mpiv/sellerMpIvDeliveryDelayStateReasonPop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryDelayBuyerChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliveryDelayBuyerChoicePop() {
		return "common/popup/mpiv/sellerMpIvDeliveryDelayBuyerChoicePop";
	}

	@RequestMapping(value = "/mpiv/showSellerMpIvPrewarhsngOrderDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvPrewarhsngOrderDetailPop() {
		return "common/popup/mpiv/sellerMpIvPrewarhsngOrderDetailPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoOrderReceiptDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoOrderReceiptDetailPop() {
		return "common/popup/mpso/masterMpSoOrderReceiptDetailPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTranStatementManualWritePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTranStatementManualWritePop() {
		return "common/popup/mpso/masterMpSoTranStatementManualWritePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTranStatementWritePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTranStatementWritePop() {
		return "common/popup/mpso/masterMpSoTranStatementWritePop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTranStatementDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTranStatementDetailPop() {
		return "common/popup/mpso/masterMpSoTranStatementDetailPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTranStatementWriteSpecBuyerPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTranStatementWriteSpecBuyerPop() {
		return "common/popup/mpso/masterMpSoTranStatementWriteSpecBuyerPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoTranStatementWriteSpecBuyer2Pop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoTranStatementWriteSpecBuyer2Pop() {
		return "common/popup/mpso/masterMpSoTranStatementWriteSpecBuyer2Pop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoPrewarhsngRequestDetailInfoPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoPrewarhsngRequestDetailInfoPop() {
		return "common/popup/mpso/masterMpSoPrewarhsngRequestDetailInfoPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoPrewarhsngRequestRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoPrewarhsngRequestRegPop() {
		return "common/popup/mpso/masterMpSoPrewarhsngRequestRegPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoPrewarhsngRequestAllRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoPrewarhsngRequestAllRegPop() {
		return "common/popup/mpso/masterMpSoPrewarhsngRequestAllRegPop";
	}

	@RequestMapping(value = "/mpso/showMasterMpSoPrewarhsngRequestOrderMapppingPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpSoPrewarhsngRequestOrderMapppingPop() {
		return "common/popup/mpso/masterMpSoPrewarhsngRequestOrderMapppingPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvObtnodrNyreceiptManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvObtnodrNyreceiptManagePop() {
		return "common/popup/mpiv/masterMpIvObtnodrNyreceiptManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvObtnodrNyreceiptLngtermManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvObtnodrNyreceiptLngtermManagePop() {
		return "common/popup/mpiv/masterMpIvObtnodrNyreceiptLngtermManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeadlineDelayForecastManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDeadlineDelayForecastManagePop() {
		return "common/popup/mpiv/masterMpIvDeadlineDelayForecastManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryDelayManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDeliveryDelayManagePop() {
		return "common/popup/mpiv/masterMpIvDeliveryDelayManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeliveryDelayLngtermManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDeliveryDelayLngtermManagePop() {
		return "common/popup/mpiv/masterMpIvDeliveryDelayLngtermManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvBadDelayManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvBadDelayManagePop() {
		return "common/popup/mpiv/masterMpIvBadDelayManagePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvAgntcmpyDeliveryRecordRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvAgntcmpyDeliveryRecordRegPop() {
		return "common/popup/mpiv/masterMpIvAgntcmpyDeliveryRecordRegPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvUrgentManagementPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvUrgentManagementPop() {
		return "common/popup/mpiv/masterMpIvUrgentManagementPop";
	}

	@RequestMapping(value = "/mpgr/showMasterMpGrBuyerNywarhsngManagePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpGrBuyerNywarhsngManagePop() {
		return "common/popup/mpgr/masterMpGrBuyerNywarhsngManagePop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvTranBuyerChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvTranBuyerChoicePop() {
		return "common/popup/mpiv/commonMpIvTranBuyerChoicePop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvTranStatementDetailInfoPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvTranStatementDetailInfoPop() {
		return "common/mpiv/commonMpIvTranStatementDetailInfoPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvTranStatementDetailIKPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvTranStatementDetailIKPop() {
		return "common/mpiv/commonMpIvTranStatementDetailIKPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvTranStatementDetailIVPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showCommonMpIvTranStatementDetailIVPop() {
		return "common/popup/mpiv/commonMpIvTranStatementDetailIVPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvOrderReceiptDelayBuyerChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvOrderReceiptDelayBuyerChoicePop() {
		return "master/mpiv/masterMpIvOrderReceiptDelayBuyerChoicePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDeadlineDelayForecastBuyerChoicePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDeadlineDelayForecastBuyerChoicePop() {
		return "master/mpiv/masterMpIvDeadlineDelayForecastBuyerChoicePop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvMultiDeliveryPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvMultiDeliveryPop() {
		return "master/mpiv/masterMpIvMultiDeliveryPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDelayReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDelayReasonPop() {
		return "master/mpiv/masterMpIvDelayReasonPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvTranDetailTotalPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvTranDetailTotalPop() {
		return "master/mpiv/masterMpIvTranDetailTotalPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvScmActionDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvScmActionDetailPop() {
		return "master/mpiv/masterMpIvScmActionDetailPop";
	}

	@RequestMapping(value = "/mpiv/showMasterMpIvDivsnDeliveryPlanAlterPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMpIvDivsnDeliveryPlanAlterPop() {
		return "master/mpiv/masterMpIvDivsnDeliveryPlanAlterPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvBuyerOrderDetailInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvBuyerOrderDetailInfoPop() {
		return "common/mpiv/commonMpIvBuyerOrderDetailInfoPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvBuyerClosingAmtPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvBuyerClosingAmtPop() {
		return "common/mpiv/commonMpIvBuyerClosingAmtPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvBuyerTotalPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvBuyerTotalPop() {
		return "common/mpiv/commonMpIvBuyerTotalPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDeliveryStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDeliveryStatusPop() {
		return "common/mpiv/commonMpIvDeliveryStatusPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvOrderDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvOrderDetailPop() {
		return "common/popup/mpiv/commonMpIvOrderDetailPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvOrderDetailInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvOrderDetailInfoPop() {
		return "common/mpiv/commonMpIvOrderDetailInfoPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvOrderInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvOrderInfoPop() {
		return "common/popup/mpiv/commonMpIvOrderInfoPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvOrderInfoCheckPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvOrderInfoCheckPop() {
		return "common/mpiv/commonMpIvOrderInfoCheckPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDlvryInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDlvryInfoPop() {
		return "common/mpiv/commonMpIvDlvryInfoPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDlvryChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDlvryChoicePop() {
		return "common/mpiv/commonMpIvDlvryChoicePop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDepartmentTotalAPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDepartmentTotalAPop() {
		return "common/mpiv/commonMpIvDepartmentTotalAPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvReasonPop() {
		return "common/mpiv/commonMpIvReasonPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDetailSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDetailSearchPop() {
		return "common/mpiv/commonMpIvDetailSearchPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDetailInvoiceCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDetailInvoiceCreationPop() {
		return "common/popup/mpiv/commonMpIvDetailInvoiceCreationPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvInvoiceDetailIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvInvoiceDetailIKPop() {
		return "common/popup/mpiv/commonMpIvInvoiceDetailIKPop";
	}

	@RequestMapping(value = "/mpiv/showCommonMpIvInvoiceDetailIVPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvInvoiceDetailIVPop() {
		return "common/popup/mpiv/commonMpIvInvoiceDetailIVPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvRequestInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvRequestInfoPop() {
		return "common/mpiv/commonMpIvRequestInfoPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvHistoryViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvHistoryViewPop() {
		return "common/mpiv/commonMpIvHistoryViewPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvWarehousingDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvWarehousingDetailPop() {
		return "common/mpiv/commonMpIvWarehousingDetailPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvAgrmntDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvAgrmntDetailPop() {
		return "common/mpiv/commonMpIvAgrmntDetailPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvMbrCmpyUserSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvMbrCmpyUserSearchPop() {
		return "common/mpiv/commonMpIvMbrCmpyUserSearchPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDistributionProgressPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDistributionProgressPop() {
		return "common/mpiv/commonMpIvDistributionProgressPop";
	}
	
	@RequestMapping(value = "/mpiv/showCommonMpIvDlvryCarPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonMpIvDlvryCarPop() {
		return "common/popup/mpiv/commonMpIvDlvryCarPop";
	}
	
	@RequestMapping(value = "/wmco/showMasterWmCoTranBuyerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoTranBuyerPop() {
		return "common/popup/wmco/masterWmCoTranBuyerPop";
	}
	
	@RequestMapping(value = "/wmco/showMasterWmCoSupplyGoodsPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoSupplyGoodsPop() {
		return "common/popup/wmco/masterWmCoSupplyGoodsPop";
	}
	
	@RequestMapping(value = "/wmco/showMasterWmCoGoodsCodePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoGoodsCodePop() {
		return "common/popup/wmco/masterWmCoGoodsCodePop";
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrWarehousingNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrWarehousingNoPop() {
		return "common/popup/wmgr/masterWmGrWarehousingNoPop";
	}

	@RequestMapping(value = "/wmgr/showMasterWmGrIntervalsInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrIntervalsInfoPop() {
		return "common/popup/wmgr/masterWmGrIntervalsInfoPop";
	}
	
	@RequestMapping(value = "/wmdl/showMasterWmGrIntervalsInfoAllPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrIntervalsInfoAllPop() {
		return "common/popup/wmdl/masterWmDlIntervalsInfoPop";
	}

	@RequestMapping(value = "/wmdl/showMasterDlCommpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterDlCommpyPop() {
		return "common/popup/masterDlCommpyPop";
	}
	
	@RequestMapping(value = "/wmgr/showMasterWmGrStockGrDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrStockGrDetailPop() {
		return "common/popup/wmgr/masterWmGrStockGrDetailPop";
	}
	
	@RequestMapping(value = "/wmgr/showMasterWmGrStockOrderGrRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrStockOrderGrRegPop() {
		return "common/popup/wmgr/masterWmGrStockOrderGrRegPop";
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiOrderNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiOrderNoPop() {
		return "common/popup/wmgi/masterWmGiOrderNoPop";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiCartRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiCartRegPop() {
		return "common/popup/wmgi/masterWmGiCartRegPop";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiReleaseTransPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiReleaseTransPop() {
		return "common/popup/wmgi/masterWmGiReleaseTransPop";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiLegacyNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiLegacyNoPop() {
		return "common/popup/wmgi/masterWmGiLegacyNoPop";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmGiDstbtrPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiDstbtrPop() {
		return "common/popup/wmgi/masterWmGiDstbtrPop";
	}
	
	@RequestMapping(value = "/wmgi/showMasterWmIvkConfirmDeletePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmIvkConfirmDeletePop() {
		return "common/popup/wmgi/masterWmIvkConfirmDeletePop";
	}

	@RequestMapping(value = "/wmgi/showMasterWmGiDaehanBarcodeReportPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiDaehanBarcodeReportPop() {
		return "common/popup/wmgi/masterWmGiDaehanBarcodeReportPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStLocationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStLocationPop() {
		return "common/popup/wmst/masterWmStLocationPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStDailyReleaseListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStDailyReleaseListPop() {
		return "common/popup/wmst/masterWmStDailyReleaseListPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStDailyBlncingaccntListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStDailyBlncingaccntListPop() {
		return "common/popup/wmst/masterWmStDailyBlncingaccntListPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStLocationRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStLocationRegPop() {
		return "common/popup/wmst/masterWmStLocationRegPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStAssmblDirectionsCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStAssmblDirectionsCreationPop() {
		return "common/popup/wmst/masterWmStAssmblDirectionsCreationPop";
	}

	@RequestMapping(value = "/wmst/showMasterWmStAssmblCmpntsttmntCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmStAssmblCmpntsttmntCreationPop() {
		return "common/popup/wmst/masterWmStAssmblCmpntsttmntCreationPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoWmsNoticePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoWmsNoticePop() {
		return "common/popup/wmco/masterWmCoWmsNoticePop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoReturnLisPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoReturnLisPop() {
		return "common/popup/wmco/masterWmCoReturnLisPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoWmsNoticeMorePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoWmsNoticeMorePop() {
		return "common/popup/wmco/masterWmCoWmsNoticeMorePop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyPop() {
		return "common/popup/wmco/masterWmCoMbrcmpyPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyCountPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyCountPop() {
		return "common/popup/wmco/masterWmCoMbrcmpyCountPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyCountSinglePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyCountSinglePop() {
		return "common/popup/wmco/masterWmCoMbrcmpyCountSinglePop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyIKPop() {
		return "common/popup/wmco/masterWmCoMbrcmpyIKPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoBuyerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoBuyerPop() {
		return "common/popup/wmco/masterWmCoBuyerPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoDlvryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoDlvryPop() {
		return "common/popup/wmco/masterWmCoDlvryPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmReturnReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReturnReasonPop() {
		return "common/popup/wmco/masterWmReturnReasonPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoRequestPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoRequestPop() {
		return "common/popup/wmco/masterWmCoRequestPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoDateGetPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoDateGetPop() {
		return "common/popup/wmco/masterWmCoDateGetPop";
	}

	@RequestMapping(value = "/wmco/showMasterWmCoTranStatementPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoTranStatementPop() {
		return "common/popup/wmco/masterWmCoTranStatementPop";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryPop() {
		return "common/popup/wmre/masterWmReReturnEntryPop";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnEntrySellerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntrySellerPop() {
		return "common/popup/wmre/masterWmReReturnEntrySellerPop";
	}

	@RequestMapping(value = "/wmre/showMasterWmReReturnPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnPop() {
		return "common/popup/wmre/masterWmReReturnPop";
	}
	
	@RequestMapping(value = "/wmre/showMasterWmReDetailPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReDetailPop_v2(ModelMap pModel ,@RequestParam Map<String, String> pMap) {	
		return "common/popup/wmre/masterWmReDetailPop_v2";
	}
	
	@RequestMapping(value = "/wmre/showMasterWmAddUserPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmAddUserPop() {
		return "common/popup/wmre/masterWmAddUserPop";
	}
	
	@RequestMapping(value = "/wmre/showMasterWmBuyerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmBuyerPop() {
		return "common/popup/wmre/masterWmBuyerPop";
	}
	
	@RequestMapping(value = "/wmre/showMasterWmReExchangeEntryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReExchangeEntryPop() {
		return "common/popup/wmre/masterWmReExchangeEntryPop";
	}
	
	@RequestMapping(value = "/wmre/showMasterWmReOrderNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReOrderNoPop() {
		return "common/popup/wmre/masterWmReOrderNoPop";
	}
	
	@RequestMapping(value = "/cmcl/showMasterCmClCmmntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClCmmntPop() {
		return "common/popup/cmcl/masterCmClCmmntPop";
	}
	
	@RequestMapping(value = "/cmcl/showMasterCmClTaxamntAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClTaxamntAlterPop() {
		return "common/popup/cmcl/masterCmClTaxamntAlterPop";
	}
	
	@RequestMapping(value = "/cmcl/showMasterCmClTaxamntAlterApPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClTaxamntAlterApPop() {
		return "common/popup/cmcl/masterCmClTaxamntAlterApPop";
	}
	
	@RequestMapping(value = "/cmcl/showMasterCmClRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClRemarkPop() {
		return "common/popup/cmcl/masterCmClRemarkPop";
	}
	
	@RequestMapping(value = "/cmco/showMasterCmCoBuyerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmCoBuyerPop() {
		return "common/popup/cmco/masterCmCoBuyerPop";
	}
	
	@RequestMapping(value = "/cmco/showMasterCmCoBuyerAgntcmpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmCoBuyerAgntcmpyPop() {
		return "common/popup/cmco/masterCmCoBuyerAgntcmpyPop";
	}
	

	@RequestMapping(value = "/cmco/showMasterCmCoSelectboxSettingComboPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmCoSelectboxSettingComboPop() {
		return "common/popup/cmco/masterCmCoSelectboxSettingComboPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfOrderAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfOrderAlterPop() {
		return "common/popup/mpif/masterMpIfOrderAlterPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfOrderAlterDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfOrderAlterDetailPop() {
		return "common/popup/mpif/masterMpIfOrderAlterDetailPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfCatalogAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfCatalogAlterPop() {
		return "common/popup/mpif/masterMpIfCatalogAlterPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfOrderStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfOrderStatusPop() {
		return "common/popup/mpif/masterMpIfOrderStatusPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfOrderTypePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfOrderTypePop() {
		return "common/popup/mpif/masterMpIfOrderTypePop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfSourcingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfSourcingPop() {
		return "common/popup/mpif/masterMpIfSourcingPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfSourcingStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfSourcingStatusPop() {
		return "common/popup/mpif/masterMpIfSourcingStatusPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfWarehousingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfWarehousingPop() {
		return "common/popup/mpif/masterMpIfWarehousingPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfWarehousingStatePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfWarehousingStatePop() {
		return "common/popup/mpif/masterMpIfWarehousingStatePop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfOrderNoSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfOrderNoSearchPop() {
		return "common/popup/mpif/masterMpIfOrderNoSearchPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfDlvrysttmntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfDlvrysttmntPop() {
		return "common/popup/mpif/masterMpIfDlvrysttmntPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfDlvrysttmntStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfDlvrysttmntStatusPop() {
		return "common/popup/mpif/masterMpIfDlvrysttmntStatusPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfBefrPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfBefrPop() {
		return "common/popup/mpif/masterMpIfBefrPop";
	}
	
	@RequestMapping(value = "/mpif/showMasterMpIfRequestNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIfRequestNoPop() {
		return "common/popup/mpif/masterMpIfRequestNoPop";
	}
	
	@RequestMapping(value = "/mdap/showNewPassRecvList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showNewPassRecvList(HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		boolean getCauFlag = CommonUtil.getSpecialCheckReturn(sessionInfo.getComCode(), "P06-0000107");
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", sessionInfo.getUserId(), sessionInfo.getComCode());
		
		if(getCauFlag == true){
			return "common/approval/buyerCauNewPassRecvList";
		} else if(getMultiApprFlag == true) {
			return "common/approval/buyerNewMultiPassRecvList";
		} else {
			return "common/approval/buyerNewPassRecvList";
		}
	}
	
	@RequestMapping(value = "/mdap/showNewPassCompleteList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showNewPassCompleteList(HttpServletRequest request) {
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", sessionInfo.getUserId(), sessionInfo.getComCode());
		if(getMultiApprFlag == true) {
			return "common/approval/buyerNewMultiPassCompleteList";
		} else {
			return "common/approval/buyerNewPassCompleteList";
		}
		
	}
	
	@RequestMapping(value = "/mdap/showNewPassSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showNewPassSendList() {
		return "common/approval/buyerNewPassSendList";
	}
	
	@RequestMapping(value = "/common/popup/approval/buyerCommonPassStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String buyerCommonPassStatusPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/approval/buyerCommonPassStatusPop_v2";
		} else {
			return "common/popup/approval/buyerCommonPassStatusPop";
		}
		
	}
	
	@RequestMapping(value = "/common/popup/approval/buyerCommonDeptStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String buyerCommonDeptStatusPop() {
		return "common/popup/approval/buyerCommonDeptStatusPop";
	}
	
	@RequestMapping(value = "/common/popup/approval/buyerCommonItemStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String buyerCommonItemStatusPop() {
		return "common/popup/approval/buyerCommonItemStatusPop";
	}
	
	@RequestMapping(value = "/common/popup/approval/buyerCommonMyPagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String buyerCommonMyPagePop() {
		return "common/popup/approval/buyerCommonMyPagePop";
	}
	
	@RequestMapping(value = "/common/popup/approval/approvalHumanEditPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String approvalHumanEditPop(HttpServletRequest request,ModelMap pModel) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			Map<String,String> tmpMap = new HashMap<String,String>();
			SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			tmpMap.put("USER_ID",_sessionInfo.getUserId());
			List<Map<String,String>> _dataList = commonApprovalService.getApprovalLine_v2(tmpMap);		  // 결재라인 결재선
			
			pModel.addAttribute("approvalLine", _dataList);	
			return "common/popup/approvalHumanEditPop_v2";
		} else {
			return "common/popup/approvalHumanEditPop";
		}
	}
	
	@RequestMapping(value = "/common/popup/approval/approvalHanwhaHumanEditPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String approvalHanwhaHumanEditPop(HttpServletRequest request,ModelMap pModel) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			Map<String,String> tmpMap = new HashMap<String,String>();
			SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			tmpMap.put("USER_ID",_sessionInfo.getUserId());
			List<Map<String,String>> _dataList = commonApprovalService.getApprovalLine_v2(tmpMap);		  // 결재라인 결재선
			
			pModel.addAttribute("approvalLine", _dataList);	
			return "common/popup/approvalHanwhaHumanEditPop_v2";
		}else{
			return "common/popup/approvalHanwhaHumanEditPop";
		}
		
	}
	
	@RequestMapping(value = "/common/showBigImageViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBigImageViewPop() {
		return "common/popup/bigImageViewPop";
	}
	
	@RequestMapping(value = "/mpcl/showSellerMpClTranBuyerChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClTranBuyerChoicePop() {
		return "common/popup/mpcl/sellerMpClTranBuyerChoicePop";
	}
	
	@RequestMapping(value = "/mpcl/showSellerMpClGoodsDetailInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClGoodsDetailInfoPop() {
		return "common/popup/mpcl/sellerMpClGoodsDetailInfoPop";
	}
	
	@RequestMapping(value = "/mpcl/showSellerMpClImageViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpClImageViewPop() {
		return "common/popup/mpcl/sellerMpClImageViewPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmPromotionMarketCatalogPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmPromotionMarketCatalogPop() {
		return "common/popup/mdcm/masterMdCmPromotionMarketCatalogPop";
	}
	
	@RequestMapping(value = "/home/showBuyerHomeGoodsRegFormPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerHomeGoodsRegFormPop() {
		return "common/popup/home/buyerHomeGoodsRegFormPop";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoHongikAccntngItemPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoHongikAccntngItemPop() {
		return "common/popup/mpso/buyerMpSoHongikAccntngItemPop";
	}
	
	@RequestMapping(value = "/mdcm/showMasterMdCmPromotionMarketCatalogSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmPromotionMarketCatalogSelPop() {
		return "common/popup/mdcm/masterMdCmPromotionMarketCatalogSelPop";
	}
	
	@RequestMapping(value = "/mpiv/showSellerMpIvMkImScheduleRegDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvMkImScheduleRegDetailPop() {
		return "common/popup/mpiv/sellerMpIvMkImScheduleRegDetailPop";
	}
	
	@RequestMapping(value = "/mpiv/showMasterMpIvMkImScheduleRegDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpIvMkImScheduleRegDetailPop() {
		return "common/popup/mpiv/masterMpIvMkImScheduleRegDetailPop";
	}
	
	// 미마감 발주상세 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtCreditDeptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtCreditDeptPop() {
		return "common/popup/mdct/masterMdCtCreditDeptPop";
	}
	
	// 장기재고 상세 팝업
	@RequestMapping(value = "/mpst/showMasterMpStLongTermStckDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpStLongTermStckDetailPop() {
		return "common/popup/mpst/masterMpStLongTermStckDetailPop";
	}
	//
	@RequestMapping(value = "/coco/showCommonCoCoNoticeListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showCommonCoCoNoticeListPop() {
		return "common/popup/coco/commonCoCoNoticeListPop";
	}
	
	// 납품실적등록 엑셀업로드
	@RequestMapping(value = "/mpiv/showSellerMpIvExcelUploadPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvExcelUploadPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvExcelUploadPop_v2";
		} else {
			return "common/popup/mpiv/sellerMpIvExcelUploadPop";
		}
		
	}
	// 납품실적등록 일괄등록
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRecordRegMultiPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryRecordRegMultiPop_v2() {
		return "common/popup/mpiv/sellerMpIvDeliveryRecordRegMultiPop_v2";
	}
	//사용자지정 복수
	@RequestMapping(value = "/mdam/showBuyerMdAmUserSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMdAmUserSelPop() {
		return "common/popup/userSelChoicePop";
	}
	//마감기준설정 회원사담당자추가.
	@RequestMapping(value = "/cmcl/showMasterCmClStndSettingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClStndSettingPop() {
		return "common/popup/cmcl/masteCmClStndStndSettingPop";
	}
	//마감 수정사유 추가.
	@RequestMapping(value = "/cmcl/showMasterCmClStndModifySettingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClStndModifySettingPop() {
		return "common/popup/cmcl/masteCmClStndModifySettingPop";
	}
	//마감기준설정 회원사담당자추가.
	@RequestMapping(value = "/cmcl/showMasterCmClIssueIdInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClIssueIdInfoPop() {
		return "common/popup/cmcl/masterCmClIssueIdInfoPop";
	}
	// 카테고리 추천 팝업 추가
	@RequestMapping(value = "/mprq/showMasterMpRqKepStndrdCategoryRcmdPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqKepStndrdCategoryRcmdPop() {
		return "common/popup/mprq/masterMpRqKepStndrdCategoryRcmdPop";
	}
	//표준카탈로그 조회
	@RequestMapping(value = "/mprq/showMasterMpRqStndCatalgListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqStndCatalgListPop() {
		return "common/popup/mprq/masterMpRqStndCatalgListPop";
	}
	//표준카탈로그 등록
	@RequestMapping(value = "/mprq/showMasterMpRqStndCatalgRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqStndCatalgRegPop() {
		return "common/popup/mprq/masterMpRqStndCatalgRegPop";
	}
	//SG선택팝업
	@RequestMapping(value = "/mprq/showMasterMpRqSgChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSgChoicePop() {
		return "common/popup/mprq/masterMpRqSgChoicePop";
	}
	// 장바구니 관리번호 팝업(조회조건 4개)
	@RequestMapping(value = "/mpso/showBuyerMpSoRefPrNoInfoPop4cond.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoRefPrNoInfoPop4cond() {
		return "common/popup/mpso/buyerMpSoRefPrNoInfoPop4cond";
	}
	// 반품관리 > 반품일괄종결 > TR 일괄출고방법 팝업
	@RequestMapping(value = "/wmre/showMasterWmReReturnEndAllPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEndAllPop() {
		return "common/popup/wmre/masterWmReReturnEndAllPop";
	}
	// 협력사 납품관리 > 선입고 납품 관리 > 선입고 요청 등록 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvPrewarhsngOrderRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvPrewarhsngOrderRegPop() {
		return "common/popup/mpiv/sellerMpIvPrewarhsngOrderRegPop";
	}
	//카탈로그매핑관리 >카테고리별 해당 속성.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmscategAttb.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmscategAttb() {
		return "common/popup/mdcm/masterMdCmCmscategAttbPop";
	}
	//품목보완요청 차수이력 팝업
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsComplementHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsComplementHistoryPop() {
		return "common/popup/mdcm/masterMdCmCmsComplementHistoryPop";
	}
	// 채권팝업
	@RequestMapping(value = "/mdct/showMasterMdCtCreditInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtCreditInfoPop() {
		return "common/popup/mdct/masterMdCtCreditInfoPop";
	}
	// 여신 고객사코드 매핑
	@RequestMapping(value = "/clmg/showMasterClMgCreditCmpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditCmpyPop() {
		return "common/popup/clmg/masterClMgCreditCmpyPop";
	}
	// 카탈로그 추천 팝업 추가
	@RequestMapping(value = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqCmsCatlgRcmdPop() {
		return "common/popup/mprq/masterMpRqCmsCatlgRcmdPop";
	}
	// 채권고객사매핑팝업
	@RequestMapping(value = "/clmg/showMasterClMgCreditDeptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditDeptPop() {
		return "common/popup/clmg/masterClMgCreditDeptPop";
	}
	// 여신한도매핑팝업
	@RequestMapping(value = "/clmg/showMasterClMgCreditBondPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgCreditBondPop() {
		return "common/popup/clmg/masterClMgCreditBondPop";
	}
	// 여신한도 예외팝업
	@RequestMapping(value = "/clmg/showMasterClMgBondExcpPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterClMgBondExcpPop() {
		return "common/popup/clmg/masterClMgBondExcpPop";
	}
	// 다중입력 조회조건 팝업
	@RequestMapping(value = "/common/multiSearchCondPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String multiSearchCondPop() {
		return "common/popup/commonMultiSearchCondPop";
	}
	//
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationStoATimePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationStoATimePop() {
		return "common/popup/mprq/masterMpRqQuotationStoATimePop";
	}
	//카탈로그 단종/삭제 사유 팝업
	@RequestMapping(value = "/common/catlgCloseDelReasonPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String catlgCloseDelReasonPop() {
		return "common/popup/catlgCloseDelReasonPop";
	}
	
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderPrRemarkInsPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoOrderPrRemarkInsPop() {
		return "common/popup/mppo/buyerMpPoOrderPrRemarkInsPop";
	}
	//출고지시 및 거래명세표 (요청번호별)
	@RequestMapping(value = "/wmgi/showMasterWmGiReleasePrPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiReleasePrPop() {
		return "common/popup/wmgi/masterWmGiReleasePrPop";
	}
	//잠재고객 등록 팝업
	@RequestMapping(value = "/mdct/showMasterMdctNewCustomerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdctNewCustomerPop() {
		return "common/popup/mdct/masterMdctNewCustomerPop";
	}
	// 고객사 예산조회 팝업
	@RequestMapping(value = "/home/showBuyerHomeDeptBudgetPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerHomeDeptBudgetPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/home/buyerHomeDeptBudgetPop_v2";
		}else {
			return "common/popup/home/buyerHomeDeptBudgetPop";
		}
	}
	//단가이력 팝업
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogUnitPriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogUnitPriceHistoryPop() {
		return "common/popup/mdcm/masterMdCmCatalogUnitPriceHistoryPop";
	}
	//결재정보 팝업
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogApprInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogApprInfoPop() {
		return "common/popup/mdcm/masterMdCmCatalogApprInfoPop";
	}
	//물질정보 입력
	@RequestMapping(value = "/mdct/showSellerMdCtChemicalMatRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMdCtChemicalMatRegPop() {
		return "common/popup/mdct/sellerMdCtChemicalMatRegPop";
	}
	//견적제출시 계약번호 멀티 입력 팝업
	@RequestMapping(value = "/common/mprq/masterMpRqGroupContractLisPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String masterMpRqGroupContractLisPop() {
		return "common/popup/mprq/masterMpRqGroupContractLisPop";
	}
	//일괄출고지시 고객사 선택 팝업
	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyBpIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyBpIKPop() {
		return "common/popup/wmco/masterWmCoMbrcmpyBpIKPop";
	}
	//재계약 이력 팝업
	@RequestMapping(value = "/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotationUnitpriceHistoryPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpcl/sellerMpClCatalogRechaterHistoryPop_v2";
		} else {
			return "common/popup/mpcl/sellerMpClCatalogRechaterHistoryPop";
		}
	}
	//유니폼 신청 유니폼 선택 팝업
	@RequestMapping(value = "/mpso/showBuyerMpSoUniformChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpSoUniformChoicePop() {
		return "common/popup/mpso/buyerMpSoUniformChoicePop";
	}
	//유니폼 요청상세 팝업
	@RequestMapping(value = "/mpso/showMasterMpSoUniformDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoUniformDetailPop() {
		return "common/popup/mpso/masterMpSoUniformDetailPop";
	}
	//유니폼 요청상세 결재반려 의견 팝업
	@RequestMapping(value = "/mpso/showMasterMpSoUniformAprvRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoUniformAprvRemarkPop() {
		return "common/popup/mpso/masterMpSoUniformAprvRemarkPop";
	}
	@RequestMapping(value = "/wmco/showMasterWmCoMbrcmpyNewIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoMbrcmpyNewIKPop() {
		return "common/popup/wmco/masterWmCoMbrcmpyNewIKPop";
	}
	//차파트너스 출고 업로드 팝업
	@RequestMapping(value = "/mpst/showBuyerMpStGiExcelUpload.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpStGiExcelUpload() {
		return "common/popup/mpst/buyerMpStGiExcelUpload";
	}
	//업체선정 및 견적제출 화면에서 일괄 추가라운드 요청 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationSelectedRoundPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationSelectedRoundPop() {
		return "common/popup/mprq/masterMpRqQuotationSelectedRoundPop";
	}
	//대표제조사등록팝업
	@RequestMapping(value = "/mdam/showMasterMdAmMgMakerManageRegPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showMasterMdAmMgMakerManageRegPop() {
		return "common/popup/mdam/MasterMdAmMgMakerManageRegPop";
	}
	//최저가 예외 업체 선정 사유
	@RequestMapping(value = "/mprq/showMasterMpRqSouringBidExceptReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSouringBidExceptReasonPop() {
		return "common/popup/mprq/masterMpRqSouringBidExceptReasonPop";
	}
	//품목정비 차수 이력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqItemMdReqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqItemMdReqHistPop() {
		return "common/popup/mprq/masterMpRqItemMdReqHistPop";
	}
	//특이사항 입력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqQutationRemark.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQutationRemark() {
		return "common/popup/mprq/masterMpRqQutationRemarkPop";
	}
	//카탈로그 등록 차수 팝업
	@RequestMapping(value = "/mdcm/showMasterMdCmCatalogRegRevisionPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCatalogRegRevisionPop() {
		return "common/popup/mdcm/masterMdCmCatalogRegRevisionPop";
	}
	//VOC 차수 팝업
	@RequestMapping(value = "/mpvo/showMasterMpVoVocHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpVoVocHistPop() {
		return "common/popup/mpvo/masterMpVoVocHistPop";
	}
	//고객사 프로파일 등록 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerProfilePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtBuyerProfilePop() {
		return "common/popup/mdct/masterMdCtBuyerProfilePop";
	}
	//리포트 관리 팝업
	@RequestMapping(value = "/mdct/showMasterMdcReportCustomerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdcReportCustomerPop() {
		return "common/popup/mdct/masterMdctReportCustomerPop";
	}
	// 삼양사 네고의뢰  상태 팝업
	@RequestMapping(value = "/mprq/showBuyerMpRqSamyangNegoViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqSamyangNegoViewPop() {
		return "common/popup/mprq/buyerMpRqSamyangNegoViewPop";
	}	
	//거래현황 상세 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtReportSalesPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String masterMdCtReportSalesPop() {
		return "common/popup/mdct/masterMdCtReportSalesPop";
	}
	//계약신규 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtReportSalesNewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String masterMdCtReportSalesNewPop() {
		return "common/popup/mdct/masterMdCtReportSalesNewPop";
	}
	//sg품목별 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtReportSalesSgPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtReportSalesSgPop() {
		return "common/popup/mdct/masterMdCtReportSalesSgPop";
	}
	//고객사 카테고리 품목별 팝업(대분류)
	@RequestMapping(value = "/mdct/showMasterMdCtReportSalesCaPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtReportSalesCaPop() {
		return "common/popup/mdct/masterMdCtReportSalesCaPop";
	}
	//납기,견적관리 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtReportSalesDeRePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtReportSalesDeRePop() {
		return "common/popup/mdct/masterMdCtReportSalesDeRePop";
	}
	//추가정비 차수 이력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqAfterItemMdReqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqAfterItemMdReqHistPop() {
		return "common/popup/mprq/masterMpRqAfterItemMdReqHistPop";
	}
	//역발행 메일 요청 팝업
	@RequestMapping(value = "/cmcl/showMasterCmClsendApRMailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClsendApRMailPop() {
		return "common/popup/cmcl/masterCmClsendApRMailPop";
	}
	//거래유형 변경요청 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvProcessTypeChangePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvProcessTypeChangePop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvProcessTypeChangePop_v2";
		} else {
			return "common/popup/mpiv/sellerMpIvProcessTypeChangePop";
		}
		
	}
	//수주거부 요청 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRejectReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliveryRejectReasonPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvDeliveryRejectReasonPop_v2";
		} else {
			return "common/popup/mpiv/sellerMpIvDeliveryRejectReasonPop";
		}
	}
	
	//수주접수 초기화요청 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvIvInfoChangePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvIvInfoChangePop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvIvInfoChangePop_v2";
		} else {
			return "common/popup/mpiv/sellerMpIvIvInfoChangePop";
		}
	}
	//납품예정일 변경 요청 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvDsDateChangePop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDsDateChangePop(HttpServletRequest request) {
		return "common/popup/mpiv/sellerMpIvDsDateChangePop_v2";
	}
	
	//납품이슈현황 요청사항 상세 팝업(공통)
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliChangeReqDetailPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliChangeReqDetailPop_v2() {
		return "common/popup/mpiv/sellerMpIvDeliChangeReqDetailPop_v2";
	}
	
	//거래유형 변경 상세 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvProcessTypeChangeDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvProcessTypeChangeDetailPop() {
		return "common/popup/mpiv/sellerMpIvProcessTypeChangeDetailPop";
	}
	
	//납품예정일 변경 상세 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvDsDateChangeDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDsDateChangeDetailPop() {
		return "common/popup/mpiv/sellerMpIvDsDateChangeDetailPop";
	}
	
	//수주거부 상세 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRejectDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDeliveryRejectDetailPop() {
		return "common/popup/mpiv/sellerMpIvDeliveryRejectDetailPop";
	}
	
	//납품정보 변경 상세 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvIvInfoChangeDetailPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvIvInfoChangeDetailPop() {
		return "common/popup/mpiv/sellerMpIvIvInfoChangeDetailPop";
	}
	
	// 재계약신규 고객사 상세 팝업
	@RequestMapping(value = "/mdct/showMasterMdCtNewReBuyerDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCtNewReBuyerDetailPop() {
		return "common/popup/mdct/masterMdCtNewReBuyerDetailPop";
	}
	
	// 협력사 DM 발송
	@RequestMapping(value = "/mdcm/showMasterMdcmAgentDmSendPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterAgentDmSendPop() {
		return "common/popup/mdcm/masterMdCmAgentDmSendPop";
	}

	// 협력사 DM메일 미리보기
	@RequestMapping(value = "/mdcm/showMasterMdCmAgentDmPreviewPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterAgentDmPreviewPop() {
		return "common/popup/mdcm/masterMdCmAgentDmPreviewPop";
	}
	
	// 협력사 연락처 설정
	@RequestMapping(value = "/mdcm/showMasterMdCmAgentContactMngPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterAgentContactMngPop() {
		return "common/popup/mdcm/masterMdCmAgentContactMngPop";
	}
	
	// 협력사 연락처 관리 - 협력사 이력관리
	@RequestMapping(value = "/mdcm/showMasterMdCmAgentContactHistoryPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterContactHistoryPop() {
		return "common/popup/mdcm/masterMdCmAgentContactHistoryPop";
	}
	
	// 협력사 DM 수신처 정보 조회
	@RequestMapping(value = "/mdcm/showMasterMdCmAgentDmContactListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmAgentDmContactListPop() {
		return "common/popup/mdcm/masterMdCmAgentDmContactListPop";
	}
	
	// 협력사 DM 발송 내용 조회
	@RequestMapping(value = "/mdcm/showMasterMdCmAgentDmSendHistoryDetailPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmAgentDmSendHistoryDetailPop() {
		return "common/popup/mdcm/masterMdCmAgentDmSendHistoryDetailPop";
	}
	
	// 네고정비 차수 이력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqNegoItemMdReqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqNegoItemMdReqHistPop() {
		return "common/popup/mprq/masterMpRqNegoItemMdReqHistPop";
	}
	
	//SG지정 이력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqSgDHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqSgDHistPop() {
		return "common/popup/mprq/masterMpRqSgDHistPop";
	}
	
	// 견적 정비요청 DM 발송
	@RequestMapping(value = "/mdcm/showMasterMpRqQuotationDmSendPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpRqQuotationDmSendPop() {
		return "common/popup/mprq/masterMpRqQuotationDmSendPop";
	}
	
	// 견적 정비요청 DM 발송 미리보기
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationDmPreviewPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterQuotationDmPreviewPop() {
		return "common/popup/mprq/masterMpRqQuotationDmPreviewPop";
	}
	
	// DM발송 이력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqQuotationDmRemindHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqQuotationDmRemindHistPop() {
		return "common/popup/mprq/masterMpRqQuotationDmRemindHistPop";
	}
	
	// 물류수수료율 저장 및 삭제 팝업
	@RequestMapping(value = "/cmcl/showMasterCmClLogisRateMngReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterCmClLogisRateMngReasonPop() {
		return "common/popup/cmcl/masterCmClLogisRateMngReasonPop";
	}
		
	// 주문진행 DM 미리보기
	@RequestMapping(value = "/mpso/showMasterMpSoProgressDmPreviewPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMpSoProgressDmPreviewPop() {
		return "common/popup/mpso/masterMpSoProgressDmPreviewPop";
	}
	
	// WMS TR다중출고지시
	@RequestMapping(value = "/wmgi/showMasterWmGiMultiReleaseTransPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiMultiReleaseTransPop() {
		return "common/popup/wmgi/masterWmGiMultiReleaseTransPop";
	}
	
	// WMS 간선다중출고지시
	@RequestMapping(value = "/wmgi/showMasterWmGiMultiHubReleaseTransPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiMultiHubReleaseTransPop() {
		return "common/popup/wmgi/masterWmGiMultiHubReleaseTransPop";
	}
	
	//견적상세팝업-리뉴얼
	@RequestMapping(value = "/mprq/showSellerMpRqQuotaDetailPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqQuotaDetailPop_v2() {
		return "common/popup/mprq/sellerMpRqQuotaDetailPop_v2";
	}
	
	//납품구분,납품예정일,지연사유 일괄등록 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvDsDateDelayReasonMultiPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvDsDateDelayReasonMultiPop_v2() {
		return "common/popup/mpiv/sellerMpIvDsDateDelayReasonMultiPop_v2";
	}
	
	// 세금계산서 상세조회
	@RequestMapping(value = "/cmcl/showMasterCmClTaxBillNoDetailPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterCmClTaxBillNoDetailPop() {
		return "common/popup/cmcl/masterCmClTaxBillNoDetailPop";
	}
	
	// 벌크소싱 프로젝트 중단 사유 입력 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationAbortReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationAbortReasonPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationAbortReasonPop";
	}
	
	// 벌크소싱 프로젝트 신규등록 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationNewProjectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationRegPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationNewProjectPop";
	}	
	
	// 벌크소싱 프로젝트 조회 및 수정 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationDetailPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationDetailPop";
	}
	
	// 벌크소싱 프로젝트 조회 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationSelProjectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationSelProjectPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationSelProjectPop";
	}
	
	// 벌크소싱 SG 수정(엑셀 업로드) 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationSgChangePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationSgChangePop() {
		return "common/popup/mprq/masterMpRqBulkQuotationSgChangePop";
	}
	
	// 벌크소싱 일괄담당자 등록(엑셀 업로드) 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationMngRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationMngRegPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationMngRegPop";
	}
	
	// 벌크소싱 품목등록 (엑셀 업로드) 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationItemRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationItemRegPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationItemRegPop";
	}
	
	// 벌크소싱 견적요청 협력사 추가(엑셀 업로드) 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationAddAgentExcelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationAddAgentExcelPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationAddAgentExcelPop";
	}
	
	// 벌크소싱 견적요청 KeP품목정보 등록 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationItemInfoRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationItemInfoRegPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationItemInfoRegPop";
	}
	
	// 벌크소싱 견적요청 협력사 선택 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationSelAgentPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationSelAgentPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationSelAgentPop";
	}
	
	// 벌크소싱 협력사 DM 발송 팝업
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationDmSendPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationDmSendPop() {
		return "common/popup/mprq/masterMpRqBulkQuotationDmSendPop";
	}
	
	// 협력사 벌크견적 요청 접수 단가 업로드
	@RequestMapping(value = "/mprq/showSellerBulkQuotationPriceRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerBulkQuotationPriceRegPop() {
		return "common/popup/mprq/sellerMpRqBulkQuotationPriceRegPop";
	}
	
	// 협력사 벌크견적 요청 견젹 포기 사유 입력 팝업
	@RequestMapping(value = "/mprq/showSellerMpRqBulkQuotationGiveUpReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpRqBulkQuotationGiveUpReasonPop() {
		return "common/popup/mprq/sellerMpRqBulkQuotationGiveUpReasonPop";
	}
	
	
	// 금액미통제 예산 계정 선택 팝업(결재 상세)
	@RequestMapping(value = "/mpso/showBuyerMpSoChangeAccountPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoChangeAccountPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoChangeAccountPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoChangeAccountPop";
		}
	}
	
	// 장바구니 품목별 구매사유 입력 팝업
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderPrReasonPop.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoOrderPrReasonPop() {
		return "common/popup/mppo/buyerMpPoOrderPrReasonPop";
	}
	
	// 고객사 네고요청 시 단가, 요청사항 입력 팝업
	@RequestMapping(value = "/mprq/showBuyerMpRqNegoReqPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqNegoReqPop_v2() {
		return "common/popup/mprq/buyerMpRqNegoReqPop_v2";
	}
	
	// 고객사 견적등록 엑셀업로드_v2
	@RequestMapping(value = "/mprq/showBuyerMpRqExcelUploadPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqExcelUploadPop_v2() {
		return "common/popup/mprq/buyerMpRqExcelUploadPop_v2";
	}
	
	// 고객사 상품등록여부_v2
	@RequestMapping(value = "/mprq/showBuyerMpRqCatalogRegYnPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerMpRqCatalogRegYnPop_v2() {
		return "common/popup/mprq/buyerMpRqCatalogRegYnPop_v2";
	}
	//주문요청처리 > 수령희망일 변경 팝업
	@RequestMapping(value = "/mppo/showBuyerMpPoChangeRdDate_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoChangeRdDate_v2() {
		return "common/popup/mppo/buyerMpPoChangeRdDate_v2";
	}
	//주문요청처리 > 부서이관 팝업 
	@RequestMapping(value = "/mppo/showBuyerMpPoTransferDept_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpPoTransferDept_v2() {
		return "common/popup/mppo/buyerMpPoTransferDept_v2";
	}
	//고객사 관리팝업 공통
	@RequestMapping(value = "/common/showBuyerRefPrNoPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerRefPrNoPop_v2(@RequestParam Map<String, String> pMap,ModelMap pModel) {
		String formType = pMap.get("st_form");
		String popType = pMap.get("st_pop_type");
		String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
		String cond0 = "";
		String cond1 = "";
		String cond2 = "";
		String cond3 = "";
		String cond4 = "";
		
		String cond1_name = "";
		String cond2_name = "";
		String cond3_name = "";
		String cond4_name = "";
		
		String st_cond1_id = "";
		String st_cond1_empno = "";
		String st_cond2_id = "";
		String st_cond2_empno = "";
		String st_cond3_number = "";
		String st_cond4_reason = "";
		
		if(!"".equals(st_ref_no)){
			String st_ref_no_arr[] = st_ref_no.split("\\^", -1);
			
			if(formType.equals("FORM2")){
				cond1 = st_ref_no_arr[0];
				cond2 = st_ref_no_arr[1];
				cond3 = st_ref_no_arr[2];
				cond4 = st_ref_no_arr[3];
				pMap.put("st_code", cond1);
				cond1_name = commonRefPrNoPopupService.getDeptName(pMap);
				pMap.put("st_code", cond2);
				cond2_name = commonRefPrNoPopupService.getDeptName(pMap);
				pMap.put("st_code", cond3);
				cond3_name = commonRefPrNoPopupService.getAccountName(pMap);
				
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
				pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
				pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
				pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
				pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
				pModel.addAttribute("cond4_code", CommonUtil.nvl(cond4));
			}else if(formType.equals("FORM4")){
				cond1 = st_ref_no_arr[0];
				cond1_name = st_ref_no_arr[1];
				
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
			}else if(formType.equals("FORM5")){
				cond0 = st_ref_no_arr[0]; 
				cond1 = st_ref_no_arr[1];
				cond2 = st_ref_no_arr[2];
				cond3 = st_ref_no_arr[3];
				cond4 = st_ref_no_arr[4];
							
				pMap.put("st_type", "C020");
				pMap.put("st_code", cond2);
				cond2_name = commonRefPrNoPopupService.getCod2Text1(pMap);
				
				pMap.put("st_code", cond3);
				cond3_name = commonRefPrNoPopupService.getAccountName(pMap); // buyerMpSoLotteFoodPop-sql.xml 의 selectAccountName 사용
				
				pMap.put("st_type", "C022");
				pMap.put("st_code", cond4);
				cond4_name = commonRefPrNoPopupService.getCod2Text1(pMap);
				
				pModel.addAttribute("cond0_code", CommonUtil.nvl(cond0));
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
				pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
				pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
				pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
				pModel.addAttribute("cond4_code", CommonUtil.nvl(cond4));
				pModel.addAttribute("cond4_name", CommonUtil.nvl(cond4_name));
				pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("st_remark")));
			}else if(formType.equals("FORM6")){
				cond0 = st_ref_no_arr[0]; 
				cond1 = st_ref_no_arr[1];
				
				pModel.addAttribute("cond0_code", CommonUtil.nvl(cond0));
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
			}else if(formType.equals("FORM7")){
				cond1 = st_ref_no_arr[0];
				cond2 = st_ref_no_arr[1];
				cond3 = st_ref_no_arr[2];
				
				pMap.put("st_code", cond1);
				cond1_name = commonRefPrNoPopupService.getPlantCode(pMap);
				pMap.put("st_code", cond2);
				cond2_name = commonRefPrNoPopupService.getCostCode(pMap);
				pMap.put("st_code", cond3);
				cond3_name = commonRefPrNoPopupService.getAccountCode(pMap);
				
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
				pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
				pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
				pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
				pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
				pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("st_remark")));
			}else if(formType.equals("FORM8")){
				st_cond1_id = st_ref_no_arr[0];
				st_cond1_empno = st_ref_no_arr[1];
				st_cond2_id = st_ref_no_arr[2];
				st_cond2_empno = st_ref_no_arr[3];
				st_cond3_number = st_ref_no_arr[4];
				st_cond4_reason = st_ref_no_arr[5];
				
				pMap.put("st_cond1_id", st_cond1_id);
				pMap.put("st_cond1_empno", st_cond1_empno);
				pMap.put("st_cond2_id", st_cond2_id);
				pMap.put("st_cond2_empno", st_cond2_empno);
				pMap.put("st_cond3_number", st_cond3_number);
				pMap.put("st_cond4_reason", st_cond4_reason);
				
				pModel.addAttribute("st_cond1_id", CommonUtil.nvl(st_cond1_id));
				pModel.addAttribute("st_cond1_empno", CommonUtil.nvl(st_cond1_empno));
				pModel.addAttribute("st_cond2_id", CommonUtil.nvl(st_cond2_id));
				pModel.addAttribute("st_cond2_empno", CommonUtil.nvl(st_cond2_empno));	
				pModel.addAttribute("st_cond3_number", CommonUtil.nvl(st_cond3_number));
				pModel.addAttribute("st_cond4_reason", CommonUtil.nvl(st_cond4_reason));	
				pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("cond1")));
			}else if(formType.equals("FORM9")){
				List<Map<String, String>> _data = commonRefPrNoPopupService.getCod2CodeText1(pMap);
				pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
				
			}else if(formType.equals("FORM10")){
				cond1 = st_ref_no_arr[0];
				cond2 = st_ref_no_arr[1];
				pMap.put("st_code", cond1);
				cond1_name = commonRefPrNoPopupService.getAccountCode(pMap);
				pMap.put("st_code", cond2);
				cond2_name = commonRefPrNoPopupService.getCostCode(pMap);
				
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
				pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
				pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
			}else if(formType.equals("FORM11")){
				
			}else if(formType.equals("FORM12")){
				cond1 = st_ref_no_arr[0];
				cond2 = st_ref_no_arr[1];
				cond3 = st_ref_no_arr[2];
				pMap.put("st_code", cond1);
				cond1_name = commonRefPrNoPopupService.getAccountCode(pMap);
				pMap.put("st_code", cond2);
				cond2_name = commonRefPrNoPopupService.getCostCode(pMap);
				cond3_name = cond3.equals("K") ? "K" : "저장품";
				
				pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
				pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
				pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
				pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
				pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
				pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
			}
		}else{
			pModel.addAttribute("cond0_code", cond0);
			pModel.addAttribute("cond1_code", cond1);
			pModel.addAttribute("cond1_name", cond1_name);
			pModel.addAttribute("cond2_code", cond2);
			pModel.addAttribute("cond2_name", cond2_name);
			pModel.addAttribute("cond3_code", cond3);
			pModel.addAttribute("cond3_name", cond3_name);
			pModel.addAttribute("cond4_code", cond4);
			pModel.addAttribute("cond4_name", cond4_name);
			
			pModel.addAttribute("st_cond1_id", st_cond1_id);
			pModel.addAttribute("st_cond1_empno", st_cond1_empno);
			pModel.addAttribute("st_cond2_id", st_cond2_id);
			pModel.addAttribute("st_cond2_empno", st_cond2_empno);	
			pModel.addAttribute("st_cond3_number", st_cond3_number);
			pModel.addAttribute("st_cond4_reason", st_cond4_reason);	
			pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("cond1")));
			
			if(formType.equals("FORM9")){
				List<Map<String, String>> _data = commonRefPrNoPopupService.getCod2CodeText1(pMap);
				pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0));
			}else if(formType.equals("FORM13")) {
				pModel.addAttribute("popType", popType);
			}
		}
		
		
		//form별로 jsp분기
		if(!formType.equals("")) {
			return "common/popup/buyerRefPrNoPop_"+formType+"_v2";
		}else {
			return "common/popup/buyerRefPrNoPop_Text_v2";
		}
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartUploadPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showBuyerMpSoCartUploadPop_v2() {
		return "common/popup/mpso/buyerMpSoCartUploadPop_v2";
	}
	

	// 상품정보 변경이력 (팝업)
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemHistoryPop() {
		return "common/popup/mdcm/masterMdCmCmsItemHistoryPop";
	}

	// 기준가 변경이력 (팝업)
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemBasePriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemBasePriceHistoryPop() {
		return "common/popup/mdcm/masterMdCmCmsItemBasePriceHistoryPop";
	}

	// 상품정보코드 상태변경 (팝업)
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemStatusChangePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemStatusChangePop() {
		return "common/popup/mdcm/masterMdCmCmsItemStatusChangePop";
	}

	// 구매정보 변경이력 (팝업)
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoHistoryPop() {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoHistoryPop";
	}

	// 구매정보코드 상태변경 (팝업) - 구매정보 상세의 [변경]
	// 변경 항목은 opener(구매정보 상세팝업).mdcmBuyChangeItems 로 넘어온다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoStatusChangePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoStatusChangePop() {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoStatusChangePop";
	}

	// 고객사 매핑 이관 (팝업) - 구매정보 상세의 [매핑이관]
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoMapMovePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoMapMovePop() {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoMapMovePop";
	}

	// 변경 표준DB 조회 (팝업) - 매핑 이관 팝업의 [표준DB 조회]
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoMapStdSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoMapStdSelPop() {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoMapStdSelPop";
	}
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemCategorySelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemCategorySelPop() {
		return "common/popup/mdcm/masterMdCmCmsItemCategorySelPop";
	}

	// 상품정보 상세분류 복수선택 (팝업) - 조회조건 [상세분류] 돋보기 전용.
	// 바닥 [카테고리조회] 버튼·그리드 [상세분류] 클릭은 위 단일선택 팝업을 그대로 쓴다.
	// 조회는 단일선택 팝업과 같은 MasterMdCmCmsItemCategorySelPopController 가 처리한다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemCategoryMultiSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemCategoryMultiSelPop() {
		return "common/popup/mdcm/masterMdCmCmsItemCategoryMultiSelPop";
	}

	// 구매정보 협력사 복수선택 (팝업)
	// 목록 조회는 /mdcm/getMasterMdCmSellerCmpyMultiSelPopList.do (MasterMdCmSellerCmpyMultiSelPopController)가 JSON 으로 처리한다.
	// 기존 단건 팝업(masterMdCmSellerCmpyChoicePop)과 공용 팝업(/common/icomcmpyPop.do)은 그대로 둔다.
	@RequestMapping(value = "/mdcm/showMasterMdCmSellerCmpyMultiSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmSellerCmpyMultiSelPop() {
		return "common/popup/mdcm/masterMdCmSellerCmpyMultiSelPop";
	}
	// 상품정보 카테고리(KEPSGMG, 구 SG) 복수선택 (팝업)
	// 목록 조회는 /mdcm/getMasterMdCmCmsItemSgSelPopList.do (MasterMdCmCmsItemSgSelPopController)가 JSON 으로 처리한다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemSgSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemSgSelPop() {
		return "common/popup/mdcm/masterMdCmCmsItemSgSelPop";
	}
	// 상품정보 구매담당자(카테고리(SG) 담당자) 선택 (팝업)
	// 조회는 /common/commonList.do (codeGubun=masterMdCmCmsItemMngrSelPop)가 처리하므로 JSP는 common/popup 바로 아래에 둔다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemMngrSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemMngrSelPop() {
		return "common/popup/masterMdCmCmsItemMngrSelPop";
	}

	// 상품정보 수정요청 반려사유 입력 (팝업)
	// 순수 입력 팝업이다 - 대상 요청번호는 opener 가 들고 있고, 전송도 opener 가 한다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemChangeReqRejectPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemChangeReqRejectPop() {
		return "common/popup/mdcm/masterMdCmCmsItemChangeReqRejectPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingPurchaseDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingPurchaseDetailPop() {
		return "common/popup/mprq/masterMpRqDailySourcingPurchaseDetailPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingBusinessDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingBusinessDetailPop() {
		return "common/popup/mprq/masterMpRqDailySourcingBusinessDetailPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingDbManageDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingDbManageDetailPop() {
		return "common/popup/mprq/masterMpRqDailySourcingDbManageDetailPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingBuyerSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingBuyerSelPop() {
		return "common/popup/mprq/masterMpRqDailySourcingBuyerSelPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingAgentRcmdPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingAgentRcmdPop() {
		return "common/popup/mprq/masterMpRqDailySourcingAgentRcmdPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingTrStdPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingTrStdPop() {
		return "common/popup/mprq/masterMpRqDailySourcingTrStdPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingDupSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingDupSearchPop() {
		return "common/popup/mprq/masterMpRqDailySourcingDupSearchPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingAutoQuotReqPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingAutoQuotReqPop() {
		return "common/popup/mprq/masterMpRqDailySourcingAutoQuotReqPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingAgentSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingAgentSelPop() {
		return "common/popup/mprq/masterMpRqDailySourcingAgentSelPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqMyAgentGroupMngPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqMyAgentGroupMngPop() {
		return "common/popup/mprq/masterMpRqMyAgentGroupMngPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqMyAgentGroupAddPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqMyAgentGroupAddPop() {
		return "common/popup/mprq/masterMpRqMyAgentGroupAddPop";
	}

	@RequestMapping(value = "/mprq/showMasterMpRqDailySourcingEndTimePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqDailySourcingEndTimePop() {
		return "common/popup/mprq/masterMpRqDailySourcingEndTimePop";
	}
	@RequestMapping(value = "/mpso/masterMpSoSellerDiCompanyStockSumPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String masterMpSoSellerDiCompanyStockSumPop_v2() {
		return "common/popup/mpso/masterMpSoSellerDiCompanyStockSumPop_v2";
	}
}
