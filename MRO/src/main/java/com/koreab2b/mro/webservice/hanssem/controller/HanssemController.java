/**
 * 
 */
package com.koreab2b.mro.webservice.hanssem.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.webservice.hanssem.service.HanssemService;

/**
 * @author jiwon
 *
 */

@Controller("hanssemController")
public class HanssemController {

	/**
	 * Hanssem 
	 */
	
	@Autowired
	private HanssemService hanssemService;	
	
	// 예산 이벤트 추가
	@RequestMapping(value = "/hsBdgt.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void updateHanssemGrData(HttpServletRequest req, HttpServletResponse response, @RequestParam Map<String, Object> pMap) throws IOException {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String userId = _sessionInfo.getUserId();
		Calendar cal = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMM");
        String nowDateStr = dateFormat.format(new Date(System.currentTimeMillis()));
		String _response = "";
		ObjectMapper jsonResponse = new ObjectMapper(); // JSON 객체 변환
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		String yyyyMm = pMap.get("yyyyMm").toString();
		
		
		try {
			List<Map<String, String>> userList = hanssemService.selectUserId(userId);
			System.out.println("### userList  : "+ userList.toString());
			if(userList.size() < 1) {
				System.out.println("### HANSSEM BDGT TRXL 허용되지 않은 계정  : "+ pMap.toString());
				_response = "허용되지 않은 계정입니다.";
				return;
			}
			if(yyyyMm.length() != 6) {
				System.out.println("### HANSSEM BDGT TRXL 예산 날짜 오기입  : "+ pMap.toString());
				_response = "예산 날짜를 제대로 입력하세요.";
				return;
			}
			Date paramDate = new Date(dateFormat.parse(yyyyMm).getTime());     
            Date nowDate = new Date(dateFormat.parse(nowDateStr).getTime());            
            cal.setTime(nowDate);
            cal.add(Calendar.MONTH,-1);
            Date preDate = cal.getTime();
            if(paramDate.compareTo(nowDate) > 0 || paramDate.compareTo(preDate) < 0) {
            	System.out.println("### HANSSEM BDGT TRXL 금월, 전월만 조회가능  : "+ pMap.toString());
            	_response = "금월, 전월만 조회가 가능합니다.";
            	return;
            }
            hanssemService.mergeHanssemBdgtTrxl(pMap);
			System.out.println("### HANSSEM BDGT TRXL 추가  : "+ pMap.toString());
			_response = "한샘 예산을 호출하였습니다.";
            
		}catch(Exception e){			
			e.printStackTrace();
			_response = "한샘 예산을 호출 실패.";
		}finally {
			System.out.println("### HANSSEM 예산 이벤트 추가 FINISH ! ");
			writer.write(jsonResponse.writeValueAsString(_response));
			writer.flush();
			writer.close();
		}
		
		
	}
}