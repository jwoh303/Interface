package com.koreab2b.mro.common.mpcl.controller;

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

import com.koreab2b.mro.common.mpcl.service.SellerMpClTranBuyerChoicePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClTranBuyerChoicePopController")
public class SellerMpClTranBuyerChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpClTranBuyerChoicePopController.class);

	@Autowired
	private SellerMpClTranBuyerChoicePopService sellerMpClTranBuyerChoicePopService;
	
	/**
	 * 거래고객사선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpcl/getSellerMpClTranBuyerChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClTranBuyerChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpcl/getSellerMpClTranBuyerChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data = sellerMpClTranBuyerChoicePopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mpcl/sellerMpClTranBuyerChoicePop";
	}

	/**
	 * 거래고객사선택  조회 (JSON 리턴)
	 * @param pMap
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/mpcl/getSellerMpClTranBuyerChoicePopJson.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public List<Map<String, String>> getSellerMpClTranBuyerChoicePopJson(
			@RequestParam Map<String, String> pMap,
			HttpServletRequest request) {

		logger.debug("/mpcl/getSellerMpClTranBuyerChoicePopJson.do 요청 파라미터 for json : {}", pMap);

		// 세션에서 협력사 코드 가져오기
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (sessionInfo != null && sessionInfo.getComCode() != null) {
			String comCode = CommonUtil.nvl(pMap.get("com_code"), sessionInfo.getComCode());
			pMap.put("com_code", comCode);
			logger.debug("협력사 코드 설정: {}", comCode);
		} else {
			logger.warn("세션 정보 또는 협력사 코드가 없습니다.");
		}

		List<Map<String, String>> _data = sellerMpClTranBuyerChoicePopService.getList(pMap);
		return CommonUtil.getListNvl(_data);
	}

}
