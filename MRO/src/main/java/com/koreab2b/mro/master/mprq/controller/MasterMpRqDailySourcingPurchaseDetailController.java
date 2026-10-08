package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingPurchaseDetailService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqDailySourcingPurchaseDetailController")
public class MasterMpRqDailySourcingPurchaseDetailController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDailySourcingPurchaseDetailController.class);

	@Autowired
	private MasterMpRqDailySourcingPurchaseDetailService masterMpRqDailySourcingPurchaseDetailService;

	@RequestMapping(value = "/mprq/getMasterMpRqDailySourcingPurchaseDetail.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqDailySourcingPurchaseDetail(@RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getMasterMpRqDailySourcingPurchaseDetail.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();

		Map<String, Object> _param = new HashMap<String, Object>();
		_param.put("st_buyer", CommonUtil.nvl(pMap.get("st_buyer")).trim());
		_param.put("st_quotation_no", CommonUtil.nvl(pMap.get("st_quotation_no")).trim());
		_param.put("st_quotation_seq", CommonUtil.nvl(pMap.get("st_quotation_seq")).trim());
		_param.put("st_revision", CommonUtil.nvl(pMap.get("st_revision")).trim());

		if ("".equals(_param.get("st_buyer")) || "".equals(_param.get("st_quotation_no"))
				|| "".equals(_param.get("st_quotation_seq")) || "".equals(_param.get("st_revision"))) {
			_response.put("errMsg", "견적 키가 올바르지 않습니다.");
			return _response;
		}

		_response.put("data", masterMpRqDailySourcingPurchaseDetailService.getDetail(_param));
		return _response;
	}

}
