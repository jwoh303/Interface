package com.koreab2b.mro.common.none.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.none.service.CommonNoNeSendSmsPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonNoNeSendSmsPopController")
public class CommonNoNeSendSmsPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonNoNeSendSmsPopController.class);

	@Autowired
	private CommonNoNeSendSmsPopService commonNoNeSendSmsPopService;

	/*저장*/
	@RequestMapping(value = "/none/sendSms.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendSms(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = commonNoNeSendSmsPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 조회
	@RequestMapping(value = "/none/getNoneSentSmsList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void getNoneSentSmsList(HttpServletRequest pReq , HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = commonNoNeSendSmsPopService.getList(pMap);

		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);		
	}
}
