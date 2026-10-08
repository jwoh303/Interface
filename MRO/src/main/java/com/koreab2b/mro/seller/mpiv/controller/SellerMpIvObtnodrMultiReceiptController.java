package com.koreab2b.mro.seller.mpiv.controller;

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

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvObtnodrMultiReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvObtnodrMultiReceiptController")
public class SellerMpIvObtnodrMultiReceiptController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvObtnodrMultiReceiptController.class);

	@Autowired
	private SellerMpIvObtnodrMultiReceiptService sellerMpIvObtnodrMultiReceiptService;
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrMultiReceiptList.do", method = RequestMethod.POST)
	public String getSellerMpIvObtnodrMultiReceiptList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvObtnodrMultiReceiptList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvObtnodrMultiReceiptService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvObtnodrMultiReceiptList";
	}
		
	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mpiv/excelSellerMpIvObtnodrMultiReceiptList.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvObtnodrMultiReceiptList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		//pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvObtnodrMultiReceiptService.getExcelList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());

		String title = "고객사|품목코드|품목명|규격|제조사|수량|단위|발주일|납기요청일|고객사코드|PO번호|PO순번|비고|관리번호|KeP담당자|담당자연락처|요청자|요청부서|도착지|발주금액|비고2|협력사폼목코드";
		String headers = "BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|ITEM_QTY|UNIT_MEASURE|PO_CREATE_DATE|RD_DATE|BUYER|PO_NO|PO_SEQ|PO_REMARK|REF_PR_NO|USER_NAME_LOC|USER_PHONE_NUMBER|ADD_USER_NAME|REQ_USER_DEPT|DELY_TO_LOCATION_TEXT|ITEM_AMT|PO_HD_REMARK|SELLER_ITEM_NO";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "수주접수_리스트.xls");
 
	}
	
	/**
	 * 수주접수 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvObtnodrMultiReceiptList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvObtnodrMultiReceiptList(ModelMap pModel, HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap);

		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvObtnodrMultiReceiptService.saveSellerMpIvObtnodrMultiReceiptList(_pMap, _list);
		
		_response.put("msg", flag);
		
		return _response;
	}
}
