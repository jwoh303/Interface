package com.koreab2b.mro.common.mpso.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.util.CommonUtil;
/**
 * 한샘  장바구니 실사용자,관리자,품의번호,구매사항 기재 팝업
 */
@Controller("buyerMpSoHansPopController")
public class BuyerMpSoHansPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoHansPopController.class);

	
	/**
	 * 한샘 장바구니 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoHansPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoHansPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoHansPop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));
	   
	    String st_cond1_id = "";
		String st_cond1_empno = "";
		String st_cond2_id = "";
		String st_cond2_empno = "";
		String st_cond3_number = "";
		String st_cond4_reason = "";
		
		String st_ref_no_arr[] = st_ref_no.split("\\^", -1);

		if(st_ref_no_arr.length == 6){
			st_cond1_id = st_ref_no_arr[0];
			st_cond1_empno = st_ref_no_arr[1];
			st_cond2_id = st_ref_no_arr[2];
			st_cond2_empno = st_ref_no_arr[3];
			st_cond3_number = st_ref_no_arr[4];
			st_cond4_reason = st_ref_no_arr[5];
			
			pMap.put("st_cond1_id", st_cond1_id);
			pMap.put("st_cond1_empno", st_cond1_empno);
			pMap.put("st_cond2_id", st_cond2_id);
			pMap.put("st_cond2_empno", st_cond2_empno);
			pMap.put("st_cond3_number", st_cond3_number);
			pMap.put("st_cond4_reason", st_cond4_reason);
		}
		
		pModel.addAttribute("st_cond1_id", CommonUtil.nvl(st_cond1_id));
		pModel.addAttribute("st_cond1_empno", CommonUtil.nvl(st_cond1_empno));
		pModel.addAttribute("st_cond2_id", CommonUtil.nvl(st_cond2_id));
		pModel.addAttribute("st_cond2_empno", CommonUtil.nvl(st_cond2_empno));	
		pModel.addAttribute("st_cond3_number", CommonUtil.nvl(st_cond3_number));
		pModel.addAttribute("st_cond4_reason", CommonUtil.nvl(st_cond4_reason));	
		pModel.addAttribute("st_remark", CommonUtil.nvl(pMap.get("cond1")));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoHansPop";
	}
}
