package com.koreab2b.mro.buyer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmMyGoodsSearchService;
import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqRequestQuotationTempService;
import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqUnitpriceAgrmntNegoReqService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerViewController")
public class BuyerViewController {

	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqService buyerMpRqUnitpriceAgrmntNegoReqService;
	@Autowired
	private BuyerMpRqRequestQuotationTempService buyerMpRqRequestQuotationTempService;
	@Autowired
	private BuyerMdCmMyGoodsSearchService buyerMdCmMyGoodsSearchService;
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;
	
	@RequestMapping(value = "/buyerDetailMain.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerDetailMain() {
		return "buyer/buyerDetailMain";
	}

	@RequestMapping(value = "/include/buyerHeader.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String includeBuyerHeader() {
		return "common/include/buyerHeader";
	}

	@RequestMapping(value = "/include/buyerFooter.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String includeBuyerFooter() {
		return "common/include/buyerFooter";
	}

	@RequestMapping(value = "/mdam/showBuyerMdAmUserInfo.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmUserInfo(HttpServletRequest request,ModelMap pModel) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String passFlag = CommonUtil.nvl(request.getParameter("passFlag"));
			SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			String chg_info_pwd_yn = CommonUtil.nvl(sessionInfo.getChgInfoPwdYn());
			if(chg_info_pwd_yn.equals("Y")){ //비밀번호 인증 필요
				if(passFlag.equals("Y")){ //비밀번호 인증 하고 넘어온 경우
					return "buyer/mdam/buyerMdAmUserInfoList_v2";
				}else{ //비밀번호 인증 안 한 경우
					pModel.addAttribute("user_Id", sessionInfo.getUserId());
					pModel.addAttribute("user_nm", sessionInfo.getUserNameLoc());
					pModel.addAttribute("after_url", "/mdam/showBuyerMdAmUserInfo.do?menuId=br00701000000&passFlag=Y");
					return "redirect:/main/sub_pw_insert.do";
				}
			}
			return "buyer/mdam/buyerMdAmUserInfoList_v2";
		} else {
			return "buyer/mdam/buyerMdAmUserInfoList";
		}
	}

	@RequestMapping(value = "/mdam/showBuyerMdAmCmpyInfo.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmCmpyInfo() {
		return "buyer/mdam/buyerMdAmCmpyInfoList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqSpecReq.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMpRqSpecReq() {
		return "buyer/mprq/buyerMpRqSpecReqList";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqQuotaSourcList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpRqQuotaSourcList() {
		return "buyer/mprq/buyerMpRqQuotaSourcList";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqSpecChkRes.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMpRqSpecChkRes() {
		return "buyer/mprq/buyerMpRqSpecChkResList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqRequestForQuotation.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showBuyerMpRqRequestForQuotation() {
		return "buyer/mprq/buyerMpRqRequestForQuotationList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqRequestQuotationStnd.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showBuyerMpRqRequestQuotationStnd() {
		return "buyer/mprq/buyerMpRqRequestQuotationStndList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqRequestQuotationPcO.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showBuyerMpRqRequestQuotationPcO() {
		return "buyer/mprq/buyerMpRqRequestQuotationPcOList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqRequestQuotationImS.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showBuyerMpRqRequestQuotationImS() {
		return "buyer/mprq/buyerMpRqRequestQuotationImSList";
	}

	@RequestMapping(value = "/mprq/showBuyerMpRqQuotaProceStateList.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String showBuyerMpRqQuotaProceStateList() {
		return "buyer/mprq/buyerMpRqQuotaProceStateList";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqQuotaProceStateAdminList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpRqQuotaProceStateAdminList() {
		return "buyer/mprq/buyerMpRqQuotaProceStateAdminList";
	}
	
	@RequestMapping(value = "/mprq/showbuyer_sourcing_tracking_list60.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showbuyer_sourcing_tracking_list60() {
		return "buyer/mprq/buyer_sourcing_tracking_list60";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqUnitpriceAgrmntNegoReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpRqUnitpriceAgrmntNegoReq() {
		return "buyer/mprq/buyerMpRqUnitpriceAgrmntNegoReqList";
	}
	
	@RequestMapping(value = "/mprq/showBuyerMpRqUnitpriceAgrmntNegoReqMulti.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpRqUnitpriceAgrmntNegoReqMulti() {
		return "buyer/mprq/buyerMpRqUnitpriceAgrmntNegoReqMultiList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmUserSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmUserSearch(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String menuId = pMap.get("menuId");
			SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());

			pModel.addAttribute("tab_data", _data);
			return "buyer/mdam/buyerMdAmUserSearchList_v2";
		}
		return "buyer/mdam/buyerMdAmUserSearchList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmUserRegRequestReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmUserRegRequestReceipt() {
		return "buyer/mdam/buyerMdAmUserRegRequestReceiptList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmCmpyCorpManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmCmpyCorpManage(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "buyer/mdam/buyerMdAmCmpyCorpManageList_v2";
		}
		return "buyer/mdam/buyerMdAmCmpyCorpManageList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmOrderState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmOrderState() {
		return "buyer/mdam/buyerMdAmOrderStateList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmClosingState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmClosingState() {
		return "buyer/mdam/buyerMdAmClosingStateList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmCatalog.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmCatalog() {
		return "buyer/mdam/buyerMdAmCatalogList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetDepartment.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmBudgetDepartment() {
		return "buyer/mdam/buyerMdAmBudgetDepartmentList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmDepartmentAccount.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmDepartmentAccount() {
		return "buyer/mdam/buyerMdAmDepartmentAccountList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetCompilation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmBudgetCompilation() {
		return "buyer/mdam/buyerMdAmBudgetCompilationList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBudget.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmBudget() {
		return "buyer/mdam/buyerMdAmBudgetList";
	}
	
	@RequestMapping(value = "/master/mdam/showBuyerMdAmBudgetDepartment.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterShowBuyerMdAmBudgetDepartment() {
		return "buyer/mdam/buyerMdAmBudgetDepartmentList";
	}
	
	@RequestMapping(value = "/master/mdam/showBuyerMdAmDepartmentAccount.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterShowBuyerMdAmDepartmentAccount() {
		return "buyer/mdam/buyerMdAmDepartmentAccountList";
	}
	
	@RequestMapping(value = "/master/mdam/showBuyerMdAmBudgetCompilation.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterShowBuyerMdAmBudgetCompilation() {
		return "buyer/mdam/buyerMdAmBudgetCompilationList";
	}
	
	@RequestMapping(value = "/master/mdam/showBuyerMdAmBudget.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String masterShowBuyerMdAmBudget() {
		return "buyer/mdam/buyerMdAmBudgetList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmNoticeManageWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmNoticeManageWrite() {
		return "buyer/mdam/buyerMdAmNoticeManageWrite";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBoardManageWrite.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmBoardManageWrite() {
		return "buyer/mdam/buyerMdAmBoardManageWrite";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmGoodsLineState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmGoodsLineState() {
		return "buyer/mdam/buyerMdAmGoodsLineStateList";
	}
	
	@RequestMapping(value = "/mpds/showBuyerMpDsOrderManage.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpDsOrderManage() {
		return "buyer/mpds/buyerMpDsOrderManageList";
	}
	
	@RequestMapping(value = "/mpds/showBuyerMpDsCropProtect.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpDsCropProtect() {
		return "buyer/mpds/buyerMpDsCropProtectList";
	}
	
	@RequestMapping(value = "/mpds/showBuyerMpDsSeed.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpDsSeed() {
		return "buyer/mpds/buyerMpDsSeedList";
	}
	
	@RequestMapping(value = "/mpds/showBuyerMpDsFertiPckmtrl.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpDsFertiPckmtrl() {
		return "buyer/mpds/buyerMpDsFertiPckmtrlList";
	}
	
	@RequestMapping(value = "/mpds/showBuyerMpDsAgrchemiPckmtrl.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpDsAgrchemiPckmtrl() {
		return "buyer/mpds/buyerMpDsAgrchemiPckmtrlList";
	}
	
	@RequestMapping(value = "/mdcm/showBuyerMdCmCategoryGoodsSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmCategoryGoodsSearch(ModelMap pModel) {
		String st_search_gbn = "menu";
		pModel.addAttribute("st_search_gbn",st_search_gbn);
		return "buyer/mdcm/buyerMdCmCategoryGoodsSearchList";
	}
	
	@RequestMapping(value = "/mdcm/showBuyerMdCmAdminCatalogSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmAdminCatalogSearch() {
		return "buyer/mdcm/buyerMdCmAdminCatalogSearchList";
	}
	
	@RequestMapping(value = "/mdcm/showBuyerMdCmCategoryPCOSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmCategoryPCOSearch() {
		return "buyer/mdcm/buyerMdCmCategoryPCOSearchList";
	}
	@RequestMapping(value = "/mdcm/showBuyerMdCmPopularGoodsSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmPopularGoodsSearch() {
		return "buyer/mdcm/buyerMdCmPopularGoodsSearch";
	}
	@RequestMapping(value = "/mdcm/showBuyerMdCmGreenPunchOutSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmGreenPunchOutSearch() {
		return "buyer/mdcm/buyerMdCmGreenPunchOutSearchList";
	}
	@RequestMapping(value = "/mdcm/showBuyerMdCmProjectPunchOutSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmProjectPunchOutSearch() {
		return "buyer/mdcm/buyerMdCmProjectPunchOutSearchList";
	}
	@RequestMapping(value = "/mdcm/showBuyerMdCmDeletePunchOutSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmDeletePunchOutSearch() {
		return "buyer/mdcm/buyerMdCmDeletePunchOutSearch";
	}
	@RequestMapping(value = "/mdcm/showBuyerMdCmGoodsLis.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmGoodsLis() {
		return "buyer/mdcm/buyerMdCmGoodsLisList";
	}
	
	@RequestMapping(value = "/mdcm/showBuyerMdCmHistoryGoodsSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmHistoryGoodsSearch() {
		
		return "buyer/mdcm/buyerMdCmHistoryGoodsSearchList";
	}
	
	@RequestMapping(value = "/mdcm/showBuyerMdCmMyGoodsSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdCmMyGoodsSearch() {
		return "buyer/mdcm/buyerMdCmMyGoodsSearchList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCart.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCart() {
		return "buyer/mpso/buyerMpSoCartList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoDlvryInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoDlvryInfo() {
		return "buyer/mpso/buyerMpSoDlvryInfoList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoDlvryInfoCowayList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoDlvryInfoCowayList() {
		return "buyer/mpso/buyerMpSoDlvryInfoCowayList";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoOrderInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoOrderInfo() {
		return "buyer/mpso/buyerMpSoOrderInfoList";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoCartMyungWha.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartMyungWha() {
		return "buyer/mpso/buyerMpSoCartMyungWhaList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartCoway.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartCoway() {
		return "buyer/mpso/buyerMpSoCartCowayList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartHongik.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartHongik() {
		return "buyer/mpso/buyerMpSoCartHongikList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoOrderDetailHongik.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoOrderDetailHongik() {
		return "buyer/mpso/buyerMpSoOrderDetailHongikList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartUpload.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartUpload() {
		return "buyer/mpso/buyerMpSoCartUploadList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoDeliveryCommingPunchOutSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoDeliveryCommingPunchOutSearch() {
		return "buyer/mpso/buyerMpSoDeliveryCommingPunchOutSearchList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoDeliveryDelayPunchOutSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoDeliveryDelayPunchOutSearch() {
		return "buyer/mpso/buyerMpSoDeliveryDelayPunchOutSearchList";
	}
	
	
	@RequestMapping(value = "/mpso/showBuyerMpSoOrderProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoOrderProgress(HttpServletRequest request, ModelMap pModel,@RequestParam Map<String, String> pMap) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String menuId = pMap.get("menuId");
			SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
			
			pModel.addAttribute("tab_data", _data);
			return "buyer/mpso/buyerMpSoOrderProgressList_v2";
		}else{
			return "buyer/mpso/buyerMpSoOrderProgressList";
		}
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoOrderAdminProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoOrderAdminProgress() {
		return "buyer/mpso/buyerMpSoOrderAdminProgressList";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoReturnReq.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoReturnReq() {
		return "buyer/mpso/buyerMpSoReturnReqList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoDelayDlvyState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoDelayDlvyState() {
		return "buyer/mpso/buyerMpSoDelayDlvyStateList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoReturnProceState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoReturnProceState() {
		return "buyer/mpso/buyerMpSoReturnProceStateList";
	}
	
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderReqReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpPoOrderReqReceipt() {
		return "buyer/mppo/buyerMpPoOrderReqReceiptList";
	}
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderHongikReqReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpPoOrderHongikReqReceipt() {
		return "buyer/mppo/buyerMpPoOrderHongikReqReceiptList";
	}
	
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderReqReject.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpPoOrderReqReject() {
		return "buyer/mppo/buyerMpPoOrderReqRejectList";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoOrderHold.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpPoOrderHold() {
		return "buyer/mppo/buyerMpPoOrderHoldList";
	}

	@RequestMapping(value = "/mppo/showBuyerMpPoOrderProgress.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpPoOrderProgress() {
		return "buyer/mppo/buyerMpPoOrderProgressList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmCategory.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmCategory() {
		return "buyer/mdam/buyerMdAmCategoryList";
	}

	@RequestMapping(value = "/wmgr/showBuyerWmGrWarehousingReg.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerWmGrWarehousingReg() {
		return "buyer/wmgr/buyerWmGrWarehousingRegList";
	}
	
	@RequestMapping(value = "/wmgr/showBuyerWmGrWarehousingLis.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerWmGrWarehousingLis() {
		return "buyer/wmgr/buyerWmGrWarehousingLisList";
	}
	
	@RequestMapping(value = "/wmgr/showBuyerWmGrWarehousingLisDetailSearch.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerWmGrWarehousingLisDetailSearch() {
		return "buyer/wmgr/buyerWmGrWarehousingLisDetailSearch";
	}

	@RequestMapping(value = "/wmgr/showBuyerWmGrClosing.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerWmGrClosing(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String menuId = pMap.get("menuId");
			SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
			pModel.addAttribute("tab_data", _data);
			return "buyer/wmgr/buyerWmGrClosingList_v2";
		}
		return "buyer/wmgr/buyerWmGrClosingList";
	}
	
	@RequestMapping(value = "/mdct/showSellerMdCtUserRegRequestReceipt.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showSellerMdCtUserRegRequestReceipt() {
		return "seller/mdct/sellerMdCtUserRegRequestReceiptList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStReleaseDirections.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStReleaseDirections() {
		return "buyer/mpst/buyerMpStReleaseDirectionsList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStRecinpayState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStRecinpayState() {
		return "buyer/mpst/buyerMpStRecinpayStateList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStStockAdjust.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStStockAdjust() {
		return "buyer/mpst/buyerMpStStockAdjustList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStStockGoods.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStStockGoods() {
		return "buyer/mpst/buyerMpStStockGoodsList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartBudgetCoway.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartBudgetCoway() {
		return "buyer/mpso/buyerMpSoCartCowayBudgetList";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmGiCowayList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmGiCowayList() {
		return "buyer/mdam/buyerMdAmGiCowayList";
	}

	@RequestMapping(value = "/mdam/showBuyerMdAmGiCowayReqList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmGiCowayReqList() {
		return "buyer/mdam/buyerMdAmGiCowayReqList";
	}

	@RequestMapping(value = "/mpso/showBuyerMpSoDelyReturnCowayList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMpSoDelyReturnCowayList() {
		return "buyer/mpso/buyerMpSoDelyReturnCowayList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoNewDoctorBatchRegList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMpSoNewDoctorBatchRegList() {
		return "buyer/mpso/buyerMpSoNewDoctorBatchRegList";
	}
	
	@RequestMapping(value = "/buyer/showBuyerGreenBuy.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerGreenBuy() {
		return "buyer/buyerGreenBuy";
	}	

	@RequestMapping(value = "/mpso/showBuyerMpSoCowayReturnSettingPopup.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMpSoCowayReturnSettingPopup() {
		return "buyer/mpso/buyerMpSoCowayReturnSettingPopup";
	}

	@RequestMapping(value = "/mdam/showBuyerMdAmCatalogCoway.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdAmCatalogCoway() {
		return "buyer/mdam/buyerMdAmCatalogCowayList";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoCartExcelUpload.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoCartExcelUpload() {
		return "buyer/mpso/buyerMpSoCartExcelUploadList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStGiReleaseDirections.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStGiReleaseDirections() {
		return "buyer/mpst/buyerMpStGiReleaseDirections";
	}
	
	@RequestMapping(value = "/mpso/showBuyerMpSoUniformReqList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoUniformReqList() {
		return "buyer/mpso/buyerMpSoUniformReqList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStWarehouseGiList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStWarehouseGiList() {
		return "buyer/mpst/buyerMpStWarehouseGiList";
	}
	
	@RequestMapping(value = "/mpst/showBuyerMpStWarehouseStockList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStWarehouseStockList() {
		return "buyer/mpst/buyerMpStWarehouseStockList";
	}
	// 공지사항 고객공지 상세
	@RequestMapping(value = "/none/showBuyerNoNeNoticeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showBuyerNoNeNoticeDetailPop() {
		return "buyer/none/buyerNoNeNoticeDetailPop";
	}
	// 월간리포트
	@RequestMapping(value = "/mpso/showBuyerMpSoMonthReportList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpSoMonthReportList() {
		return "buyer/mpso/buyerMpSoMonthReportList";
	}
	
	//결재-리뉴얼
	@RequestMapping(value = "/mdap/showBuyerNewPassList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMdApNewPassRecvList_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", sessionInfo.getUserId(), sessionInfo.getComCode());
		
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
		
		pModel.addAttribute("tab_data", _data);
		
		if(getMultiApprFlag == true) {
			pModel.addAttribute("getMultiApprFlag", "Y");
		}
		return "common/approval/buyerNewPassList_v2";
	}
	
	// 견적진행조회- 리뉴얼
	@RequestMapping(value = "/mprq/showBuyerMpRqQuotaList_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMpRqQuotaProceStateList_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
		
		pModel.addAttribute("tab_data", _data);
		
		return "buyer/mprq/buyerMpRqQuotaList_v2";
	}
	
	// 예산기준정보 - 리뉴얼
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetInfo_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMdAmBudgetInfo_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
		
		pModel.addAttribute("tab_data", _data);
		
		return "buyer/mdam/buyerMdAmBudgetInfo_v2";
	}
	
	// 상품 견적 등록_v2
	@RequestMapping(value = "/mprq/showBuyerMpRqRequestQuotation_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMpRqRequestQuotationStnd_v2(HttpServletRequest request, ModelMap pModel,@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_byca_com_code",_sessionInfo.getBycaComorgCode());
		pMap.put("st_query", CommonUtil.onvl(pMap.get("st_query") ,"") );
		String rowCntTmp = CommonUtil.onvl(pMap.get("onepagerow"),_sessionInfo.getRowCnt());
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(rowCntTmp)){
			rowCntTmp = "30";
		}
		pMap.put("onepagerow", rowCntTmp);
	 		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		List<Map<String,String>> _data = buyerMpRqRequestQuotationTempService.getTempSaveList_v2(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		List<Map<String,String>> _data2 = new ArrayList<Map<String,String>>();
		String itemFlag = CommonUtil.onvl(pMap.get("itemFlag"), "N"); //기등록품목 견적이면 데이터 가지고 감
		if(itemFlag.equals("Y")){
			_data2 = buyerMdCmMyGoodsSearchService.getRqdtList(pMap);
			
			pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));
		}
				
		return "buyer/mprq/buyerMpRqRequestQuotationList_v2";
	}
	
	// 예산편성 - 리뉴얼
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetCompilation_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMdAmBudgetCompilation_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
		
		pModel.addAttribute("tab_data", _data);
		
		return "buyer/mdam/buyerMdAmBudgetCompilation_v2";
	}
	
	// 주문요청처리 - 리뉴얼
	@RequestMapping(value = "/mppo/showBuyerMpPoOrderReq_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMpPoOrderReq_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		
		String menuId = pMap.get("menuId");
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
		
		pModel.addAttribute("tab_data", _data);
		
		return "buyer/mppo/buyerMpPoOrderReqList_v2";
	}
	
	// 주문완료 페이지 - 리뉴얼
	@RequestMapping(value = "/mpso/showBuyerMpSoOrderEnd_v2.do", method = { RequestMethod.GET,RequestMethod.POST })
	public String showBuyerMpSoOrderEnd_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		
		List<Map<String, String>> _data = buyerMpSoOrderInfoService.getOrderInfo_v2(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		if(pMap.get("passYn").equals("Y")){ //결재 있는 경우
			List<Map<String, String>> _data2 = buyerMpSoOrderInfoService.getPasslnInfo_v2(pMap);
			pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));
		}
		return "buyer/mpso/buyerMpSoOrderEnd_v2";
	}
}
