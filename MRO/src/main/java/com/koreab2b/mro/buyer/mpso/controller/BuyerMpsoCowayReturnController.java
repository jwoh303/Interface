/**
 * 
 */
package com.koreab2b.mro.buyer.mpso.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpsoCowayReturnService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

/**
 * @author jinsoo97
 *
 */
@Controller("buyerMpsoCowayReturnController")
public class BuyerMpsoCowayReturnController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpsoCowayReturnController.class);
	
	@Autowired
	BuyerMpsoCowayReturnService	buyerMpsoCowayReturnService;

	@RequestMapping(value = "/mpso/getBuyerCowayReturnPeriodPop.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerCowayReturnPeriodPop(ModelMap pModel  ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {
		Date _currentDate = new Date();
		SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMM", Locale.KOREA );
		String _toDay = _formatter.format ( _currentDate ); // 현재일자

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String st_buyer	= "";

		if (_sessionInfo != null) {
			st_buyer	= _sessionInfo.getComCode();
		}

		String yyyy  = _toDay.substring(0, 4);
		String month = _toDay.substring(4, 6);
		
		if (pMap.get("st_rtn_year") == null || "".equals(pMap.get("st_rtn_year"))) {
			pMap.put("st_rtn_year", yyyy);
		}
		if (pMap.get("st_rtn_month") == null || "".equals(pMap.get("st_rtn_month"))) {
			pMap.put("st_rtn_month", month);
		}
		
		String st_rtn_yyyymm	= pMap.get("st_rtn_year") + pMap.get("st_rtn_month");
		
		pMap.put("st_rtn_yyyymm", st_rtn_yyyymm);
		pMap.put("st_buyer", st_buyer);
		
		List<Map<String,String>> _data	= buyerMpsoCowayReturnService.getCowayReturnPeriod(pMap);
		
		pModel.addAttribute("_data", _data);
		pModel.addAllAttributes(pMap);
		
		return "buyer/mpso/buyerCowayReturnPeriodPop";
	}
	
	@RequestMapping(value = "/mpso/setBuyerCowayReturnPeriodPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setBuyerCowayReturnPeriodPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		//logger.debug("요청 파라미터 : _list", _list);
//		LOGGER.debug("/mpso/setBuyerCowayReturnPeriodPop.do Map 요청 파라미터 : formData", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String st_buyer	= _sessionInfo.getComCode();	

		String st_rtn_yyyymm	= pMap.get("st_rtn_year") + pMap.get("st_rtn_month");
		
		pMap.put("st_rtn_yyyymm", st_rtn_yyyymm);
		pMap.put("st_buyer", st_buyer);
		
		String result	= buyerMpsoCowayReturnService.setBuyerCowayReturnPeriodPop(pMap);
		
		_response.put("msg", result);

		return  _response;
	}
}
