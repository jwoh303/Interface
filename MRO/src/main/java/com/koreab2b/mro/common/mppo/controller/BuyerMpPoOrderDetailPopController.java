package com.koreab2b.mro.common.mppo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.coco.service.CommonApprovalService;
import com.koreab2b.mro.common.mppo.service.BuyerMpPoOrderDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderDetailPopController")
public class BuyerMpPoOrderDetailPopController {
 

	@Autowired
	private CommonApprovalService commonApprovalService;
	
	@Autowired
	private BuyerMpPoOrderDetailPopService buyerMpPoOrderDetailPopService;
	
	
	/**
	 * 주문요청(발주) 상세조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoOrderDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		
		List<Map<String, String>> _info =  buyerMpPoOrderDetailPopService.getList(pMap);		  
		List<Map<String, String>> _data =  commonApprovalService.approvalPxListPop(pMap);		  

		pModel.addAttribute("info", CommonUtil.getListNvl(_info)); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mppo/buyerMpPoOrderDetailPop";
	}	 
	
}
