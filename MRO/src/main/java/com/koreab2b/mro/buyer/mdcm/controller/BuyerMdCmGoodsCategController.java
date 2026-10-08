package com.koreab2b.mro.buyer.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmGoodsCategService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmGoodsCategController")
public class BuyerMdCmGoodsCategController {

	@Autowired
	private BuyerMdCmGoodsCategService buyerMdCmGoodsCategService;
	
	// 코드 조회
	@RequestMapping(value = "/mdcm/getBuyerMdAmGoodsCategLis.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMasterCodeManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerMdCmGoodsCategService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 코드 저장
	@RequestMapping(value = "/mdcm/saveBuyerMdAmGoodsCategLis.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMasterCodeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdCmGoodsCategService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	//코드저장
	@RequestMapping(value = "/mdcm/saveBuyerMdAmGoodsCategLis_v2.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmGoodsCategLis_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("st_com_code", _sessionInfo.getComCode() );
		
		int msg = buyerMdCmGoodsCategService.saveBuyerMdAmGoodsCategLis_v2(pMap);
		
		String createOk = "";
		if(msg > 0){
			createOk = "CREATE_OK";
		}
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}

	// 코드 삭제
	@RequestMapping(value = "/mdcm/delBuyerMdAmGoodsCategLis.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmMasterCodeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdCmGoodsCategService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/mdcm/delBuyerMdAmGoodsCategLis_v2.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> delBuyerMdAmGoodsCategLis_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		int msg = buyerMdCmGoodsCategService.delBuyerMdAmGoodsCategLis_v2(pMap);
		
		String createOk = "";
		if(msg > 0){
			createOk = "CREATE_OK";
		}
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}
	@RequestMapping(value = "/mdcm/updateBuyerMdAmGoodsCategLis_v2.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmGoodsCategLis_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		int msg = buyerMdCmGoodsCategService.updateBuyerMdAmGoodsCategLis_v2(pMap);
		
		String createOk = "";
		if(msg > 0){
			createOk = "CREATE_OK";
		}
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}

}
