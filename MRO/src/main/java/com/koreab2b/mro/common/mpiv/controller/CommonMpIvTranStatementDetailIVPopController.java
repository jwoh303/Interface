package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.SellerMpIvTranStatementAlterPrintPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvTranStatementDetailIVPopController")
public class CommonMpIvTranStatementDetailIVPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvTranStatementDetailIVPopController.class);

//	@Autowired
//	private CommonMpIvTranStatementDetailIVPopService commonMpIvTranStatementDetailIVPopService;
	
	@Autowired
	private SellerMpIvTranStatementAlterPrintPopService sellerMpIvTranStatementAlterPrintPopService;
	
	/**
	 * 거래명세서 상세조회IV 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvTranStatementDetailIVPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvTranStatementDetailIVPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvTranStatementDetailIVPop.do 요청 파라미터 for jsp : {}", pMap);
		
		Map<String,String> detailInfo = sellerMpIvTranStatementAlterPrintPopService.getInfo(pMap);
		
		pModel.addAttribute("info", detailInfo);
		
		// 거래명세서 수정 및 출력 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementAlterPrintPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		pModel.addAllAttributes(pMap);
		
//		List<Map<String, String>> _data = commonMpIvTranStatementDetailIVPopService.getList(pMap); 
//		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/commonMpIvTranStatementDetailIVPop";
	}
	
	//거래명세서 상세조회IV 팝업
	@RequestMapping(value = "/mpiv/commonMpIvTranStatementDetailIVPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String commonMpIvTranStatementDetailIVPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("commonMpIvTranStatementDetailIVPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String,String> detailInfo = sellerMpIvTranStatementAlterPrintPopService.getInfo(pMap);
		
		pModel.addAttribute("info", detailInfo);
		
		pModel.addAllAttributes(pMap);
		
//		List<Map<String, String>> _data = commonMpIvTranStatementDetailIVPopService.getList(pMap); 
//		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/commonMpIvTranStatementDetailIVPop_v2";
	}
	@RequestMapping(value = "/mpiv/commonMpIvTranStatementDetailIVPop_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String commonMpIvTranStatementDetailIVPop_v3(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("commonMpIvTranStatementDetailIVPop_v3 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String,String> detailInfo = sellerMpIvTranStatementAlterPrintPopService.getInfo_v3(pMap);
		
		pModel.addAttribute("info", detailInfo);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvTranStatementDetailIVPop_v3";
	}
	
	/**
	 * 거래명세서 상세조회IV 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvTranStatementDetailIVPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvTranStatementDetailIVPop_v2(ModelMap pModel,HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getCommonMpIvTranStatementDetailIVPop_v2 요청 파라미터 : {}", pMap);
		pModel.addAllAttributes(pMap);
//		Map<String,String> param = new HashMap<String, String>();
		
		//Map<String,Object> 를 Map<String,String>으로 변환
//		for(Map.Entry<String, Object> entry : pMap.entrySet()){
//			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
//		}
		
		List<Map<String, String>> _data = sellerMpIvTranStatementAlterPrintPopService.getCommonMpIvTranStatementDetailIVPop_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
