package com.koreab2b.mro.seller.mpiv.controller;

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

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvTranStatementDivsnWriteService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvTranStatementDivsnWriteController")
public class SellerMpIvTranStatementDivsnWriteController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementDivsnWriteController.class);

	@Autowired
	private SellerMpIvTranStatementDivsnWriteService sellerMpIvTranStatementDivsnWriteService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementDivsnWriteList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvTranStatementDivsnWriteList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvTranStatementDivsnWriteList.do 요청 파라미터 : {}", pMap);
 
		List<Map<String, String>> _data = sellerMpIvTranStatementDivsnWriteService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvTranStatementDivsnWriteList";
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementDivsnWriteList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementDivsnWrite(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, String> _response = new HashMap<String, String>();
		
        logger.debug("pMap 출력 start ====================");
        
        Set<String> keySet = pMap.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = pMap.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("pMap 출력 end ====================");
        
        _response = sellerMpIvTranStatementDivsnWriteService.saveSellerMpIvTranStatementDivsnWrite(pMap);
		
		//_response.put("msg", "");

		return  _response;
	}

	// 거래명세서작성(일괄) 확인 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementDivsnWritePop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String getSellerMpIvTranStatementDivsnWritePop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
			
		//logger.debug("/mpiv/getSellerMpIvTranStatementDivsnWriteList.do 요청 파라미터 : {}", pMap);
 
		Map<String, String> _info = new HashMap<String, String>();
		Map<String, String> mapPopKey = new HashMap<String, String>();
		
		String query = CommonUtil.nvl(pMap.get("st_query"));
		String check_str[]  = CommonUtil.StrToArray(query , "^||^");
		
		String popKey = "";
		
		for(int i=0 ; i < check_str.length; i++){
			String str[] = check_str[i].split("@@",-1);
			
			mapPopKey.put(str[0], str[1]);
			
			if(i == 0){
				popKey += "'";
			}
			
			popKey += str[0];
			
			if(i == (check_str.length-1)){
				popKey += "'";	
			} else {
				popKey += "','";
			}
		}
		
		logger.debug("popKey ==>> " + popKey);
		logger.debug("mapPopKey ==>> " + mapPopKey.toString());
		
		pMap.put("pop_key", popKey);
		
		List<Map<String, String>> _data = sellerMpIvTranStatementDivsnWriteService.getList(pMap);
		
		float tot_amt = 0;	// 총금액
		float seller_amt = 0;	// 공급가액
		float tax_amt = 0;	// 부가세
		
		for (Map<String, String> map : _data) {
			seller_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("SELLER_AMT")),"0"));
			tax_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("TAX_AMT")),"0"));
		}
		
		tot_amt = seller_amt + tax_amt;
		
		_info = _data.get(0);
		
		_info.put("SELLER_AMT", seller_amt+"");
		_info.put("TAX_AMT", tax_amt+"");
		_info.put("TOT_AMT", tot_amt+"");
		
		pModel.addAttribute("info", _data.get(0));
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("mapPopKey", mapPopKey);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementDivsnWritePop";
	}
	
}
