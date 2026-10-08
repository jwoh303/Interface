package com.koreab2b.mro.master.mdcp.controller;

import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.Date;
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
import com.koreab2b.mro.master.mdcp.service.MasterMdCpAgntcmpyService;
import com.koreab2b.mro.util.AWSKMSAlgorithmUtil;
import com.koreab2b.mro.util.CommonProperty;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.SeedCbcAlgorithmUtil;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Controller("masterMdCpAgntcmpyController")
public class MasterMdCpAgntcmpyController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpAgntcmpyController.class);

	@Autowired
	private MasterMdCpAgntcmpyService masterMdCpAgntcmpyService;
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAgntcmpyList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCpAgntcmpyList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCpAgntcmpyService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 신용평가여부
	@RequestMapping(value = "/mdcp/getMasterMdCpAgntcmpyCreaditAgentCnt.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpAgntcmpyCreaditAgentCnt(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("/mdcp/getMasterMdCpAgntcmpyCreaditAgentCnt.do 요청 파라미터 for jsp : {}", pMap); 
		
		String creaditCnt = masterMdCpAgntcmpyService.getCreaditCnt(pMap);
		
		_response.put("msg", creaditCnt);

		return  _response;
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcp/excelMasterMdCpAgntcmpyList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap) throws UnsupportedEncodingException{
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCpAgntcmpyService.getExcelList(pMap);
		for (int i = 0; i < _data.size(); i++) {
			String bank_account_no = _data.get(i).get("BANK_ACCOUNT_NO").trim();
			
			/* 기존 SEED_CBC 복호화
			// SeedCbcAlgorithmUtil 복호화
			String pszAccount_no = bank_account_no;
			byte[] decrAccount_no = SeedCbcAlgorithmUtil.getBytes(pszAccount_no);
			byte[] cbcAlgorithm = SeedCbcAlgorithmUtil.SEED_CBC_Decrypt(decrAccount_no, 0, decrAccount_no.length);
			String plainTextStr = null;
			if (cbcAlgorithm != null) {
				plainTextStr = new String(cbcAlgorithm);
			}
			*/
			
			//신규 KMS 복호화
			String pszAccount_no = bank_account_no;
			String plainTextStr = AWSKMSAlgorithmUtil.decrypt(pszAccount_no);
			
			_data.get(i).put("BANK_ACCOUNT_NO", plainTextStr);
		}
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpAgntcmpyList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpAgntcmpy(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCpAgntcmpyService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdcp/delMasterMdCpAgntcmpyList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCpAgntcmpy(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCpAgntcmpy MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCpAgntcmpyService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// bizwire 토큰 생성
	@RequestMapping(value = "/mdcp/bizwireWeblink.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> bizwireWeblink(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		System.out.println("#### biz_no : "+ pMap.get("st_doc_id"));	
		String bizNo = pMap.get("st_doc_id").replace("-", ""); //운영
//		String bizNo = "6372501366"; //개발
		String token = "";
		
		String signKey64 = Base64.getEncoder().encodeToString(CommonProperty.getBizWebPrdKey().getBytes());
		long tokenValidMilisecond = 1000L * 60; // 1분
		Claims claims = Jwts.claims().setSubject("kep01"); // 웹링크 계정 ID
		claims.put("bsn", bizNo); // 조회할 기업의 사업자등록번호
	
	    Date now = new Date();		    
		
		token = Jwts.builder()
	               .setClaims(claims)
	               .setIssuedAt(now)
	               .setExpiration(new Date(now.getTime() + tokenValidMilisecond))
	               .signWith(SignatureAlgorithm.HS256, signKey64)
	               .compact();

		System.out.println("#### biz token : "+ token);
		_response.put("token", token);
		_response.put("callUrl", CommonProperty.getBizWebPrdUrl());
		
		return _response;
	}

}
