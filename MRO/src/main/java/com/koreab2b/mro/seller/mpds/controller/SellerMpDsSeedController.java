package com.koreab2b.mro.seller.mpds.controller;

import java.io.OutputStream;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpds.service.SellerMpDsSeedService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsSeedController")
public class SellerMpDsSeedController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsSeedController.class);

	@Autowired
	private SellerMpDsSeedService sellerMpDsSeedService;
	
	// 조회
	@RequestMapping(value = "/mpds/getSellerMpDsSeedList.do", method = RequestMethod.POST)
	public String getSellerMpDsSeedList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpds/getSellerMpDsSeedList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpDsSeedService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		return "seller/mpds/sellerMpDsSeedList";
	}
	
	// 저장
	@RequestMapping(value = "/mpds/saveSellerMpDsSeedList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpDsSeed(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mpds/saveSellerMpDsSeedList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = sellerMpDsSeedService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpds/excelSellerMpDsSeedList.do", method = RequestMethod.POST)
	public void excelSellerMpDsSeed(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpds/excelSellerMpDsSeedList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpDsSeedService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String title = "구분|구분|품목코드|시작일|디자인완료일|1차컨펌완료일|최종확인일|품목명|규격|제조사|디자인완료|1차확인(PM)|1차확인(문안)|1차확인(사진)|1차확인(가공)|1차 확인(영업)|최종확인";
		String headers = "USE_TEXT|GUBUN|BUYER_ITEM_NO|RD_DATE|EE_DATE|DD_DATE|ES_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|MM_STATUS|ES_MK1_STATUS|ES_PD1_STATUS|ES_QA1_STATUS|ES_PD_STATUS|ES_MK_STATUS|ES_FI_STATUS";
		
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"종자리스트.xls");
	}
}
