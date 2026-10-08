package com.koreab2b.mro.seller.mdct.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.seller.mdct.service.SellerMdCtContractProgressService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtContractProgressController") 
public class SellerMdCtContractProgressController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtContractProgressController.class);

	@Autowired
	private SellerMdCtContractProgressService sellerMdCtContractProgressService;
	
	// 조회
	@RequestMapping(value = "/mdct/getSellerMdCtContractProgressList.do", method = RequestMethod.POST)
	public String getSellerMdCtContractProgressList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdct/getSellerMdCtContractProgressList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMdCtContractProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mdct/sellerMdCtContractProgressList";
	}
}
