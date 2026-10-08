package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvObtnodrReceiptDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderReceiptDetailPopController")
public class MasterMpSoOrderReceiptDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoOrderReceiptDetailPopController.class);
	
	@Autowired
	private SellerMpIvObtnodrReceiptDetailPopService sellerMpIvObtnodrReceiptDetailPopService;
	
	/**
	 * 수주접수 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderReceiptDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoOrderReceiptDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getMasterMpSoOrderReceiptDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		
//		pMap = IBSheetUtil.addParamForPaging3(pMap);
//		List<Map<String,String>> _data = masterMpSoOrderReceiptDetailPopService.getList(pMap);
//		return IBSheetUtil.addResut(req, _data , pMap);
		
		// 수주접수 상세정보 조회
		List<Map<String, String>> detailInfo = sellerMpIvObtnodrReceiptDetailPopService.getDetailInfo(pMap);
		pModel.addAttribute("detailInfo", (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0));
		
		// 수주접수 리스트
		List<Map<String, String>> detailList = sellerMpIvObtnodrReceiptDetailPopService.getDetailList(pMap); 
		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));
		
		// 발주서인쇄정보 조회
		List<Map<String, String>> orderRecvHeader = sellerMpIvObtnodrReceiptDetailPopService.getOrderRecvHeader(pMap); 
		pModel.addAttribute("orderRecvHeader", (Map<String,String>)CommonUtil.getListNvl(orderRecvHeader).get(0));
		
		// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
		List<Map<String, String>> specialLogicInfo = sellerMpIvObtnodrReceiptDetailPopService.getSpecialLogicInfo(pMap); 
		pModel.addAttribute("specialLogicInfo", (Map<String,String>)CommonUtil.getListNvl(specialLogicInfo).get(0));
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpso/masterMpSoOrderReceiptDetailPop";
	}
	
	
}
