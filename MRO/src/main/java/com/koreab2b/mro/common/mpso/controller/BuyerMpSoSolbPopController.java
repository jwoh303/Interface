package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.common.mpso.service.BuyerMpSoSolbPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 솔브레인  장바구니 관리번호 선택 팝업
 *
 *
 */
@Controller("buyerMpSoSolbPopController")
public class BuyerMpSoSolbPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoSolbPopController.class);

	@Autowired
	private BuyerMpSoSolbPopService buyerMpSoSolbPopService;
	
	/**
	 * 솔브레인 장바구니 관리번호 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoSolbPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoSolbPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoSolbPop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
	    
	   
	    String cond1 = "";
		String cond2 = "";
		String cond3 = "";
		
		String cond1_name = "";
		String cond2_name = "";
		String cond3_name = "";
		
		String st_ref_no_arr[] = st_ref_no.split("\\^", -1);

		if(st_ref_no_arr.length == 3){
			 
			cond1 = st_ref_no_arr[0];
			cond2 = st_ref_no_arr[1];
			cond3 = st_ref_no_arr[2];
			pMap.put("st_code", cond1);
			cond1_name = buyerMpSoSolbPopService.getSolbPlantCode(pMap);
			pMap.put("st_code", cond2);
			cond2_name = buyerMpSoSolbPopService.getSolbCostCode(pMap);
			pMap.put("st_code", cond3);
			cond3_name = buyerMpSoSolbPopService.getSolbAccountCode(pMap);
			
			
		}
		
		
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
		pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
		pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
		pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));	
		pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
		pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));	
		pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("st_remark")));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoSolbPop";
	}
	
	/**
	 * 솔브레인 입고조회 관리번호 항목 수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/saveBuyerMpSoRefPrNoSolbPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String saveBuyerMpSoRefPrNoSolbPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/saveBuyerMpSoRefPrNoSolbPop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
	    
	   
	    String cond1 = "";
		String cond2 = "";
		String cond3 = "";
		
		String cond1_name = "";
		String cond2_name = "";
		String cond3_name = "";
		
		String st_ref_no_arr[] = st_ref_no.split("\\^", -1);

		if(st_ref_no_arr.length == 3){
			 
			cond1 = st_ref_no_arr[0];
			cond2 = st_ref_no_arr[1];
			cond3 = st_ref_no_arr[2];
			
			pMap.put("st_code", cond1);
			cond1_name = buyerMpSoSolbPopService.getSolbPlantCode(pMap);
			pMap.put("st_code", cond2);
			cond2_name = buyerMpSoSolbPopService.getSolbCostCode(pMap);
			pMap.put("st_code", cond3);
			cond3_name = buyerMpSoSolbPopService.getSolbAccountCode(pMap);
			
			
		}
		
		
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
		pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
		pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
		pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
		pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
		pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
		pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("st_remark")));
 
		return "common/popup/mpso/buyerMpSoRefPrNoSaveSolbPop";
	}	
	
}
