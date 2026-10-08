package com.koreab2b.mro.common.mdct.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdct.service.SellerMdCtContractWritePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtContractWritePopController")
public class SellerMdCtContractWritePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtContractWritePopController.class);

	@Autowired
	private SellerMdCtContractWritePopService sellerMdCtContractWritePopService;
	
	/**
	 * 계약서 작성  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/getSellerMdCtContractWritePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMdCtContractWritePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getSellerMdCtContractWritePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMdCtContractWritePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/sellerMdCtContractWritePop";
	}	 
	
}
