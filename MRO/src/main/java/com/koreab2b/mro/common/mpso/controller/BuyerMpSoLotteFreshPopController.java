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
 * 롯데후레시델리카  장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_10
 */
@Controller("buyerMpSoLotteFreshPopController")
public class BuyerMpSoLotteFreshPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoLotteFreshPopController.class);

	//@Autowired
	//private BuyerMpSoLotteFreshPopService buyerMpSoLotteFreshPopService;
	
	/**
	 * 롯데후레시델리카 장바구니 관리번호 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoLottFresh1Pop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do 요청 파라미터 for jsp : {}", pMap);
		
	    String st_ref_no = CommonUtil.nvl(pMap.get("st_ref_no"));

		String cond1 = "";
		String cond1_name = "";
		
		if(!"".equals(st_ref_no)){
			String st_ref_no_arr[] = st_ref_no.split("\\^", -1);
			
			cond1 = st_ref_no_arr[0];
			cond1_name = st_ref_no_arr[1];
		}
		
		pModel.addAttribute("cond1_code", CommonUtil.nvl(cond1));
		pModel.addAttribute("cond1_name", CommonUtil.nvl(cond1_name));
 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoLottFresh1Pop";
	}	 
}
