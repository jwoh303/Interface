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

import com.koreab2b.mro.common.mpso.service.BuyerMpSoLotteFoodPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 롯데푸드  장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_10
 */
@Controller("buyerMpSoLotteFoodPopController")
public class BuyerMpSoLotteFoodPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoLotteFoodPopController.class);

	@Autowired
	private BuyerMpSoLotteFoodPopService buyerMpSoLotteFoodPopService;
	
	/**
	 * 롯데푸드 장바구니 관리번호 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoLott1Pop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));

		String cond1 = "";
		String cond2 = "";
		String cond3 = "";
		String cond4 = "";
		
		String cond1_name = "";
		String cond2_name = "";
		String cond3_name = "";
		
		if(!"".equals(st_ref_no)){
			String st_ref_no_arr[] = st_ref_no.split("\\^", -1);
			
			cond1 = st_ref_no_arr[0];
			cond2 = st_ref_no_arr[1];
			cond3 = st_ref_no_arr[2];
			cond4 = st_ref_no_arr[3];
			
			pMap.put("CODE", cond1);
			cond1_name = buyerMpSoLotteFoodPopService.getDeptName(pMap);
			
			pMap.put("CODE", cond2);
			cond2_name = buyerMpSoLotteFoodPopService.getDeptName(pMap);
			
			pMap.put("CODE", cond3);
			cond3_name = buyerMpSoLotteFoodPopService.getAccountName(pMap);
		}
		
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
		pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
		pModel.addAttribute("cond2_code", CommonUtil.nvl(cond2));
		pModel.addAttribute("cond2_name", CommonUtil.nvl(cond2_name));
		pModel.addAttribute("cond3_code", CommonUtil.nvl(cond3));
		pModel.addAttribute("cond3_name", CommonUtil.nvl(cond3_name));
		pModel.addAttribute("cond4_code", CommonUtil.nvl(cond4));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoLott1Pop";
	}	 
}
