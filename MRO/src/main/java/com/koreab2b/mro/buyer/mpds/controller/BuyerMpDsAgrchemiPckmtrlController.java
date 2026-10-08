package com.koreab2b.mro.buyer.mpds.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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

import com.koreab2b.mro.buyer.mpds.service.BuyerMpDsAgrchemiPckmtrlService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsAgrchemiPckmtrlController")
public class BuyerMpDsAgrchemiPckmtrlController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsAgrchemiPckmtrlController.class);

	@Autowired
	private BuyerMpDsAgrchemiPckmtrlService buyerMpDsAgrchemiPckmtrlService;
	
	// 조회
	@RequestMapping(value = "/mpds/getBuyerMpDsAgrchemiPckmtrlList.do", method = RequestMethod.POST)
	public String getBuyerMpDsAgrchemiPckmtrlList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpds/getBuyerMpDsAgrchemiPckmtrlList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpDsAgrchemiPckmtrlService.getList(pMap);
		List<Map<String,String>> _dataSub = buyerMpDsAgrchemiPckmtrlService.getListSub(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAttribute("dataSub", _dataSub);
		pModel.addAllAttributes(pMap);
		
		return "buyer/mpds/buyerMpDsAgrchemiPckmtrlList";
	}
	
	// 저장
	@RequestMapping(value = "/mpds/saveBuyerMpDsAgrchemiPckmtrlList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpDsAgrchemiPckmtrl(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mpds/saveBuyerMpDsAgrchemiPckmtrlList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpDsAgrchemiPckmtrlService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpds/excelBuyerMpDsAgrchemiPckmtrlList.do", method = RequestMethod.POST)
	public void excelBuyerMpDsAgrchemiPckmtrl(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpds/excelBuyerMpDsAgrchemiPckmtrlList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpDsAgrchemiPckmtrlService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String title = "발주번호|구매전표|제품코드|검사로트|입고번호|자재문서|납기요청일|입고일자|입고수량|단위|발주일자|품목명|규격|검사항목(외관)|검사항목(사이즈)|검사항목(재질)|검사항목(중량)|검사항목(용량)|검사항목(두께)|검사항목(압축)|검사항목(파열강도)|검사항목(수분)|협력사|처리방법";
		String headers = "PO_NO|LEGACY_PO_NO|BUYER_ITEM_NO|ITEM_CHECK_NO|GR_NO|LEGACY_GR_NO|RD_DATE|GR_DATE|ITEM_QTY|UNIT_MEASURE|PO_CREATE_DATE|DESCRIPTION|SPECIFICATION|APPEAR_VAL|SIZE_VAL|MATTER_VAL|WEIGHT_VAL|CAPACITY_VAL|DENSITY_VAL|COMPRESSION_F|DISRUPTION_F|MOISTURE_F|AGENT_TEXT|UD_TEXT";
		
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"농약포장재.xls");
		 
	}
}
