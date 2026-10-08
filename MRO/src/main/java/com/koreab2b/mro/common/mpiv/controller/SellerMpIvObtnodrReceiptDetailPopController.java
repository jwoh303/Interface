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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.SellerMpIvObtnodrReceiptDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvObtnodrReceiptDetailPopController")
public class SellerMpIvObtnodrReceiptDetailPopController { 

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvObtnodrReceiptDetailPopController.class);

	@Autowired
	private SellerMpIvObtnodrReceiptDetailPopService sellerMpIvObtnodrReceiptDetailPopService;
	
	/**
	 * 수주접수 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrReceiptDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvObtnodrReceiptDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvObtnodrReceiptDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		
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
		
		return "common/popup/mpiv/sellerMpIvObtnodrReceiptDetailPop";
	}
	
	/**
	 * 수주접수 상세 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerMpIvObtnodrReceiptDetailPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2.do 요청 파라미터 for jsp : {}", pMap); 
		
		// 수주접수 상세정보 조회
		List<Map<String, String>> detailInfo = sellerMpIvObtnodrReceiptDetailPopService.getDetailInfo(pMap);
		pModel.addAttribute("detailInfo", (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0));
		
		// 발주서인쇄정보 조회
		List<Map<String, String>> orderRecvHeader = sellerMpIvObtnodrReceiptDetailPopService.getOrderRecvHeader(pMap); 
		pModel.addAttribute("orderRecvHeader", (Map<String,String>)CommonUtil.getListNvl(orderRecvHeader).get(0));
		
		// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
		List<Map<String, String>> specialLogicInfo = sellerMpIvObtnodrReceiptDetailPopService.getSpecialLogicInfo(pMap); 
		pModel.addAttribute("specialLogicInfo", (Map<String,String>)CommonUtil.getListNvl(specialLogicInfo).get(0));
		
		return "common/popup/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2";
	}
	
	/**
	 * 수주접수 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrReceiptDetailPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvObtnodrReceiptDetailPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvObtnodrReceiptDetailPop_v2 요청 파라미터 : {}", pMap);
		
//		Map<String,String> param = new HashMap<String, String>();
//		
//		//Map<String,Object> 를 Map<String,String>으로 변환
//		for(Map.Entry<String, Object> entry : pMap.entrySet()){
//			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
//		}
		
		List<Map<String, String>> _data = sellerMpIvObtnodrReceiptDetailPopService.getDetailList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 수주접수 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvObtnodrReceiptDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do 요청 파라미터 for jsp : {}", pMap); 

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap);
		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvObtnodrReceiptDetailPopService.saveSellerMpIvObtnodrReceiptDetailPop(_pMap, _list);
		
		_response.put("msg", flag);

		return _response;
	}
	
	/**
	 * 물질정보등록
	 * @param pModel
	 * @param pMap
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvChemicalInfo.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvChemicalInfo(ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap);
		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvObtnodrReceiptDetailPopService.saveSellerMpIvChemicalInfo(_pMap,_list);
		
		_response.put("msg", flag);

		return _response;
	}
	
	/**
	 * 수주거부 상품들 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRejectReasonPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRejectReasonPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryRejectReasonPop_v2 요청 파라미터 : {}", pMap);
		
//		Map<String,String> param = new HashMap<String, String>();
//		
//		//Map<String,Object> 를 Map<String,String>으로 변환
//		for(Map.Entry<String, Object> entry : pMap.entrySet()){
//			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
//		}
		
		List<Map<String, String>> _data = sellerMpIvObtnodrReceiptDetailPopService.getDetailList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 수주거부
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvObtnodrReceiptDetailRejectPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvObtnodrReceiptDetailRejectPop(ModelMap pModel, HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvObtnodrReceiptDetailRejectPop.do 요청 파라미터 for jsp : {}", pMap); 

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap);
		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvObtnodrReceiptDetailPopService.saveSellerMpIvObtnodrReceiptDetailRejectPop(_pMap, _list);
		
		_response.put("msg", flag);

		return _response;
	}
}