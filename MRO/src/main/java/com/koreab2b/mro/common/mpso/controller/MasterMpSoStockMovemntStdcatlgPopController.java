package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.MasterMpSoStockMovemntStdcatlgPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoStockMovemntStdcatlgPopController")
public class MasterMpSoStockMovemntStdcatlgPopController {
	
	@Autowired
	private MasterMpSoStockMovemntStdcatlgPopService masterMpSoStockMovemntStdcatlgPopService;
	
	// 조회
		@RequestMapping(value = "/mpso/getMasterMpSoStockMovemntStdcatlgPop.do", method = RequestMethod.POST)
		public String getMasterMpSoStockMovemntStdcatlgPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
			
			//logger.debug("/mdam/getBuyerMdAmUserSearchList.do 요청 파라미터 : {}", pMap);

			// 페이징처리
			pMap = CommonUtil.PagingPrc(pMap);
			
			// 화면 조회
			pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
			List<Map<String, String>> _data = masterMpSoStockMovemntStdcatlgPopService.getList(pMap);
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			
			return "common/popup/mpso/masterMpSoStockMovemntStdcatlgPop";
		}
}
