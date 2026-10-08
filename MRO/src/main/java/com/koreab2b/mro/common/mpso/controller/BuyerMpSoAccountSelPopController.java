package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoAccountSelPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 예산을 사용하는 고객사의 경우 장바구니에 입력될 계정코드를 선택하기 위한 팝업
 * @author cha3202
 *PG_06_B_006_40 , PG_06_B_006_41
 */
@Controller("buyerMpSoAccountSelPopController")
public class BuyerMpSoAccountSelPopController {
 

	@Autowired
	private BuyerMpSoAccountSelPopService buyerMpSoAccountSelPopService;
	
	/**
	 * 계정선택 조회 PG_06_B_006_40
	 * 41과 목록SQL 동일
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoAccountSelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoAccountSelPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
 
		List<Map<String, String>> _data = buyerMpSoAccountSelPopService.getDeptSelect(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpso/buyerMpSoAccountSelPop_v2";
		}else{
			return "common/popup/mpso/buyerMpSoAccountSelPop";
		}
	}	 
	
	/**
	 * 계정선택 조회 PG_06_B_006_40
	 * 41과 목록SQL 동일
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoAccountSelIFPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoAccountSelIFPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoAccountSelPopService.getDeptSelect(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoAccountSelIFPop";
	}	 
	
	
	
	/**
	 * 계정선택 조회 PG_06_B_006_41
	 * 40과 목록SQL 동일
	 * 예산부서명 선택(공통)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getDeptSelect.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getDeptSelect(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoAccountSelPopService.getDeptSelect(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 		
		
		List<Map<String, String>> _data1 = null;
		
		if (!"".equals(pMap.get("st_pa_account_type"))){
			_data1 = buyerMpSoAccountSelPopService.getAccountDivideList(pMap); 
			pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		}
		
		
		return "common/popup/mpso/buyerMpSoAccountSel1Pop";
	}	 
	
	 
	
}
