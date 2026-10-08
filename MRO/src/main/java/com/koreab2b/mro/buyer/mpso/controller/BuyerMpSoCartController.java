package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartController")
public class BuyerMpSoCartController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartController.class);

	@Autowired
	private BuyerMpSoCartService buyerMpSoCartService;
	
	// 조회 PG_06_B_006_00 - 장바구니 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoCartList(ModelMap pModel  ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoCartList.do 요청 파라미터 : {}", pMap);

		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			
			pMap.put("st_buyer",_sessionInfo.getComCode());
			String buyer = _sessionInfo.getComCode();
			pMap.put("st_user_id",_sessionInfo.getUserId());
			//pMap.put("st_buyer",_sessionInfo.getComCode());
			pMap.put("st_user_dept",_sessionInfo.getDepartment());
			
			
			pMap.put("refNoType", "N");
			// 관리번호  매핑 사용 (O/X)
			String p060000124 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000124","COL01_DATA"); // 권한특수로직
			if(p060000124 != null && !p060000124.equals("")) {
				pMap.put("refNoType", p060000124);
			}
			List<Map<String, String>> nexeAccountList = null;		
			nexeAccountList = buyerMpSoCartService.getNexeAccountList(pMap);		
			pModel.addAttribute("nexeAccountList", CommonUtil.getListNvl(nexeAccountList));
			//logger.debug("11111111111111111111111 {} " , pMap);
				
			String st_query_cart = "";
			List<Map<String, String>> _data = null;
	 
		    String listQuery = "2";
		    
			String rowCntTmp = CommonUtil.onvl(pMap.get("onepagerow"),_sessionInfo.getRowCnt());
			String pageString = "30,50,100,200,500,1000";
			if(!Arrays.asList(pageString.split(",")).contains(rowCntTmp)){
				rowCntTmp = "30";
			}
			//100이하면 100으로 고정해주기
			if(Integer.parseInt(rowCntTmp) <= 100){
			    rowCntTmp = "100";
			}
			
			pMap.put("onepagerow",rowCntTmp);
			
			pMap.put("st_verif_num", CommonUtil.onvl(pMap.get("st_verif_num") ,"") );
			pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart") ,"ALL") ); 
			pMap.put("st_listQuery", CommonUtil.onvl(pMap.get("st_listQuery") ,listQuery) ); 
			pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"c_date") ); 
			//선입고 장바구니 여부
			pMap.put("st_pre_gr_flag", "N");
			
			st_query_cart = pMap.get("st_query_cart").toString();
			// 페이징처리
			pMap = CommonUtil.PagingPrc(pMap); 
			// 화면 조회
			pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
			if("ALL".equals(st_query_cart) || "".equals(st_query_cart)){
				_data = buyerMpSoCartService.getShoppintCartSelectSql_v2(pMap);
			}else{
				_data = buyerMpSoCartService.getBuyerShoppingCartOrderListConfirm(pMap);
			}
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
			
			return "buyer/mpso/buyerMpSoCartList_v2";
		}else{
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			
			pMap.put("st_buyer",_sessionInfo.getComCode());
			String buyer = _sessionInfo.getComCode();
			pMap.put("st_user_id",_sessionInfo.getUserId());
			//pMap.put("st_buyer",_sessionInfo.getComCode());
			pMap.put("st_user_dept",_sessionInfo.getDepartment());
			
			
			pMap.put("refNoType", "N");
			// 관리번호  매핑 사용 (O/X)
			String p060000124 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000124","COL01_DATA"); // 권한특수로직
			if(p060000124 != null && !p060000124.equals("")) {
				pMap.put("refNoType", p060000124);
			}
			List<Map<String, String>> nexeAccountList = null;		
			nexeAccountList = buyerMpSoCartService.getNexeAccountList(pMap);		
			pModel.addAttribute("nexeAccountList", CommonUtil.getListNvl(nexeAccountList));
			//logger.debug("11111111111111111111111 {} " , pMap);
				
			String st_query_cart = "";
			List<Map<String, String>> _data = null;
			List<Map<String, String>> _Hdata = null; 
	 
			//StringBuilder sb = new StringBuilder(); 		 

			
		    String listQuery = "2";
		    /*
		    if(buyer.equals("KRCOWA0001")||
		    		buyer.equals("KRCOWA0002")||
		    		buyer.equals("KRCOWA0003")||
		    		buyer.equals("KRCOWA0004")||
		    		buyer.equals("KRCOWA0005")||
		    		buyer.equals("KRCOWA0006")){
		    	listQuery = "1";
		    } 
		    */
		    //SLOGIC-BEGIN(P06-0000036) 
		    //코웨이일경우
		    String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL03_DATA"); // 권한특수로직
		    if ("COWAY".equals(p060000036)){
		    	listQuery = "1";
		    }
		    //SLOGIC-END
		
		    //logger.debug("2222222222222222 {} " , pMap);
			pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,(String)_sessionInfo.getRowCnt()) );
			pMap.put("st_verif_num", CommonUtil.onvl(pMap.get("st_verif_num") ,"") );
			pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart") ,"ALL") ); 
			pMap.put("st_listQuery", CommonUtil.onvl(pMap.get("st_listQuery") ,listQuery) ); 
			pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"c_date") ); 
			//선입고 장바구니 여부
			pMap.put("st_pre_gr_flag", "N");
			
			//logger.debug("33333333333333 {} " , pMap);
			st_query_cart = pMap.get("st_query_cart").toString();
			//logger.debug("4444444444444 {} " , pMap);
			// 페이징처리
			pMap = CommonUtil.PagingPrc(pMap); 
			//logger.debug("5555555555 {} " , pMap);
			// 화면 조회
			pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
			//logger.debug("66666666666666 {} " , pMap);
			if("ALL".equals(st_query_cart) || "".equals(st_query_cart)){
				_data = buyerMpSoCartService.getShoppintCartSelectSql(pMap);
			}else{
				_data = buyerMpSoCartService.getBuyerShoppingCartOrderListConfirm(pMap);
			}
			//logger.debug("77777777777777 {} " , pMap);
			// 홍익대학교-- 대학원 소속 체크. 
			_Hdata = buyerMpSoCartService.getHongIkType(pMap);
		 
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
			//logger.debug("888888888888 {} " , pMap);
			if (_Hdata == null){
				pModel.addAttribute("Hdata", "");
			}else{
				pModel.addAttribute("Hdata", CommonUtil.nvl(  _Hdata.get(0).get("FLAG"),"0"));
			}
			//logger.debug("9999999999999999999 {} " , pMap);
			
			//홍익대학교-- 품의서 양식 확인.
			List<Map<String, String>> _HdataSheetType = buyerMpSoCartService.getHongIkSheetType(pMap);
			if (_Hdata == null){
				pModel.addAttribute("HdataSheetType", "");
			}else{
				pModel.addAttribute("HdataSheetType", (_HdataSheetType !=null && _HdataSheetType.size()>0)?CommonUtil.nvl(  _HdataSheetType.get(0).get("FLAG"),""): "");
			}
			//선입고 장바구니 구분값 추가
			pModel.addAttribute("HdataPreGrFlag", "N");
			
			return "buyer/mpso/buyerMpSoCartList";
		}
		
	}
	// 선입고 장바구니
	@RequestMapping(value = "/mpso/getBuyerMpSoPreGrCartList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoPreGrCartList(ModelMap pModel  ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_buyer",_sessionInfo.getComCode());
		String buyer = _sessionInfo.getComCode();
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		//선입고 장바구니 여부
		pMap.put("st_pre_gr_flag", "Y");
		pMap.put("refNoType", "N");
		// 관리번호  매핑 사용 (O/X)
		String p060000124 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000124","COL01_DATA"); // 권한특수로직
		if(p060000124 != null && !p060000124.equals("")) {
			pMap.put("refNoType", p060000124);
		}
		
			
		String st_query_cart = "";
		List<Map<String, String>> _data = null;
		List<Map<String, String>> _Hdata = null; 
 
	    String listQuery = "2";
	    //SLOGIC-BEGIN(P06-0000036) 
	    //코웨이일경우
	    String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL03_DATA"); // 권한특수로직
	    if ("COWAY".equals(p060000036)){
	    	listQuery = "1";
	    }
	    //SLOGIC-END
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,(String)_sessionInfo.getRowCnt()) );
		pMap.put("st_verif_num", CommonUtil.onvl(pMap.get("st_verif_num") ,"") );
		pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart") ,"ALL") ); 
		pMap.put("st_listQuery", CommonUtil.onvl(pMap.get("st_listQuery") ,listQuery) ); 
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"c_date") ); 
		
		st_query_cart = pMap.get("st_query_cart").toString();
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		if("ALL".equals(st_query_cart) || "".equals(st_query_cart)){
			_data = buyerMpSoCartService.getShoppintCartSelectSql(pMap);
		}else{
			_data = buyerMpSoCartService.getBuyerShoppingCartOrderListConfirm(pMap);
		}
		// 홍익대학교-- 대학원 소속 체크. 
		_Hdata = buyerMpSoCartService.getHongIkType(pMap);
	 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		if (_Hdata == null){
			pModel.addAttribute("Hdata", "");
		}else{
			pModel.addAttribute("Hdata", CommonUtil.nvl(  _Hdata.get(0).get("FLAG"),"0"));
		}
		
		//홍익대학교-- 품의서 양식 확인.
		List<Map<String, String>> _HdataSheetType = buyerMpSoCartService.getHongIkSheetType(pMap);
		if (_Hdata == null){
			pModel.addAttribute("HdataSheetType", "");
		}else{
			pModel.addAttribute("HdataSheetType", (_HdataSheetType !=null && _HdataSheetType.size()>0)?CommonUtil.nvl(  _HdataSheetType.get(0).get("FLAG"),""): "");
		}
		//선입고 장바구니 구분값 추가
		pModel.addAttribute("HdataPreGrFlag", "Y");
		
		return "buyer/mpso/buyerMpSoCartList";
	}
	/**
	 * 바로주문 CART,ORDER
	 * kr/customer/shopping_cart/buyer_yuhan_cart_update.jsp
	 */
	@RequestMapping(value = "/mpso/saveBuyerYuhanCartUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerYuhanCartUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.saveBuyerYuhanCartUpdate(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 저장
	 * /kr/customer/shopping_cart/buyer_shoppingcart_qty_update.jsp
	 */
	@RequestMapping(value = "/mpso/saveBuyerShoppingcartQtyUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerShoppingcartQtyUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.saveBuyerShoppingcartQtyUpdate(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 저장
	 * 
	 */
	@RequestMapping(value = "/mpso/saveBuyerShoppingcartQtyCowayUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerShoppingcartQtyCowayUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.saveBuyerShoppingcartQtyCowayUpdate(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 삭제
	 * /kr/customer/categ_search/buyer_shoppingcart_mycart_del_reg.jsp
	 */
	@RequestMapping(value = "/mpso/removeBuyerShoppingcartMycartDelReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeBuyerShoppingcartMycartDelReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.removeBuyerShoppingcartMycartDelReg(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 삭제
	 * /kr/customer/categ_search/buyer_shoppingcart_mycart_del_reg.jsp
	 */
	@RequestMapping(value = "/mpso/removeBuyerShoppingcartMycartClcsDelReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeBuyerShoppingcartMycartClcsDelReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.removeBuyerShoppingcartMycartClcsDelReg(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 장바구니 저장 
	 * 
	 */
	@RequestMapping(value = "/mpso/saveBuyerShoppingcartSizeQtyUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerShoppingcartSizeQtyUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("department", _sessionInfo.getDepartment());
		
		String msg = "";
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			msg = buyerMpSoCartService.saveBuyerShoppingcartSizeQtyUpdate_v2(pMap);
		}else{
			msg = buyerMpSoCartService.saveBuyerShoppingcartSizeQtyUpdate(pMap);
		}
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 인터페이스 전송
	 *
	 */
	@RequestMapping(value = "/mpso/transferBuyerShoppingcartQtyUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> transferBuyerShoppingcartQtyUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.transferBuyerShoppingcartUpdate(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * PunchoutMessage XML 생성
	 *
	 */
	@RequestMapping(value = "/mpso/getPunchoutOrderMessage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderMessage(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		_msg = buyerMpSoCartService.getPunchoutOrderMessage(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * PunchoutMessage XML 생성
	 *
	 */
	@RequestMapping(value = "/mpso/getPunchoutOrderMessageFagb.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderMessageFagb(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		_msg = buyerMpSoCartService.getPunchoutOrderMessageFagb(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	@RequestMapping(value = "/mpso/getPunchoutOrderMessagePMK.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderMessagePMK(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		_msg = buyerMpSoCartService.getPunchoutOrderMessagePMK(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	@RequestMapping(value = "/mpso/getPunchoutOrderMessageYHKB.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderMessageYHKB(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		_msg = buyerMpSoCartService.getPunchoutOrderMessageYHKB(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * PunchoutMessage XML 생성
	 *
	 */
	@RequestMapping(value = "/mpso/getPunchoutOrderMessageTEST.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderMessageTEST(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		_msg = buyerMpSoCartService.getPunchoutOrderMessageTEST(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/***
	 * 체크아웃 - 유큐브 타입
	 */
	@RequestMapping(value = "/mpso/setPunchoutUcube.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutOrderUcubeMessage(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _msg = new HashMap<String, String>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = "";
		
		if (pMap.get("st_cart_type")==null){			
			LOGGER.debug("st_cart_type X : {}");
			pMap.put("st_cart_type","");
		}else{
			LOGGER.debug("st_cart_type O : {}");
		}
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("legacy_user_id", _sessionInfo.getEmpNo() );
		
		msg = buyerMpSoCartService.setPunchoutUcube(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/**
	 * 카트 내역 업데이트
	 *
	 */
	@RequestMapping(value = "/mpso/deletePunchoutOrderMessageShoppingcart.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deletePunchoutOrderMessageShoppingcart(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpSoCartService.deletePunchoutOrderMessageShoppingcart(pMap);
		
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
		
	@RequestMapping(value = "/mpso/getPunchoutURL.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPunchoutURL(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		String url = buyerMpSoCartService.getPunchoutURL(pMap);
		String msg   = "PROCESS_OK";
		
		_msg.put("pURL", url);
		_msg.put("MSG", msg); 
		
		_response.put("msg", _msg);
		return  _response;
	}
	
	@RequestMapping(value = "/mpso/excelBuyerMpSoCartList.do", method = RequestMethod.POST)
	@ResponseBody
	public void excelBuyerMpSoCartList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
	
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		pMap.put("refNoType", "N");
		
		List<Map<String, String>> _data = new ArrayList<Map<String,String>>();
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			_data = buyerMpSoCartService.getShoppintCartSelectSql_v2(pMap);
		}else {
			_data = buyerMpSoCartService.getShoppintCartSelectSql(pMap);
		}
		
		
		
		String title = "";
		String headers = "";
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String p060000115 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000115","COL01_DATA");
		
		if(p060000115.equals("TYPE01")){
			title = "순번|품목코드|품목명|규격|제조사|단위|계정명|예산부서|단가|구매수량|구매금액|품목비고|수령인|전화번호|도착지정보|";
			headers = "NO|BUYER_ITEM_NO|DESCRIPTION_LOC|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|ACCOUNT_NAME|BUDGET_DEPT_NAME|TARGET_PRICE|CART_QTY|TOT_SUM|REMARK|RECV_USER_NAME|RECV_USER_TEL|DELY_TO_LOCATION_TEXT|";
		}else {
			title = "순번|품목코드|품목명|규격|제조사|단위|계정명|예산부서|단가|구매수량|구매금액|품목비고|";
			headers = "NO|BUYER_ITEM_NO|DESCRIPTION_LOC|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|ACCOUNT_NAME|BUDGET_DEPT_NAME|TARGET_PRICE|CART_QTY|TOT_SUM|REMARK";
		}
	
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"장바구니.xls");
	}
}