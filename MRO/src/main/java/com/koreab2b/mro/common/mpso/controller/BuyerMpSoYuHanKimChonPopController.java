package com.koreab2b.mro.common.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoYuHanKimChonPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 유한킴벌리  장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_10
 */
@Controller("buyerMpSoYuHanKimChonPopController")
public class BuyerMpSoYuHanKimChonPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoYuHanKimChonPopController.class);

	@Autowired
	private BuyerMpSoYuHanKimChonPopService buyerMpSoYuHanKimChonPopService;
	
	/**
	 * 유한킴벌리(주) 김천공장  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoYuHanKimChonPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoYuHanKimChonPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("userid", _sessionInfo.getUserId());  
		pMap.put("buyer", _sessionInfo.getComCode() );
		  
		
		List<Map<String, String>> _data1 = buyerMpSoYuHanKimChonPopService.getLegacyUserId(pMap); 
		List<Map<String, String>> _data2 = buyerMpSoYuHanKimChonPopService.getRefHdInfo(pMap); 
		
		
 
	    
	    String st_mg_note =  pMap.get("st_mg_note");
	    String st_ref_no =  pMap.get("st_ref_no");
	    
		String mg_arr[] = st_mg_note.split(" ");

		String plantCode = "";
		String rdDate = "";
		String reqUserId = "";
		String confUserId = "";
		String accCateg = "";
		String evalPrice = "";
		String glAccount = "";
		String gainLoss = "";
		String profitSegment = "";
		String costCenter = "";
		String center_type = "";
		if(!"".equals(st_ref_no)){
			plantCode = mg_arr[0];
			rdDate = mg_arr[1];
			reqUserId = mg_arr[2];
			confUserId = mg_arr[3];
			if("KR07".equals(st_ref_no)){
				accCateg = mg_arr[4];
				evalPrice = mg_arr[5];
				glAccount = mg_arr[6];
				gainLoss = mg_arr[7];
				profitSegment = mg_arr[8];
				if(mg_arr.length > 9){
					costCenter = mg_arr[9];
				}
			}
		}
		
		LOGGER.debug("/mpso/getBuyerMpSoYuHanKimChonPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		pMap.put("value1", pMap.get("buyer"));		 
		String req_user_name = "";
		//if(!"".equals(reqUserId)){
			pMap.put("value2", reqUserId);			
			req_user_name = buyerMpSoYuHanKimChonPopService.getUserNameLoc(pMap);
		//}

		String conf_user_name = "";
		//if(!"".equals(confUserId)){
			pMap.put("value2", confUserId);
			conf_user_name = buyerMpSoYuHanKimChonPopService.getUserNameLoc(pMap);
		//}

		String req_location_name = "";
		String req_location_user = reqUserId;
		if("".equals(reqUserId)){
			req_location_user = _sessionInfo.getUserId();
		}
		//if(!"".equals(reqUserId)){
			pMap.put("value2", req_location_user);			
			req_location_name = buyerMpSoYuHanKimChonPopService.getUserAddressLoc(pMap);
		//}

		String gainloss_center_name = "";
		//if(!"".equals(gainLoss)){
			center_type = "st_gainloss_center";
			pMap.put("value2", gainLoss);
			pMap.put("objName", center_type);
			gainloss_center_name = buyerMpSoYuHanKimChonPopService.getCenterCode(pMap);
		//}

		String cost_center_name = "";
		//if(!"".equals(costCenter)){
			center_type = "st_cost_center";
			pMap.put("value2", costCenter);
			pMap.put("objName", center_type);
			cost_center_name = buyerMpSoYuHanKimChonPopService.getCenterCode(pMap);
		//}
		
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));  
		pModel.addAttribute("req_user_name", CommonUtil.nvl(req_user_name));  
		pModel.addAttribute("conf_user_name", CommonUtil.nvl(conf_user_name));  
		pModel.addAttribute("req_location_name", CommonUtil.nvl(req_location_name));  
		pModel.addAttribute("gainloss_center_name", CommonUtil.nvl(gainloss_center_name));  
		pModel.addAttribute("cost_center_name", CommonUtil.nvl(cost_center_name));  
 
		
		return "common/popup/mpso/buyerMpSoYuHanKimChonPop";
	}	 
	
	
	/** 
	 * 요청자 , 승인권자
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoYuHanKimChonPo_getUserNameLoc.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUserNameLoc(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		 
		String msg = buyerMpSoYuHanKimChonPopService.getUserNameLoc(pMap);
 
		 
		_msg.put("MSG",  msg); 
		_response.put("msg", _msg);
		return  _response;
	}

	/** 
	 * 요청자 배송처
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoYuHanKimChonPo_getUserAddressLoc.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUserAddressLoc(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		 
		String msg = buyerMpSoYuHanKimChonPopService.getUserAddressLoc(pMap);
 
		 
		_msg.put("MSG",  msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/** 
	 * 센터
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoYuHanKimChonPo_getCenterCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCenterCode(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		 
		String msg = buyerMpSoYuHanKimChonPopService.getCenterCode(pMap);
 
		 
		_msg.put("MSG",  msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/** 
	 * 세그먼트
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoYuHanKimChonPo_getprofitSegmentCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getprofitSegmentCode(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		 
		String msg = buyerMpSoYuHanKimChonPopService.getprofitSegmentCode(pMap);
 
		 
		_msg.put("MSG",  msg); 
		_response.put("msg", _msg);
		return  _response;
	}	
	
	/** 
	 * 저장
	 * 
	 * buyer_yuhan_ref_update
	 * 
	 */
	@RequestMapping(value = "/mpso/saveBuyerYuhanRetUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerYuhanRetUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		 
		String msg = buyerMpSoYuHanKimChonPopService.saveBuyerYuhanRetUpdate(pMap);
 
		 
		_msg.put("MSG",  "UPDATE_OK"); 
		_response.put("msg", _msg);
		return  _response;
	}	
	
	
	
}
