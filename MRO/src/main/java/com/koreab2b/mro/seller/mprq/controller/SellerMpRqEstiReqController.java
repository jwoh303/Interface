package com.koreab2b.mro.seller.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mprq.service.SellerMpRqEstiReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpRqEstiReqController")
public class SellerMpRqEstiReqController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqEstiReqController.class);

	@Autowired
	private SellerMpRqEstiReqService sellerMpRqEstiReqService;
	
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerMpRqEstiReqList.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpRqEstiReqList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("sellerMpRqEstiReq 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpRqEstiReqService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("msg", "complate");
		
		return "seller/mprq/sellerMpRqEstiReqList";
	}	

	
	
	/**
	 * 협력사 견적
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/sellerMpRqEstiReqAgentHandout.do", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> sellerMpRqEstiReqAgentHandout(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		
		String msg = sellerMpRqEstiReqService.updateData(_pMap, _list);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 협력사 견적포기
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/sellerMpRqEstiReqGiveUp.do", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> sellerMpRqEstiReqGiveUp(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		String flag = sellerMpRqEstiReqService.sellerMpRqEstiReqGiveUp(_pMap, _list);
		_msg.put("MSG", flag); 
		_response.put("msg", _msg);

		return  _response;
	}
	
}
