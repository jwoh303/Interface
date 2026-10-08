package com.koreab2b.mro.buyer.mdcm.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmMyGoodsSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmMyGoodsSearchController")
public class BuyerMdCmMyGoodsSearchController {
 
	@Autowired
	private BuyerMdCmMyGoodsSearchService buyerMdCmMyGoodsSearchService;
	
	// 조회 PG_06_B_003_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmMyGoodsSearchList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmMyGoodsSearchList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdcm/getBuyerMdCmMyGoodsSearchList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		
		if ("renewal".equals(uiVersion)) { //리뉴얼에선 해당 값 없으면 디폴트 30
			String rowCntTmp = CommonUtil.onvl(pMap.get("onepagerow"),_sessionInfo.getRowCnt());
			String pageString = "30,50,100,200,500,1000";
			if(!Arrays.asList(pageString.split(",")).contains(rowCntTmp)){
				rowCntTmp = "30";
			}
			pMap.put("onepagerow",rowCntTmp);
		}else{
			pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		}
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		pMap.put("st_my_groups", CommonUtil.onvl(pMap.get("st_my_groups") ,"") );
		pMap.put("st_list_type", CommonUtil.onvl(pMap.get("st_list_type") ,"list") );
		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		if ("renewal".equals(uiVersion)) {
			pMap.put("total_flag", "Y"); //전체데이터(조회조건 없는)
			List<Map<String, String>> _data = buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMap);
			pMap.put("total_flag", "N"); //조회조건 들어간 데이터
			List<Map<String, String>> _data2 = buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMap);
			pMap.put("paging_flag", "N"); //조회조건 들어간 페이징 없는 데이터
			List<Map<String, String>> _data3 = buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMap);
			pModel.addAttribute("total_data", CommonUtil.getListNvl(_data));
			pModel.addAttribute("data", CommonUtil.getListNvl(_data2));
			pModel.addAttribute("paging_data", CommonUtil.getListNvl(_data3));
			return "buyer/mdcm/buyerMdCmMyGoodsSearchList_v2";
		} else {
			List<Map<String, String>> _data = buyerMdCmMyGoodsSearchService.getList(pMap);
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "buyer/mdcm/buyerMdCmMyGoodsSearchList";
		}
	}
	// 조회 PG_06_B_003_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmMyRqdtSearchList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmMyRqdtSearchList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		pMap.put("st_byca_com_code",_sessionInfo.getBycaComorgCode());
		pMap.put("st_query", CommonUtil.onvl(pMap.get("st_query") ,"") );
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
	 		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String,String>> _data = buyerMdCmMyGoodsSearchService.getRqdtList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmMyRqdtSearchList";
	}
	/**
	 * 나의상품 삭제 
	 * 
	 */
	@RequestMapping(value = "/mdcm/removeBuyerMdCmMyGoodsLisList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> removeBuyerMdCmMyGoodsLisList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		////logger.debug("요청 파라미터 : _list", _list);
		////logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		int msg = buyerMdCmMyGoodsSearchService.removeBuyerMdCmMyGoodsLisList(pMap);
		
		String createOk = "CREATE_OK";
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 분류저장 
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmMyGroupLisList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmMyGroupLisList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		int msg = buyerMdCmMyGoodsSearchService.saveBuyerMdCmMyGroupLisList(pMap);
		
		String createOk = "CREATE_OK";
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}	 
	
	//관심상품 분류 이동 팝업
	@RequestMapping(value = "/common/saveMyCatalogPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String saveMyCatalogPop_v2(HttpServletRequest request) {
		return "common/popup/saveMyCatalogPop_v2";
	}
	//관심상품 분류 관리 팝업
	@RequestMapping(value = "/common/setMyCatalogPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String setMyCatalogPop_v2(ModelMap pModel,HttpServletRequest request) {
		Map<String, String> pMap = new HashMap<String, String>();
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		List<Map<String, String>> _data = buyerMdCmMyGoodsSearchService.getMyCatalgList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/setMyCatalogPop_v2";
	}
}
