package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDetailInvoiceCreationPopService;
import com.koreab2b.mro.util.CommonUtil;

/**
 * 권고발주 상세조회 및 송장생성 (JSON 전용 API)
 * 기존 CommonMpIvDetailInvoiceCreationPopController는 JSP를 반환하므로
 * JSON 응답을 위한 별도 컨트롤러 생성
 */
@Controller("commonMpIvDetailInvoiceCreationPopController_v2")
public class CommonMpIvDetailInvoiceCreationPopController_v2 {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDetailInvoiceCreationPopController_v2.class);

	@Autowired
	private CommonMpIvDetailInvoiceCreationPopService commonMpIvDetailInvoiceCreationPopService;

	/**
	 * 상세조회 (JSON 반환)
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvDetailInvoiceCreationPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvDetailInvoiceCreationPop_v2(@RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDetailInvoiceCreationPop_v2.do 요청 파라미터 : {}", pMap);

		List<Map<String, String>> _data = commonMpIvDetailInvoiceCreationPopService.getList(pMap);

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data", CommonUtil.getListNvl(_data));

		return result;
	}

}
