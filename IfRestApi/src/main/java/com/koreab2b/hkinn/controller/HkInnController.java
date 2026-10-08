/**
 * 
 */
package com.koreab2b.hkinn.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreab2b.hkinn.service.HkInnService;
/**
 * @author jiwon
 *
 */

@Controller("hkInnController")
public class HkInnController {

	/**
	 * HK이노엔  
	 */
	
	@Autowired
	private HkInnService hkInnService;	
	
	// 발주
	@RequestMapping(value = "/insertHkInnPoData.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateHkInnPoData(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### HKINN PO INSERT ON "+ pMap.toString());
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				String rtnMsg = hkInnService.insertHkInnPoData(pMap);
				
				if(rtnMsg == null || rtnMsg.equals("")) {
					_response.put("status", "S");	
				}else {					
					_response.put("status", "F");
				}
				_response.put("message", rtnMsg);
			}else {
				_response.put("status", "F");
				_response.put("message", "발주 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();
			_response.put("status", "F");
			_response.put("message", e.getMessage());			
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### HKINN PO INSERT FINISH ! "+ _response.toString());
		
	}
	
	// 입고
	@RequestMapping(value = "/insertHkInnGrData.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateHkInnGrData(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### HKINN GR INSERT ON "+ pMap.toString());
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				String rtnMsg = hkInnService.insertHkInnGrData(pMap);
				
				if(rtnMsg == null || rtnMsg.equals("")) {
					_response.put("status", "S");	
				}else {					
					_response.put("status", "F");
				}
				_response.put("message", rtnMsg);
			}else {
				_response.put("status", "F");
				_response.put("message", "입고 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();
			_response.put("status", "F");
			_response.put("message", e.getMessage());			
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### HKINN GR INSERT FINISH ! "+ _response.toString());
		
	}
	
	// 브랜드 조회
	@RequestMapping(value = "/testBrand.do",  method = RequestMethod.GET)
	@ResponseBody
	public  Map<String, Object> testBrand(HttpServletRequest req, HttpServletResponse response) throws IOException {		
		
		List<Map<String, Object>> brandLst = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap = new HashMap<String, Object>();	
		
		try {
			
			brandLst = hkInnService.selectBrandLst();
			System.out.println("### HKINN BRAND 조회 : "+ brandLst.toString());
			
			if(brandLst.size() > 0) {
				resultMap.put("brand",brandLst);
			}
			
		}catch(Exception e){			
			e.printStackTrace();		
		}
		
		return resultMap;			
	}
}