package com.koreab2b.mro.buyer.mpso.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoGroupPurchaseService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoGroupPurchaseController")
public class BuyerMpSoGroupPurchaseController {

	@Autowired
	private BuyerMpSoGroupPurchaseService buyerMpSoGroupPurchaseService;

	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoGroupPurchaseList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMpSoGroupPurchaseList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
		// pMap = CommonUtil.PagingPrc(pMap);
		pMap = CommonUtil.removeSlash(pMap);
		// pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, Object>> _data = buyerMpSoGroupPurchaseService.getList(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		return "buyer/mpso/buyerMpSoGroupPurchaseList";
	}
	// 명절선물신청조회
	@RequestMapping(value = "/mpso/getBuyerMpSoHolidayPurchaseList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMpSoHolidayPurchaseList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
		pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, Object>> _data = buyerMpSoGroupPurchaseService.getHolidayList(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		return "buyer/mpso/buyerMpSoHolidayPurchaseList";
	}
	/**
	 * 선택품목반납
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/setBuyerMpSoGroupPurchaseList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setBuyerMpSoGroupPurchaseList(@RequestParam Map<String, String> pMap,
			@RequestParam MultiValueMap<String, String> multiMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = null;
		List<String> checkboxList = multiMap.get("st_checkbox");
		for (String idxString : checkboxList) {
			int idx = Integer.parseInt(idxString);
			paramMap = new HashMap<String, String>();
			paramMap.put("BUYER", _sessionInfo.getComCode());
			paramMap.put("USER_ID", _sessionInfo.getUserId());
			paramMap.put("BUYER_ITEM_NO", multiMap.get("st_buyer_item_no").get(idx));
			paramMap.put("CONTRACT_NO", multiMap.get("st_contract_no").get(idx));
			paramMap.put("CONTRACT_SEQ", multiMap.get("st_contract_seq").get(idx));
			paramMap.put("USE_FLAG", multiMap.get("st_use_flag").get(idx));
			paramMap.put("CART_QTY", multiMap.get("st_req_qty").get(idx));
			paramMap.put("AGENT", multiMap.get("st_agent").get(idx));
			paramMap.put("BYIT_COMORG_CODE", multiMap.get("st_byit_comorg_code").get(idx));
			paramMap.put("REF_PR_NO", multiMap.get("st_ref_pr_no").get(idx));
			paramList.add(paramMap);
		}

		Map<String, String> rtn = new HashMap<String, String>();
		rtn.putAll(buyerMpSoGroupPurchaseService.setGroupPurchase(paramList));
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("msg", rtn);
		return _response;
	}
	
	// 판매인증조회
	@RequestMapping(value = "/mpso/getBuyerMpSoSellerRegList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMpSoSellerRegList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		//그룹코드일경우
		pMap.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
		
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
		pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, Object>> _data = buyerMpSoGroupPurchaseService.getBuyerMpSoSellerRegList(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		return "buyer/mpso/buyerMpSoSellerRegList";
	}
	/**
	 * 판매인증등록
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/setBuyerMpSoSellerRegListdo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setBuyerMpSoSellerRegListdo(@RequestParam Map<String, String> pMap,
			@RequestParam MultiValueMap<String, String> multiMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = null;
		List<String> checkboxList = multiMap.get("st_checkbox");
		for (String idxString : checkboxList) {
			int idx = Integer.parseInt(idxString);
			paramMap = new HashMap<String, String>();
			paramMap.put("BUYER", _sessionInfo.getComCode());
			paramMap.put("USER_ID", _sessionInfo.getUserId());			
			paramMap.put("BUYER_ITEM_NO", multiMap.get("st_buyer_item_no").get(idx));
			paramMap.put("CONTRACT_NO", multiMap.get("st_contract_no").get(idx));
			paramMap.put("CONTRACT_SEQ", multiMap.get("st_contract_seq").get(idx));
			paramMap.put("USE_FLAG", multiMap.get("st_use_flag").get(idx));
			paramMap.put("AGENT", multiMap.get("st_agent").get(idx));
			paramMap.put("BYIT_COMORG_CODE", multiMap.get("st_byit_comorg_code").get(idx));
			paramMap.put("REF_PR_NO", multiMap.get("req_user_id").get(idx));
			paramMap.put("IMAGE_KEY", multiMap.get("st_image_key").get(idx));
			paramList.add(paramMap);
		}

		Map<String, String> rtn = new HashMap<String, String>();
		rtn.putAll(buyerMpSoGroupPurchaseService.setBuyerMpSoSellerRegListdo(paramList));
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("msg", rtn);
		return _response;
	}
}
