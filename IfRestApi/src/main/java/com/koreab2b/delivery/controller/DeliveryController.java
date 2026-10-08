/**
 * 
 */
package com.koreab2b.delivery.controller;

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
import com.koreab2b.delivery.service.DeliveryService;
/**
 * @author jiwon
 *
 */

@Controller("deliveryController")
public class DeliveryController {

	/**
	 * 택배 API
	 */
	
	@Autowired
	private DeliveryService deliveryService;	
	
	// 스윗트래커 택배 추적 데이터 수신
	@RequestMapping(value = "/delivery.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void insertDeliveryData(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		try {
			if(!pMap.isEmpty()) {
				
				_response.put("code", true);
				_response.put("message", "success");
				String rtnMsg = deliveryService.insertDeliveryResult(pMap);
				
			}else {
				_response.put("code", false);
				_response.put("message", "fail - "+"택배 추적 정보가 존재하지 않습니다.");
			}
			
		}catch(Exception e){			
			e.printStackTrace();
			_response.put("code", false);
			_response.put("message", "fail - "+e.getMessage());			
		}
		
		writer.write(jsonResponse.writeValueAsString(_response));
		writer.flush();
		writer.close();
		
		
	}		
	
	// Delivery 택배 추적 OPEN API 데이터 수신
	@RequestMapping(value = "/parcel.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void insertParcelData(HttpServletRequest req, HttpServletResponse response, @RequestBody Map<String, Object> pMap) throws IOException {
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		try {
			if(!pMap.isEmpty()) {
				System.out.println("### PARCEL INSERT ON "+ pMap.toString());
//					{projectId=AA4ewZQQu3DI7lIObxh054IO, carrierId=kr.kdexp, trackingNumber=6825120367344}

//					String rtnMsg = deliveryService.insertParcelSign(pMap);
				
				if(pMap.get("projectId") != null && !pMap.get("projectId").equals("")) {
					System.out.println("### Webhook 수신 완료 "+ pMap.toString());
					pMap.put("flag", "W");
//						pMap.put("msg", "Success");
				}else {					
					System.out.println("### Webhook 추적 수신 projectId 존재  X"+ pMap.toString());
					pMap.put("flag", "E");
//						pMap.put("msg", "추적 수신 projectId 존재  X");
				}
//				String rtnMsg = deliveryService.updateParcelSign(pMap);
				String rtnMsg = deliveryService.updateParcelSignCp(pMap);
			}				
		}catch(Exception e){			
			e.printStackTrace();		
			try {
//					pMap.put("msg", "추적 수신 중 에러 발생");
				System.out.println("### Webhook 수신 중 에러 발생 "+ pMap.toString());
				pMap.put("flag", "E");		// 변경필요 해당 건만 E로 변경하게 
//				String rtnMsg = deliveryService.updateParcelSign(pMap);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		
	}	
}