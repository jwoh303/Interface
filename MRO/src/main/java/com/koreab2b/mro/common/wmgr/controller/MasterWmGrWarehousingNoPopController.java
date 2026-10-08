package com.koreab2b.mro.common.wmgr.controller;

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

import com.koreab2b.mro.common.wmgr.service.MasterWmGrWarehousingNoPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrWarehousingNoPopController")
public class MasterWmGrWarehousingNoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrWarehousingNoPopController.class);

	@Autowired
	private MasterWmGrWarehousingNoPopService masterWmGrWarehousingNoPopService;
	
	/**
	 * 거래명세서 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrWarehousingNoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvWarehousingDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvWarehousingDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = masterWmGrWarehousingNoPopService.getList1(pMap); 
		List<Map<String, String>> _data2 = masterWmGrWarehousingNoPopService.getList2(pMap); 
		pModel.addAttribute("data1", CommonUtil.getMapNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 

		return "common/popup/wmgr/masterWmGrWarehousingNoPop";
	}	 	
	
}
