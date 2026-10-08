package com.koreab2b.mro.common.wmst.controller;

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

import com.koreab2b.mro.common.wmst.service.MasterWmStDailyBlncingaccntListPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmStDailyBlncingaccntListPopController")
public class MasterWmStDailyBlncingaccntListPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmStDailyBlncingaccntListPopController.class);

	@Autowired
	private MasterWmStDailyBlncingaccntListPopService masterWmStDailyBlncingaccntListPopService;
	
	/**
	 * 일일 결산 List 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStDailyBlncingaccntListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterWmStDailyBlncingaccntListPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.removeSlash(pMap);
		
		pMap.put("toYearFirst", pMap.get("st_cur_date").toString().substring(0,4)+"0101" );
		pMap.put("beforeYear", String.valueOf(Integer.parseInt(pMap.get("st_cur_date").toString().substring(0,4))-1)+"12");
		
		
		List<Map<String,String>> _data = masterWmStDailyBlncingaccntListPopService.getList(pMap);
		pModel.addAttribute("_data", CommonUtil.getListNvl(_data));
		
		return "master/wmst/masterWmStDailyBlncingaccntList";
	}
	
	
}
