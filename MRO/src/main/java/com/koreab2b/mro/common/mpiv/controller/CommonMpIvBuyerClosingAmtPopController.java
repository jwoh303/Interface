package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvBuyerClosingAmtPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvBuyerClosingAmtPopController")
public class CommonMpIvBuyerClosingAmtPopController {

	@Autowired
	private CommonMpIvBuyerClosingAmtPopService commonMpIvBuyerClosingAmtPopService;
	
	/**
	 * 고객사별 마감금액 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerClosingAmtPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerClosingAmtPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		pMap.put("st_tax_bill_no", CommonUtil.nvl(pMap.get("st_tax_bill_no"), ""));

		List<Map<String, String>> _data = commonMpIvBuyerClosingAmtPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mpiv/commonMpIvBuyerClosingAmtPop";
	}

	/**
	 * 고객사별 마감금액 조회 (JSON - 리뉴얼용)
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerClosingAmtList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvBuyerClosingAmtList(@RequestParam Map<String, String> pMap) {

		pMap.put("st_tax_bill_no", CommonUtil.nvl(pMap.get("st_tax_bill_no"), ""));

		List<Map<String, String>> _data = commonMpIvBuyerClosingAmtPopService.getList(pMap);

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("Data", CommonUtil.getListNvl(_data));
		return result;
	}

}
