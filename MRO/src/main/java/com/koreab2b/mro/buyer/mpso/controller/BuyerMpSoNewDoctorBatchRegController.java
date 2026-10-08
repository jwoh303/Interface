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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoNewDoctorBatchRegService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoNewDoctorBatchRegController")
public class BuyerMpSoNewDoctorBatchRegController {

	@Autowired
	private BuyerMpSoNewDoctorBatchRegService buyerMpSoNewDoctorBatchRegService;

	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoNewDoctorBatchRegList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getBuyerMpSoNewDoctorBatchRegList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
//		pMap = CommonUtil.PagingPrc(pMap);
		pMap = CommonUtil.removeSlash(pMap);
//		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, Object>> _data = buyerMpSoNewDoctorBatchRegService.getList(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		return "buyer/mpso/buyerMpSoNewDoctorBatchRegList";
	}

	/**
	 * 선택품목반납
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/setBuyerMpSoNewDoctorBatchRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setBuyerMpSoNewDoctorBatchRegList(@RequestParam Map<String, String> pMap,
			@RequestParam MultiValueMap<String, String> multiMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = null;
		List<String> noList = multiMap.get("st_no");
		for (String noString : noList) {
			int idx = Integer.parseInt(noString);
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
			paramList.add(paramMap);
		}

		Map<String, String> rtn = new HashMap<String, String>();
		rtn.putAll(buyerMpSoNewDoctorBatchRegService.setNewDoctorCreatePo(paramList));
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("msg", rtn);
		return _response;
	}

	@RequestMapping(value = "/mpso/getNewDoctorList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showMasterMpIvMkImScheduleRegDetailPop() {
		return "buyer/mpso/getNewDoctorList";
	}
}
