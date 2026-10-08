package com.koreab2b.phil.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.phil.service.PhilService;

@Controller("philController")
public class philController {
	private static final Logger LOGGER = LoggerFactory.getLogger(philController.class);
	
	@Autowired
	private PhilService philService;
	
	@RequestMapping(value = "/insertPhilPointInfo.do", method =  {RequestMethod.POST})
	@ResponseBody
	public  Map<String, Object> insertPhilPointInfo(@RequestBody Map<String, Object> requestMap, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		LOGGER.info("insertPhilPointInfo  {}" + requestMap);
		
		try {
			List<Map<String, Object>> pointList = (List<Map<String, Object>>) requestMap.get("pointList");
			LOGGER.info("insertPhilPointInfo size  {}" + pointList.size());
			
			if (pointList == null || pointList.size() == 0) {
				resultMap.put("resultCode", "F");
				resultMap.put("resultMessage", "전송된 데이터가 없습니다.");
				
				return resultMap;
			}
			philService.insertPhilPointInfo(pointList);

			resultMap.put("resultCode", "S");
			resultMap.put("resultMessage", "정상 처리되었습니다.");
			
		}catch (Exception e) {
			LOGGER.error("insertPhilPointInfo error" + e);
			
			resultMap.put("resultCode", "F");
			resultMap.put("resultMessage", "시스템 오류가 발생하였습니다.");
		}
		
		return resultMap;
	}
	
	@ExceptionHandler(HttpMessageNotReadableException.class)
    @ResponseBody
    public Map<String, Object> handleJsonError(HttpMessageNotReadableException e) {

        Map<String, Object> result = new HashMap<String, Object>();

        LOGGER.error("JSON Parsing Error", e);

        result.put("resultCode", "F");
        result.put("resultMessage", "요청 데이터 형식이 올바르지 않습니다.");

        return result;
    }
}
