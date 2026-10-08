package com.koreab2b.lottecs.controller;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.lottecs.service.LottecsService;


@Controller("lottecsController")
public class LottecsController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LottecsController.class);
	
	@Autowired
	private LottecsService LottecsService;

	@RequestMapping(value = "/getLotteMpRqAppSend.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getLotteMpRqAppSend(@RequestBody Map<String, Object> pMap, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		LOGGER.info("pMap" + pMap);
		LOGGER.info("req" + req);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		try {
			returnMap = LottecsService.getLotteMpRqAppSend(pMap);
		} catch (Exception e) {
			LOGGER.error("getLotteMpRqAppSend ERROR !!!: ", e);
			returnMap.put("resultCode", "FAIL");
		}
		
		return returnMap;
	}

}
