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

import com.koreab2b.mro.common.mpso.service.BuyerMpSoUniformGrHistoryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoUniformGrHistoryPopController")
public class BuyerMpSoUniformGrHistoryPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpSoUniformGrHistoryPopController.class);

	@Autowired
	private BuyerMpSoUniformGrHistoryPopService buyerMpSoUniformGrHistoryPopService;
	
	/**
	 * 유니폼 선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoUniformGrHistoryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoUniformGrHistoryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getBuyerMpSoUniformGrHistoryPop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data_hd = buyerMpSoUniformGrHistoryPopService.getHdList(pMap);
		List<Map<String, String>> _data_dt = buyerMpSoUniformGrHistoryPopService.getDtList(pMap);
		pModel.addAttribute("data_hd", CommonUtil.getListNvl(_data_hd));
		pModel.addAttribute("data_dt", CommonUtil.getListNvl(_data_dt));
		return "common/popup/mpso/buyerMpSoUniformGrHistoryPop";
	}
}
