/**
 * 
 */
package com.koreab2b.skmw.controller;

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
import com.koreab2b.skmw.service.SkMwService;

/**
 * @author jiwon
 *
 */

@Controller("skMwController")
public class SkMwController {

	/**
	 * SK마이크로웍스
	 *   
	 */
	
	@Autowired
	private SkMwService skMwService;	
	
	// 품목 회신
	@RequestMapping(value = "/skMwItem.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateSkMwItem(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### SKMW ITEM "+ pMap.toString());
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				Thread.sleep(2000);	
				String rtnMsg = skMwService.updateSkMwItem(pMap);
				
				if(rtnMsg.equals("정상적으로 품목 정보를 등록하였습니다.") || rtnMsg.equals("품목코드 확장이 완료되었습니다.") || rtnMsg.equals("품목정보 수정이 완료되었습니다.")) {
					_response.put("result_status", "S");
					_response.put("result_code", "SUCCESS_NEWITEM_REG");
				}else {					
					_response.put("result_status", "E");
					_response.put("result_code", "FAIL_NEWITEM_REG");
				}
				_response.put("result_message", rtnMsg);
			}else {
				_response.put("result_status", "E");
				_response.put("result_code", "FAIL_NEWITEM_REG");
				_response.put("result_message", "품목 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();
			_response.put("result_status", "E");
			_response.put("result_code", "FAIL_NEWITEM_REG");
			_response.put("result_message", e.getMessage());
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### SKMW ITEM FINISH ! "+ _response.toString());
		
	}
	
	// 발주
	@RequestMapping(value = "/skMwPo.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateSkMwPo(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### SKMW PO ON "+ pMap.toString());
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				String rtnMsg = skMwService.insertSkMwPo(pMap);
				
				if(rtnMsg.equals("정상적으로 발주 정보를 등록하였습니다.")) {					
					_response.put("result_status", "S");
					_response.put("result_code", "SUCCESS_PO_RECV");					
				}else {
					_response.put("result_status", "E");
					_response.put("result_code", "FAIL_PO_RECV");					
				}
				_response.put("message", rtnMsg);
			}else {				
				_response.put("result_status", "E");
				_response.put("result_code", "FAIL_PO_RECV");
				_response.put("result_message", "발주 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();			
			_response.put("result_status", "E");
			_response.put("result_code", "FAIL_PO_RECV");
			_response.put("result_message",  e.getMessage());
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### SKMW PO FINISH ! "+ _response.toString());
		
	}
	
	// 입고
	@RequestMapping(value = "/skMwGr.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void updateSkMwGr(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {		
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		System.out.println("### SKMW GR ON "+ pMap.toString());
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				String rtnMsg = skMwService.insertSkMwGr(pMap);
				
				if(rtnMsg.equals("정상적으로 입고 정보를 등록하였습니다.")) {
					_response.put("result_status", "S");
					_response.put("result_code", "SUCCESS_GR_RECV");
				}else {
					_response.put("result_status", "E");
					_response.put("result_code", "FAIL_GR_RECV");
				}
				_response.put("message", rtnMsg);
			}else {				
				_response.put("result_status", "E");
				_response.put("result_code", "FAIL_GR_RECV");
				_response.put("result_message",  "입고 데이터가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();						
			_response.put("result_status", "E");
			_response.put("result_code", "FAIL_GR_RECV");
			_response.put("result_message",  e.getMessage());
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		System.out.println("### SKMW GR FINISH ! "+ _response.toString());
		
	}
}