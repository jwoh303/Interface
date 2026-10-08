package com.koreab2b.mro.common.mpif.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpif.service.MasterMpIfOrderStatusPopService;

@Controller("masterMpIfOrderStatusPopController")
public class MasterMpIfOrderStatusPopController {

	@Autowired
	private MasterMpIfOrderStatusPopService masterMpIfOrderStatusPopService;
	
	/**
	 * 발주상태 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpif/getMasterMpIfOrderStatusPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIfOrderStatusPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterMpIfOrderStatusPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
