package com.koreab2b.mro.seller.mpcl.controller;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
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
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpcl.service.SellerMpClCmsCmplReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClCmsCmplReqController")
public class SellerMpClCmsCmplReqController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpClCmsCmplReqController.class);

	@Autowired
	private SellerMpClCmsCmplReqService sellerMpClCmsCmplReqService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClCmsCmplReqList.do", method = RequestMethod.POST)
	public String getSellerMpClCmsCmplReqList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClCmsCmplReqService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpcl/sellerMpClCmsReqList";
	}

	
	/**
	 * saveSellerMpClCmsCmplReqImg 품목보완 요청.
	 * 
	 * @param pMap
	 * @return
	 * 
	 */
	@RequestMapping(value = "/mpcl/saveSellerMpClCmsCmplReqItem.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpClCmsCmplReqItem(@ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
	
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("agentUserid", _sessionInfo.getUserId());
		pMap.put("agentComCode", _sessionInfo.getComCode());

		String msg = sellerMpClCmsCmplReqService.saveSellerMpClCmsCmplReqItem(uploadForm,pMap);
		_response.put("msg", msg);

		return _response;
	}

}
