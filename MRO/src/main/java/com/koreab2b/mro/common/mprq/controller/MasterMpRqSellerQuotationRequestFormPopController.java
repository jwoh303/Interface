package com.koreab2b.mro.common.mprq.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.MasterMpRqSellerQuotationRequestFormPopService;

@Controller("masterMpRqSellerQuotationRequestFormPopController")
public class MasterMpRqSellerQuotationRequestFormPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqSellerQuotationRequestFormPopController.class);

	@Autowired
	private MasterMpRqSellerQuotationRequestFormPopService masterMpRqSellerQuotationRequestFormPopService;
	
	/**
	 * 협력사별 견적요청서 양식 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqSellerQuotationRequestFormPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerQuotationRequestFormPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqSellerQuotationRequestFormPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
