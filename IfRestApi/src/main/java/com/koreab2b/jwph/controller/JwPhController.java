package com.koreab2b.jwph.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.jwph.service.JwPhService;

@Controller("jwPhController")
public class JwPhController {
	private static final Logger LOGGER = LoggerFactory.getLogger(JwPhController.class);
	
	@Autowired
	private JwPhService jwPhService;
	
	@RequestMapping(value = "/insertJwPhPoData.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateJwPhPoData(@RequestBody Map<String, Object> pMap, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		LOGGER.info("updateJwPhPoData pMap" + pMap);
		LOGGER.info("updateJwPhPoData req" + req);
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			jwPhService.insertJwPhPoData(pMap);
			result.put("success", true);
			result.put("message", "주문 수신 완료");
		} catch (RuntimeException e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}catch (Exception e) {
			LOGGER.error("updateJwPhPoData ERROR !!!: ", e);
			
			result.put("status", false);
			result.put("message", "시스템 오류가 발생했습니다.");
		}
		return result;
	}
	
	@RequestMapping(value = "/insertJwPhReData.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateJwPhReData(@RequestBody Map<String, Object> pMap, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		LOGGER.info("updateJwPhReData pMap" + pMap);
		LOGGER.info("updateJwPhReData req" + req);
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			jwPhService.insertJwPhReData(pMap);
			result.put("success", true);
			result.put("message", "견적 요청 접수 완료");
		} catch (RuntimeException e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}catch (Exception e) {
			LOGGER.error("updateJwPhPoData ERROR !!!: ", e);
			
			result.put("status", false);
			result.put("message", "시스템 오류가 발생했습니다.");
		}
		return result;
	}
}
