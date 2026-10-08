package com.koreab2b.mro.seller.mdct.controller;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mdct.service.SellerMdCtUserRegRequestReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtUserRegRequestReceiptController")
public class SellerMdCtUserRegRequestReceiptController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtUserRegRequestReceiptController.class);

	@Autowired
	private SellerMdCtUserRegRequestReceiptService sellerMdCtUserRegRequestReceiptService;
	
	// 조회
	@RequestMapping(value = "/mdct/getSellerMdCtUserRegRequestReceiptList.do", method = RequestMethod.POST)
	public String getSellerMdCtUserRegRequestReceiptList(ModelMap pModel , HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		
		logger.debug("/mdct/getSellerMdCtUserRegRequestReceiptList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMdCtUserRegRequestReceiptService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mdct/sellerMdCtUserRegRequestReceiptList";
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveSellerMdCtUserRegRequestReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdCtUserRegRequestReceipt(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		logger.debug("/mdam/saveBuyerMdAmUserRegRequestReceiptList.do Map 요청 파라미터 : formData === {}", pMap);		
		
		String flag = sellerMdCtUserRegRequestReceiptService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
}
