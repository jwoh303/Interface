package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoGraduateDetailDeptCodePopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 홍익대학교 대학원 선택 팝업
 * @author cha3202
 *PG_06_B_006_30
 */
@Controller("buyerMpSoGraduateDetailDeptCodePopController")
public class BuyerMpSoGraduateDetailDeptCodePopController {
 
	@Autowired
	private BuyerMpSoGraduateDetailDeptCodePopService buyerMpSoGraduateDetailDeptCodePopService;
	
	/**
	 * 대학원상세 학과코드 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoGraduateDetailDeptCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoGraduateDetailDeptCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoGraduateDetailDeptCodePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoGraduateDetailDeptCodePop";
	}	 
	
}
