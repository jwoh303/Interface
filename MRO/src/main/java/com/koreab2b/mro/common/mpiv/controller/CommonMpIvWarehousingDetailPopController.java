package com.koreab2b.mro.common.mpiv.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvWarehousingDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvWarehousingDetailPopController")
public class CommonMpIvWarehousingDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvWarehousingDetailPopController.class);

	@Autowired
	private CommonMpIvWarehousingDetailPopService commonMpIvWarehousingDetailPopService;
	
	/**
	 * 입고상세조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvWarehousingDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvWarehousingDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvWarehousingDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = commonMpIvWarehousingDetailPopService.getList1(pMap); 
		List<Map<String, String>> _data2 = commonMpIvWarehousingDetailPopService.getList2(pMap); 
		pModel.addAttribute("data1", CommonUtil.getMapNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 

		return "common/popup/mpiv/commonMpIvWarehousingDetailPop";
	}	 
	
}
