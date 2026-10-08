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

import com.koreab2b.mro.common.mpso.service.BuyerMpSoHancomLCPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 한컴라이프케어  장바구니 관리번호 선택 팝업
 *
 *
 */
@Controller("buyerMpSoHancomLCPopController")
public class BuyerMpSoHancomLCPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoHancomLCPopController.class);

	@Autowired
	private BuyerMpSoHancomLCPopService buyerMpSoHancomLCPopService;
	
	/**
	 * 한컴라이프케어 장바구니 관리번호 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoHancomLCPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoHancomLCPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoHancomLCPop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
	    
	    String cond0 = "";
	    String cond1 = "";
		String cond2 = "";
		String cond3 = "";
		String cond4 = "";

		String cond2_name = "";
		String cond3_name = "";
		String cond4_name = "";
		
		String st_ref_no_arr[] = st_ref_no.split("\\^", -1);

		if(st_ref_no_arr.length == 5){
			
			cond0 = st_ref_no_arr[0]; 
			cond1 = st_ref_no_arr[1];
			cond2 = st_ref_no_arr[2];
			cond3 = st_ref_no_arr[3];
			cond4 = st_ref_no_arr[4];
						
			pMap.put("st_type", "C020");
			pMap.put("st_code", cond2);
			cond2_name = buyerMpSoHancomLCPopService.getText1(pMap);
			
			pMap.put("CODE", cond3);
			cond3_name = buyerMpSoHancomLCPopService.getAccountText1(pMap); // buyerMpSoLotteFoodPop-sql.xml 의 selectAccountName 사용
			
			pMap.put("st_type", "C022");
			pMap.put("st_code", cond4);
			cond4_name = buyerMpSoHancomLCPopService.getText1(pMap);
		}
		
		pModel.addAttribute("cond0_code", CommonUtil.nvl(cond0));
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
		pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
		pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
		pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
		pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
		pModel.addAttribute("cond4_code", CommonUtil.nvl(cond4));
		pModel.addAttribute("cond4_name", CommonUtil.nvl(cond4_name));
		pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("st_remark")));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoHancomLCPop";
	}	 
}
