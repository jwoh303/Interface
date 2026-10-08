package com.koreab2b.mro.common.mdsr.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdsr.service.MasterMdSrSrDetailPopService;
import com.koreab2b.mro.master.cmcl.service.MasterCmClIndividualService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdSrSrDetailPopController")
public class MasterMdSrSrDetailPopController {
	@Autowired
	private MasterMdSrSrDetailPopService masterMdSrSrDetailPopService;
	@Autowired
	private MasterCmClIndividualService masterCmClIndividualService;
	/**
	 * S/R 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdsr/getMasterMdSrSrDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdSrSrDetailPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		String st_sr_user_id = CommonUtil.nvl((String) pMap.get("st_sr_user_id"), "");
		String st_sr_no = CommonUtil.nvl((String) pMap.get("st_sr_no"), "");
		
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		String st_user_id = _sessionInfo.getUserId();
		
		pMap.put("st_user_id", st_user_id);
		pMap.put("st_sr_user_id", st_sr_user_id);
		pMap.put("st_sr_no", st_sr_no);
		List<Map<String, String>> _data = masterMdSrSrDetailPopService.getMasterMdSrSrDetailPop(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("st_sr_user_id", st_sr_user_id);
		pModel.addAttribute("st_sr_no", st_sr_no);
		return "common/popup/mdsr/masterMdSrSrDetailPop";
	}
	
	/**
	 * ajax 처리 S/R 상세정보 update 처리
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdsr/saveMasterMdSrSrDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdSrSrDetailPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMdSrSrDetailPopService.saveMasterMdSrSrDetailPop(pMap);
		_response.put("msg", _result);
		return _response;
	}
	// EXCEL 다운로드
	@RequestMapping(value = "/mdsr/excelMasterMdsrPoGrList.do", method = RequestMethod.POST)
	public void excelMasterMdsrPoGrList(ModelMap pModel, @RequestParam Map<String, Object> pMap,
			HttpServletRequest req, HttpServletResponse response, OutputStream outputStream) {


		List<Map<String, String>> _data = masterMdSrSrDetailPopService.getExcelMasterPoGrList(pMap);

		String title = "구매사|진행상태|발주번호|IF발주번호|협력사|협력사사업자번호|품목코드|관리번호|생성일|발주일|납기요청일|입고일|납품예정일|납품일|확정일|품명|규격|제조사|단위|발주수량|입고수량|납품수량|확정수량|매출단가|매출금액|매출금액_부가세|입고매출금액|매입단가|매입금액|입고매입금액|발주부서|발주자|요청부서|요청자|발주항번|주문항번|AGENT_CODE|계약서번호|계약서항번|구매사코드|카탈로그관리코드|카탈로그관리명|발주자ID|요청자ID|DS_REMARK|INVOICE_DATE2|DS_DATE2|SCM_REMARK|발주삭제사유|협력사사업자번호|V_BUYER_CATEG_ID|V_BUYER_CATEG_NAME|V_BUYER_CATEG_PATH|SG명|SG_ID|표준카탈로그|표준카테고리ID|카테고리경로|I_F관리번호|비고|거래유형|실공급사코드|실공급사명|비고2|UNIT_TAX|LOG_TEXT|HA_DATE|WAREHOUSE_NAME|입고번호|입고항번|PR번호|PR순번|예산부서|예산계정|예산계정명|KEP_납품예정일|협력사납품예정일|";
		String headers =  "구매사|진행상태|발주번호|IF발주번호|협력사|협력사사업자번호|품목코드|관리번호|생성일|발주일|납기요청일|입고일|납품예정일|납품일|확정일|품명|규격|제조사|단위|발주수량|입고수량|납품수량|확정수량|매출단가|매출금액|매출금액_부가세|입고매출금액|매입단가|매입금액|입고매입금액|발주부서|발주자|요청부서|요청자|발주항번|주문항번|AGENT_CODE|계약서번호|계약서항번|구매사코드|카탈로그관리코드|카탈로그관리명|발주자ID|요청자ID|DS_REMARK|INVOICE_DATE2|DS_DATE2|SCM_REMARK|발주삭제사유|협력사사업자번호|V_BUYER_CATEG_ID|V_BUYER_CATEG_NAME|V_BUYER_CATEG_PATH|SG명|SG_ID|표준카탈로그|표준카테고리ID|카테고리경로|I_F관리번호|비고|거래유형|실공급사코드|실공급사명|비고2|UNIT_TAX|LOG_TEXT|HA_DATE|WAREHOUSE_NAME|입고번호|입고항번|PR번호|PR순번|예산부서|예산계정|예산계정명|KEP_납품예정일|협력사납품예정일|";

		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "SR_발주_입고리스트.xls");

	}
	
	// EXCEL 다운로드
	@RequestMapping(value = "/mdsr/excelMasterMdsrArList.do", method = RequestMethod.POST)
	public void excelMasterMdsrArList(ModelMap pModel, @RequestParam Map<String, Object> pMap,
			HttpServletRequest req, HttpServletResponse response, OutputStream outputStream) {


		List<Map<String, String>> _data = masterCmClIndividualService.getList(pMap);

		String title = "연번|당사사업장|사업자등록번호|고객사명|팀구분(*)|입고일(*)|입고금액|발주번호|입고번호|입고항번|고객사코드|당사사업자번호|사이트구분코드|품명|규격|협력사명|협력사코드|발주자ID|발주자명|발주부서|발주비고|IF_PO_NO|관리번호1|관리번호2|카테고리명|카테고리코드|품목코드|요청자|팀구분코드|주문항번|"; 
		String headers =  "TAX_SERIAL|KEP_IRS_NAME|BUYER_IRS_NO|BUYER_NAME|KEP_DEPT|GR_DATE|GR_AMT|PO_NO|GR_NO|GR_SEQ|BUYER|KEP_IRS_NO|SITE_GUBUN_CODE|DESCRIPTION|SPECIFICATION|AGENT_NAME|AGENT|PO_USER_ID|PO_USER_NAME|PO_DEPT|PO_REMARK|LEGACY_PO_NO|REF_IF_NO|REF_PR_NO|CATEG_NAME|CATEG_CODE|ITEM_NO|PURCHASER_NAME|KEP_DEPT_CODE|LEGACY_PO_SEQ|";

		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "SR_마감거래명세서건별.xls");

	}
	// EXCEL 다운로드
	@RequestMapping(value = "/mdsr/excelMasterMdsrRerList.do", method = RequestMethod.POST)
	public void excelMasterMdsrRerList(ModelMap pModel, @RequestParam Map<String, Object> pMap,
			HttpServletRequest req, HttpServletResponse response, OutputStream outputStream) {


		List<Map<String, String>> _data = masterMdSrSrDetailPopService.getExcelMasterReList(pMap);

		String title = "고객사명|진행상태|품목코드|견적번호|견적순번|차수(B/S)|견적의뢰일|회신요청일|견적제출일|품목명|규격|제조사|원산지|단위|견적요청일|견적마감일|수량|목표단가(고)|목표단가(운)|매출단가|매입단가|선정협력사|요청자|요청부서|담당자|고객사비고|합의일자|거래유형|물류센터|수입여부|PLANT|고객사코드|고객사규격|관리번호|";
		String headers =  "고객사명|진행상태|품목코드|견적번호|견적순번|차수(B/S)|견적의뢰일|회신요청일|견적제출일|품목명|규격|제조사|원산지|단위|견적요청일|견적마감일|수량|목표단가(고)|목표단가(운)|매출단가|매입단가|선정협력사|요청자|요청부서|담당자|고객사비고|합의일자|거래유형|물류센터|수입여부|PLANT|고객사코드|고객사규격|관리번호|";

		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "SR_견적리스트.xls");

	}
}
