package com.koreab2b.mro.master.mpvo.controller;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.master.mpvo.service.MasterMpVoStateDownloadService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoStateDownloadController")
public class MasterMpVoStateDownloadController {

	@Autowired
	private MasterMpVoStateDownloadService masterMpVoStateDownloadService;
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpvo/excelMasterMpVoStateDownloadList.do",  method = RequestMethod.POST)
	public void excelList(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletResponse response, OutputStream outputStream) {
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = masterMpVoStateDownloadService.getList(pMap); 
		   
		String title = "시스템구분|구매회원사|요청번호|VOC_유형_상위|VOC_유형_하위|진행상태|처리요청일|처리희망일|접수일|접수시간|처리일|처리시간|요청자|요청자전화번호|접수부서코드|접수자|접수부서|처리부서코드|처리자|처리부서|발주번호|품목코드|처리기간|고객평가|클레임등급|귀책타입|귀책협력사|고객사코드|건설사현장명|건설사현장코드|요청내역|진행내역_A|진행내역_B|진행내역_C|처리내역|접수자구분";
		String headers = "SYS_TYPE|BUYER_NAME|VC_NO|CLAIM_MASTER|CLAIM_TEXT|RECV_FLAG_TEXT|REQ_DATE|PH_DATE|CD_DATE|CD_TIME|DF_DATE|DF_TIME|REQ_USER_NAME|REQ_USER_TEL|CD_DEPT|CD_USER_NAME|CD_DEPT_NAME|DS_DEPT|DS_USER_NAME|DS_DEPT_NAME|PO_NO|BUYER_ITEM_NO|LEAD_TIME|RUB_TYPE|CLAIM_GRADE|IMPUTE_TYPE|AGENT_NAME|BUYER|MRO_AREA_TEXT|MRO_AREA_CODE|REQ_REMARK|DS_REMARK_A|DS_REMARK_B|DS_REMARK_C|DF_REMARK|SYS_FLAG_TEXT";
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "VOC상세현황.xls");
	}
		
}
