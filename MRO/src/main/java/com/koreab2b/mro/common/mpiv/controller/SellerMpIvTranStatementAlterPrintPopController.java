package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvTranStatementAlterPrintPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvTranStatementAlterPrintPopController")
public class SellerMpIvTranStatementAlterPrintPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementAlterPrintPopController.class);
	
	@Autowired
	private SellerMpIvTranStatementAlterPrintPopService sellerMpIvTranStatementAlterPrintPopService;
	
	/**
	 * 거래명세서 수정 및 출력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementAlterPrintPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvTranStatementAlterPrintPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementAlterPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String,String> detailInfo = sellerMpIvTranStatementAlterPrintPopService.getInfo(pMap);
		
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("getSellerMpIvTranStatementAlterPrintPop 거래명세서 수정 및 출력 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("getSellerMpIvTranStatementAlterPrintPop 거래명세서 수정 및 출력 기본정보조회 출력 end ====================");
        
		// 거래명세서 수정 및 출력 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementAlterPrintPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementAlterPrintPop";
	}	
	
	/**
	 * 거래명세서 납품일 수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementAlterPrintPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementAlterPrintPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementAlterPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = sellerMpIvTranStatementAlterPrintPopService.updateInvoiceDate(pMap);
		
		_response.put("msg", flag);
				
		return _response;
	}
	
	/**
	 * 거래명세서 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/delSellerMpIvTranStatementAlterPrintPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> delSellerMpIvTranStatementAlterPrintPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = sellerMpIvTranStatementAlterPrintPopService.deleleteTranStatement(pMap);
		
		_response.put("msg", flag);
				
		return _response;
	}
	
	
	
	
	
}
