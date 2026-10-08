package com.koreab2b.mro.master.mprq.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqBulkQuotationProceListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationProcetListController")
public class MasterMpRqBulkQuotationProceListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationProceListController.class);

	@Autowired
	private MasterMpRqBulkQuotationProceListService MasterMpRqBulkQuotationService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationProceList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBulkQuotationProceList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		LOGGER.debug("searchMasterMpRqQuotationBulkList 요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqBulkQuotationProceList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap, HttpServletResponse response, OutputStream outputStream    ) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		String docu_name = "벌크소싱 견적현황.xls";
		String title = "";
		String title2 = "";
		String headers  = "";
		
		List<Map<String, String>> _agentdata =  MasterMpRqBulkQuotationService.getAgentList(pMap);
		
		pMap.put("agentList",_agentdata);
		
		List<Map<String, String>> _data = MasterMpRqBulkQuotationService.getExcelList(pMap);
		
		title = "키값|프로젝트코드|프로젝트명|그룹명/고객사명|견적마감일|진행상태|견적번호|견적현황|일괄담당자|SG|SG담당자|GPL|고객사 카탈로그 정보|고객사 카탈로그 정보|고객사 카탈로그 정보|고객사 카탈로그 정보|고객사 카탈로그 정보|고객사 카탈로그 정보|고객사 카탈로그 정보|"
				+"KeP 품목정보|KeP 품목정보|KeP 품목정보|KeP 품목정보|KeP 품목정보|KeP 품목정보|KeP 품목정보|발주횟수|수량|메인사업장|기존단가|";
		title2 = "키값|프로젝트코드|프로젝트명|그룹명/고객사명|견적마감일|진행상태|견적번호|견적현황|일괄담당자|SG|SG담당자|GPL|품명|규격|모델명|제조사|MOQ|발주배수|단위|"+
				"품명|규격|모델명|제조사|MOQ|발주배수|단위|발주횟수|수량|메인사업장|기존단가|";
		headers = "ITEM_KEY_ID|BURQ_NO|PROJECT_NAME|BUYER_NAME|ATOS_END_DATE|STATUS|BURQ_RFQ_NO|RECEIPT_CNT|AGENT_MNG_USER_NAME|SG_NAME|SM_USER_NAME|GPL_YN|KEP_DESCRIPTION|KEP_SPECIFICATION|KEP_MAKER_PART_NO|KEP_MAKER_NAME|KEP_MIN_ORDER_QTY|KEP_PUR_UNIT_QTY|KEP_UNIT_MEASURE|SM_DESCRIPTION|SM_SPECIFICATION|SM_MAKER_PART_NO|SM_MAKER_NAME|SM_MIN_ORDER_QTY|SM_PUR_UNIT_QTY|SM_UNIT_MEASURE|PO_CNT|ITEM_QTY|MAIN_BUYER|RE_LIST_PRICE|";				

		for(int i = 0; i < _agentdata.size(); i++) {
			
			title += _agentdata.get(i).get("AGENT_NAME")+ "|";
			title2 += _agentdata.get(i).get("AGENT")+"|";
			headers += "'"+_agentdata.get(i).get("AGENT")+"'|";
		}
		
		String excelHeader = title + "@@" + title2 + "@@" + headers;
		CommonUtil.downloadExcel2Headers(_data, response, outputStream, excelHeader, docu_name);
	}
	
	// 동일 단가 적용
	@RequestMapping(value = "/mprq/updateMasterMpRqBulkQuotationSamePrice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> finishMasterMpRqBulkQuotationProceList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("updateMasterMpRqBulkQuotationSamePrice 요청 파라미터 : {}", pMap);
				 
		String rtnMsg = MasterMpRqBulkQuotationService.setSamePrice(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
		
	}
	
	// DM 메일발송 이력
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationDmHistPop.do", method = {RequestMethod.POST, RequestMethod.GET})
	public String getMasterMpRqBulkQuotationDmHistPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		 
		LOGGER.debug("getMasterMpRqBulkQuotationDmHistPop 요청 파라미터 : {}", pMap);
		List<Map<String, String>> _data = MasterMpRqBulkQuotationService.getDmPop(pMap);		
		
		pModel.addAttribute("data", _data);			
		
		return "/common/popup/mprq/masterMpRqBulkQuotationDmHistPop";
	}
	
}
