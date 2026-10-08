/**
 * 
 */
package com.koreab2b.hugel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreab2b.hugel.service.HugelService;

/**
 * @author jiwon
 *
 */

@Controller("hugelController")
public class HugelController {

	/**
	 * 휴젤 입고 
	 */
	
	@Autowired
	private HugelService hugelService;	
	
	// 입고
	@RequestMapping(value = "/insertHugelGrData.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateHugelGrData(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### HUGEL GR INSERT ON "+ pMap.toString());
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				String rtnMsg = hugelService.insertHugelGrData(pMap);
				
				if("필수 값이 존재하지 않습니다.".equals(rtnMsg)) {
					_response.put("ZSTATUS", "E");	
				}else {					
					_response.put("ZSTATUS", "S");
				}
				_response.put("ZMESSAGE", rtnMsg);
			}else {
				_response.put("ZSTATUS", "E");
				_response.put("ZMESSAGE", "입고 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();
			_response.put("ZSTATUS", "E");
			_response.put("ZMESSAGE", e.getMessage());			
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### HUGEL GR INSERT FINISH ! "+ _response.toString());
		
	}
}