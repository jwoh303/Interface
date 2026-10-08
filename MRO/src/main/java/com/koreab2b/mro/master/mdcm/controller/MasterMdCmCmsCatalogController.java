package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsCatalogService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsCatalogController")
public class MasterMdCmCmsCatalogController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsCatalogController.class);

	@Autowired
	private MasterMdCmCmsCatalogService masterMdCmCmsCatalogService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsCatalogList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsCatalogList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmCmsCatalogService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCmsCatalogList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCmsCatalogService.getExcelList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 카테고리 속성 리스트 조회
	@RequestMapping(value = "/mdcm/getCategoriAttributeList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCategoriAttributeList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mprq/getCategoriAttributeList.do 요청 파라미터 for jsp : {}", pMap); 
		//Map<String, Object> _response = new HashMap<String, Object>();
		int recCnt = Integer.parseInt(CommonUtil.snvl(masterMdCmCmsCatalogService.getCategoriAttributeListCount(pMap)));
		
		List<Map<String, String>> _data;
		for(int i=1; i<=recCnt; i++){
			pMap.put("SEQ", String.valueOf(i));
			_data = masterMdCmCmsCatalogService.getCategoriAttributeList(pMap);
			
			pModel.addAttribute("data"+i, CommonUtil.getListNvl(_data));
		}
		pModel.addAttribute("count", recCnt);
		pModel.addAttribute("pMap", pMap);
		
		return "master/mdcm/masterMdCmCategoryAttrData";
	}
	
}
