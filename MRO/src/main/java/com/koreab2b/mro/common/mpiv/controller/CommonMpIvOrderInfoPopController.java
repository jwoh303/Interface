package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvOrderInfoPopService;
import com.koreab2b.mro.common.mpiv.service.SellerMpIvObtnodrReceiptDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvOrderInfoPopController")
public class CommonMpIvOrderInfoPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvOrderInfoPopController.class);

	@Autowired
	private CommonMpIvOrderInfoPopService commonMpIvOrderInfoPopService;
	@Autowired
	private SellerMpIvObtnodrReceiptDetailPopService sellerMpIvObtnodrReceiptDetailPopService;
	
	/**
	 * 발주정보 조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvOrderInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvOrderInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvOrderInfoPop.do 요청 파라미터 for jsp : {}", pMap); 

		// 수주접수 상세정보 조회
		List<Map<String, String>> detailInfo = sellerMpIvObtnodrReceiptDetailPopService.getDetailInfo(pMap);
		pModel.addAttribute("detailInfo", (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0));
		
		// 수주접수 리스트
//		List<Map<String, String>> detailList = sellerMpIvObtnodrReceiptDetailPopService.getDetailList(pMap); 
//		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));
		
		List<Map<String, String>> detailList = commonMpIvOrderInfoPopService.getDetailList(pMap); 
		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));
		
		// 발주서인쇄정보 조회
		List<Map<String, String>> orderRecvHeader = sellerMpIvObtnodrReceiptDetailPopService.getOrderRecvHeader(pMap); 
		pModel.addAttribute("orderRecvHeader", (Map<String,String>)CommonUtil.getListNvl(orderRecvHeader).get(0));
		
		// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
		List<Map<String, String>> specialLogicInfo = sellerMpIvObtnodrReceiptDetailPopService.getSpecialLogicInfo(pMap); 
		pModel.addAttribute("specialLogicInfo", (Map<String,String>)CommonUtil.getListNvl(specialLogicInfo).get(0));
		
		
		return "common/popup/mpiv/commonMpIvOrderInfoPop";
	}	
	
	//발주정보 팝업
	@RequestMapping(value = "/mpiv/commonMpIvOrderInfoPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String commonMpIvOrderInfoPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("commonMpIvOrderInfoPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		// 수주접수 상세정보 조회
		List<Map<String, String>> detailInfo = sellerMpIvObtnodrReceiptDetailPopService.getDetailInfo(pMap);
		pModel.addAttribute("detailInfo", (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0));
		
		// 수주접수 리스트
//		List<Map<String, String>> detailList = sellerMpIvObtnodrReceiptDetailPopService.getDetailList(pMap); 
//		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));
		
//		List<Map<String, String>> detailList = commonMpIvOrderInfoPopService.getDetailList(pMap); 
//		pModel.addAttribute("detailList", CommonUtil.getListNvl(detailList));
		
		// 발주서인쇄정보 조회
		List<Map<String, String>> orderRecvHeader = sellerMpIvObtnodrReceiptDetailPopService.getOrderRecvHeader(pMap); 
		pModel.addAttribute("orderRecvHeader", (Map<String,String>)CommonUtil.getListNvl(orderRecvHeader).get(0));
		
		// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
		List<Map<String, String>> specialLogicInfo = sellerMpIvObtnodrReceiptDetailPopService.getSpecialLogicInfo(pMap); 
		pModel.addAttribute("specialLogicInfo", (Map<String,String>)CommonUtil.getListNvl(specialLogicInfo).get(0));
		
		return "common/popup/mpiv/commonMpIvOrderInfoPop_v2";
	}
	/**
	 * 발주정보 조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvOrderInfoPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvOrderInfoPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getCommonMpIvOrderInfoPop_v2 요청 파라미터 : {}", pMap);
		
		Map<String,String> param = new HashMap<String, String>();
		
		//Map<String,Object> 를 Map<String,String>으로 변환
		for(Map.Entry<String, Object> entry : pMap.entrySet()){
			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
		}
		
		List<Map<String, String>> detailList = commonMpIvOrderInfoPopService.getDetailList(param); 
		
		return IBSheetUtil.addResut(req, detailList , pMap);
	}
}
