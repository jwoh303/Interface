package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoHiteJinroSiteConsmTeamPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 동일방직,하이트진로 장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_06
 */
@Controller("buyerMpSoHiteJinroSiteConsmTeamPopController")
public class BuyerMpSoHiteJinroSiteConsmTeamPopController {
 

	@Autowired
	private BuyerMpSoHiteJinroSiteConsmTeamPopService buyerMpSoHiteJinroSiteConsmTeamPopService;
	
	/**
	 * 하이트진로이천공장현장소모품팀 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoHiteJinroSiteConsmTeamPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoHiteJinroSiteConsmTeamPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoHiteJinroSiteConsmTeamPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoHiteJinroSiteConsmTeamPop";
	}	 
	
}
