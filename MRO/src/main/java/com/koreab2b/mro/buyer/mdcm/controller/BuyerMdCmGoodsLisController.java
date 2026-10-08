package com.koreab2b.mro.buyer.mdcm.controller;

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

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmGoodsLisService;
import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmCategoryPCOService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpiv.controller.SellerMpIvObtnodrReceiptController;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmGoodsLisController")
public class BuyerMdCmGoodsLisController {
 
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdCmGoodsLisController.class);
	
	@Autowired
	private BuyerMdCmGoodsLisService buyerMdCmGoodsLisService;
	@Autowired
	private BuyerMdCmCategoryPCOService buyerMdCmCategoryPCOService;
	
	// 조회 PG_06_B_002_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmGoodsLisList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmGoodsLisList(ModelMap pModel ,@RequestParam Map<String, String> pMap ,HttpServletRequest req) {		
		
		////logger.debug("/mdcm/getBuyerMdCmGoodsLisList.do 요청 파라미터 : {}", pMap);



		// 조회일 슬래시 제거
		/*
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		*/
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") ); 
		pMap.put("category_no", CommonUtil.onvl(pMap.get("buyerCategItemListLocation_categ_code") ,CommonUtil.onvl(pMap.get("category_no") ,"")) );  
		pMap.put("maker_name", CommonUtil.onvl(pMap.get("maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"SPECIFICATION") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"0") );
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		pMap.put("byca_comorg_code",_sessionInfo.getBycaComorgCode());
		pMap.put("com_code",_sessionInfo.getComCode());
		pMap.put("buyer",_sessionInfo.getComCode());
		pMap.put("company",_sessionInfo.getComCode());
		
		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
						
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmGoodsLisService.getList(pMap);
		
		List<Map<String, String>> _data_CATEGORY = buyerMdCmGoodsLisService.getListCATEGORY_TEXT(pMap);
		List<Map<String, String>> _data_MAKER = buyerMdCmGoodsLisService.getListMAKER_NAME(pMap);
		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("data_CATEGORY", CommonUtil.getListNvl(_data_CATEGORY));
		pModel.addAttribute("data_MAKER", CommonUtil.getListNvl(_data_MAKER));
		
		return "buyer/mdcm/buyerMdCmGoodsLisList";
	}
	
	
	// 상품상세 조회 PG_06_B_061_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmGoodsLisDetail.do", method = RequestMethod.POST)
	public String getBuyerMdCmGoodsLisDetail(ModelMap pModel ,@RequestParam Map<String, String> pMap ,HttpServletRequest req ) {			
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("com_code",_sessionInfo.getComCode()); // 로그인한사람
		
		//Map<String,String> 을 Map<String,Object>으로 변환
		Map<String,Object> param = new HashMap<String, Object>();
		for(Map.Entry<String, String> entry : pMap.entrySet()){
			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue());
		}
		
		
		List<Map<String, String>> _data3 = buyerMdCmGoodsLisService.getItemAttrCheck(pMap);
		
		
		pModel.addAttribute("data3", CommonUtil.getListNvl(_data3)); 
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			pMap.put("user_id",_sessionInfo.getUserId()); // 로그인한사람
			List<Map<String, String>> _data1 = buyerMdCmGoodsLisService.getCatalogDisplayMain_v2(pMap);
			List<Map<String, String>> _data2 = buyerMdCmGoodsLisService.getItemSeries_v2(param);
			pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
			pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 
			
			return "buyer/mdcm/buyerMdCmGoodsLisDetail_v2";
		} else {
			List<Map<String, String>> _data1 = buyerMdCmGoodsLisService.getCatalogDisplayMain(pMap);
			List<Map<String, String>> _data2 = buyerMdCmGoodsLisService.getItemSeries(pMap);
			pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
			pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 
			return "buyer/mdcm/buyerMdCmGoodsLisDetail";
		}
	}
	
	// 펀치아웃상품상세조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmPCOLisDetail.do", method = RequestMethod.POST)
	public String getBuyerMdCmPCOLisDetail(ModelMap pModel ,@RequestParam Map<String, String> pMap ,HttpServletRequest req) {			
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("com_code",_sessionInfo.getComCode()); // 로그인한사람
		
		
		List<Map<String, String>> _data1 = buyerMdCmGoodsLisService.getCatalogDisplayMain(pMap);
		List<Map<String, String>> _data2 = buyerMdCmGoodsLisService.getCatalogDisplayPCOMain(pMap);
		List<Map<String, String>> _data3 = buyerMdCmGoodsLisService.getItemAttrCheck(pMap);
		List<Map<String, String>> _data_path = buyerMdCmCategoryPCOService.getCategoryPathPCO(pMap);
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 
		pModel.addAttribute("data3", CommonUtil.getListNvl(_data3));
		pModel.addAttribute("_data_path", CommonUtil.getListNvl(_data_path));
		
		return "buyer/mdcm/buyerMdCmGoodsLisDetail";
	}
  
	 
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmGoodsLisList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmGoodsLisList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		////logger.debug("요청 파라미터 : _list", _list);
		////logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		String msg = "";
		if ("renewal".equals(uiVersion)) {
			msg = buyerMdCmGoodsLisService.saveBuyerMdCmGoodsLisList_v2(pMap);
		}else{
			msg = buyerMdCmGoodsLisService.saveBuyerMdCmGoodsLisList(pMap);
			
		}
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	@RequestMapping(value = "/mdcm/getBuyerMdCmAgentChoicePop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMdCmAgentChoicePop_v2(ModelMap pModel ,@RequestParam Map<String, Object> pMap ,HttpServletRequest req) {			
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("com_code",_sessionInfo.getComCode()); // 로그인한사람
		
		
		List<Map<String, String>> _data = buyerMdCmGoodsLisService.getItemSeries_v2(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "common/popup/mdcm/buyerMdCmAgentChoicePop_v2";
	}
	
	@RequestMapping(value = "/mdcm/buyerMdCmAgentChoiceMultiPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String buyerMdCmAgentChoiceMultiPop_v2(ModelMap pModel ,@RequestParam Map<String, Object> pMap ,HttpServletRequest req) {			
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("com_code",_sessionInfo.getComCode()); // 로그인한사람
		pModel.addAttribute("st_buyer_item_no",pMap.get("buyer_tem_no"));
		
		List<Map<String, String>> _data = buyerMdCmGoodsLisService.getItemSeries_v2(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "common/popup/mdcm/buyerMdCmAgentChoiceMultiPop_v2";
	}
	
	// 품목간략정보 팝업
	@RequestMapping(value = "/mdcm/getBuyerMdCmGoodsLisDetailPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMdCmGoodsLisDetailPop_v2(ModelMap pModel ,@RequestParam Map<String, String> pMap ,HttpServletRequest req ) {			
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("com_code",_sessionInfo.getComCode()); // 로그인한사람
		pMap.put("user_id",_sessionInfo.getUserId()); // 로그인한사람
		
		//Map<String,String> 을 Map<String,Object>으로 변환
		Map<String,Object> param = new HashMap<String, Object>();
		for(Map.Entry<String, String> entry : pMap.entrySet()){
			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue());
		}
		
		List<Map<String, String>> _data1 = buyerMdCmGoodsLisService.getCatalogDisplayMain_v2(pMap);
		List<Map<String, String>> _data2 = buyerMdCmGoodsLisService.getItemSeries_v2(param);
		List<Map<String, String>> _data3 = buyerMdCmGoodsLisService.getItemAttrCheck(pMap);
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 
		pModel.addAttribute("data3", CommonUtil.getListNvl(_data3)); 
		
		return "common/popup/mdcm/buyerMdCmGoodsLisDetailPop_v2";
	}
	 
}
