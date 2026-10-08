package com.koreab2b.mro.seller.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliChangeReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliChangeReqController")
public class SellerMpIvDeliChangeReqController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliChangeReqController.class);

	@Autowired
	private SellerMpIvDeliChangeReqService sellerMpIvDeliChangeReqService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliChangeReqList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliChangeReqList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		logger.debug("/mpiv/getSellerMpIvDeliveryProgressStateList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvDeliChangeReqList";
	}
	
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliChangeReqList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliChangeReqList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliChangeReqList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품이슈현황 리스트 조회
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 취소요청
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliChangeReqCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpIvDeliChangeReqCancel(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliChangeReqService.updateSellerMpIvDeliChangeReqCancel(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 요청사항 상세 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliChangeReqDetailPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDeliChangeReqDetailPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getSellerMpIvDeliChangeReqDetailPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqDetailPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpiv/sellerMpIvDeliChangeReqDetailPop_v2";
	}
	
	// 거래유형 변경요청 상세 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvProcessTypeChangeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvProcessTypeChangeDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getSellerMpIvProcessTypeChangeDetailPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqDetailPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpiv/sellerMpIvProcessTypeChangeDetailPop";
	}
	
	// 수주거부 요청 상세 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRejectDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDeliveryRejectDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getSellerMpIvDeliveryRejectDetailPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqDetailPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpiv/sellerMpIvDeliveryRejectDetailPop";
	}
	
	// 납품예정일 변경요청 상세 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvDsDateChangeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDsDateChangeDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getSellerMpIvDsDateChangeDetailPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqDetailPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpiv/sellerMpIvDsDateChangeDetailPop";
	}
	
	// 수주접수 초기화요청 상세 팝업
	@RequestMapping(value = "/mpiv/getSellerMpIvIvInfoChangeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvIvInfoChangeDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getSellerMpIvIvInfoChangeDetailPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = sellerMpIvDeliChangeReqService.getSellerMpIvDeliChangeReqDetailPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpiv/sellerMpIvIvInfoChangeDetailPop";
	}
}
