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

import com.koreab2b.mro.util.CommonUtil;
/**
 * 한컴라이프케어  장바구니 관리번호 선택 팝업
 *
 *
 */
@Controller("buyerMpSoYG1PopController")
public class BuyerMpSoYG1PopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoYG1PopController.class);

//	@Autowired
//	private BuyerMpSoYG1PopService buyerMpSoYG1PopService;
	
	/**
	 * 와이지원 장바구니 관리번호 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoYG1Pop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoYG1Pop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoYG1Pop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
	    
	    String cond0 = "";
	    String cond1 = "";

	    String st_ref_no_arr[] = st_ref_no.split("\\^", -1);
	    
		if(st_ref_no_arr.length == 2){
			
			cond0 = st_ref_no_arr[0]; 
			cond1 = st_ref_no_arr[1];

		}
		
		pModel.addAttribute("cond0_code", CommonUtil.nvl(cond0));
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoYG1Pop";
	}	 
}
