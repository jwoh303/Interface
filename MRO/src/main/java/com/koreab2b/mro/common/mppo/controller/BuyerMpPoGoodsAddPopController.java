package com.koreab2b.mro.common.mppo.controller;

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

import com.koreab2b.mro.common.mppo.service.BuyerMpPoGoodsAddPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoGoodsAddPopController")
public class BuyerMpPoGoodsAddPopController { 
	@Autowired
	private BuyerMpPoGoodsAddPopService buyerMpPoGoodsAddPopService;
	
	/**
	 * 상품추가 조회 PG_06_B_018_02
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoGoodsAddPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoGoodsAddPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("com_code", _sessionInfo.getComCode() );
		pMap.put("bycaComorgCode", _sessionInfo.getBycaComorgCode() );
		pMap.put("user_dept", _sessionInfo.getDepartment() );
		
		
		List<Map<String, String>> _info = buyerMpPoGoodsAddPopService.getInfoList(pMap); 
		List<Map<String, String>> _data = null;
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		if ("N".equals(pMap.get(("openYn").toString()))){
			_data = buyerMpPoGoodsAddPopService.getList(pMap); 
		}
		
		//getBuyerCartInfo
		pModel.addAttribute("info", CommonUtil.getListNvl(_info)); 
		pModel.addAttribute("data", _data); 
		
		
		pModel.addAttribute("view", "LIST"); 
		
		return "common/popup/mppo/buyerMpPoGoodsAddPop";
	}	 
	

	
	
	/**
	 * 상품추가
	 * /kr/customer/shopping_cart/buyer_new_order_item_add.jsp
	 */
	@RequestMapping(value = "/mppo/saveSetItemAdd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSetItemAdd(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("com_code", _sessionInfo.getComCode() );
		pMap.put("bycaComorgCode", _sessionInfo.getBycaComorgCode() );
		pMap.put("user_dept", _sessionInfo.getDepartment() );
		
		
		String msg = buyerMpPoGoodsAddPopService.saveSetItemAdd(pMap);
		
		String createOk = "UPDATE_OK";
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 상품추가 조회 cate_search_item_add_detail
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoGoodsAddDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoGoodsAddDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("com_code", _sessionInfo.getComCode() );
		pMap.put("bycaComorgCode", _sessionInfo.getBycaComorgCode() );
		pMap.put("user_dept", _sessionInfo.getDepartment() );
		
		List<Map<String, String>> _info = buyerMpPoGoodsAddPopService.getInfoList(pMap);  
		
		
		List<Map<String, String>> _data1 = buyerMpPoGoodsAddPopService.getCatalogDisplayMain(pMap); 
		List<Map<String, String>> _data2 = buyerMpPoGoodsAddPopService.getItemSeries(pMap); 
		List<Map<String, String>> _data3 = buyerMpPoGoodsAddPopService.categoryPathViewer(pMap); 
		
		pModel.addAttribute("info", CommonUtil.getListNvl(_info));
		pModel.addAttribute("detail_data1", CommonUtil.getListNvl(_data1));
		pModel.addAttribute("detail_data2", CommonUtil.getListNvl(_data2));  
		pModel.addAttribute("detail_data3", CommonUtil.getListNvl(_data3));  
		
		
		pModel.addAttribute("view", "DETAIL"); 
		
		return "common/popup/mppo/buyerMpPoGoodsDetailAddPop";
	}	 
	
	
	
}
