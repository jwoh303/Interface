package com.koreab2b.mro.common.cmcl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.koreab2b.mro.common.cmcl.service.MasterCmClTaxBillNoDetailPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClTaxBillNoDetailPopController")
public class MasterCmClTaxBillNoDetailPopController {

	@Autowired
	private MasterCmClTaxBillNoDetailPopService masterCmClTaxBillNoDetailPopService;
	
	/**
	 * 세금계산서 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClTaxBillNoDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClTaxBillNoDetailPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterCmClTaxBillNoDetailPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
