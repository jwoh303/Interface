package com.koreab2b.mro.master.cmcl.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;
import com.koreab2b.mro.webservice.erp.debt.DebtInWebService;
import com.koreab2b.mro.webservice.erp.reverse.ReverseInWebService;

@Repository("masterCmClPurchaseTaxsheetIssueRegDao")
@Transactional
public class MasterCmClPurchaseTaxsheetIssueRegDaoImpl implements MasterCmClPurchaseTaxsheetIssueRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClPurchaseTaxsheetIssueRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private DebtInWebService debtInWebService;
	
	@Autowired
	private ReverseInWebService reverseInWebService;
	
	@Autowired
	private MasterCmClSmartBillUploadingCreationDao MasterCmClSmartBillUploadingCreationDao;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
		
		LOGGER.debug("job_kind ==>>{}<<==", param.get("job_kind"));
		
		if ( "excelDetailDown".equals(param.get("job_kind")) ) {
			sqlSessionTemplate.select("master.cmcl.selectMasterCmClPurchaseTaxsheetIssueRegList_Detail", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		} else { 
			sqlSessionTemplate.select("master.cmcl.selectMasterCmClPurchaseTaxsheetIssueRegList", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}
		
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "세금계산서 수정 완료 되었습니다.";
		String _jobKind = formData.get("job_kind");
		String count = "";
		String _bizErrMsg = null;
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if ( "APconfirm".equals(_jobKind) ) {
					
				} else {
					// 외상매입_세금계산서 update
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg", formData);
				}
				
			}
			if("APconfirm".equals(_jobKind)) {
				_rtnMsg = "마감제출 완료 되었습니다.";			
				
				// 마감제출 이미 완료된 사람 제출 불가(매입)
				count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClArTax_APbillCnt", formData);
								
				if(!count.equals("0")) {
					_bizErrMsg = "이미 마감제출 완료하였습니다.\n관리팀 확인 바랍니다.";
					throw new RuntimeException(_bizErrMsg);
				}
				// 미마감제출자 APDT정보에 없는 경우 DELETE 처리
				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClApBillCloseUserList", formData);
				
				// 마감확정내역 INSERT		
				sqlSessionTemplate.update("master.cmcl.InsertMasterCmClApCloseConfirm", formData);				
				
				count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClArBillCloseUserList", formData);
				if(Integer.parseInt(count) > 0) {					
					// 미마감제출자 UPDATE
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClApBillCloseUserList", formData);					
				} else {
					// 미마감제출자 INSERT
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApBillCloseUserList", formData);
				}
			
				// 마감제출 처리
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_ApConfirm", formData);	
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if (_bizErrMsg != null) {
				throw new RuntimeException(_bizErrMsg);
			}
			if("APconfirm".equals(_jobKind)) {
				throw new RuntimeException("\n\n[ 마감제출 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			} else {
				throw new RuntimeException("\n\n[ 수정 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "세금계산서 수정 완료 되었습니다.";
		String _jobKind = formData.get("job_kind");
		String count = "";
		String _bizErrMsg = null;
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if ( "APconfirm".equals(_jobKind) ) {
					
				} else {
					// 외상매입_세금계산서 update
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg", formData);
				}
				
			}
			if("APconfirm".equals(_jobKind)) {
				_rtnMsg = "마감제출 완료 되었습니다.";			
				
				// 마감제출 이미 완료된 사람 제출 불가(매입)
				count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClArTax_APbillCnt", formData);
								
				if(!count.equals("0")) {
					_bizErrMsg = "이미 마감제출 완료하였습니다.\n관리팀 확인 바랍니다.";
					throw new RuntimeException(_bizErrMsg);
				}
				// 미마감제출자 APDT정보에 없는 경우 DELETE 처리
				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClApBillCloseUserList", formData);
				
				// 마감확정내역 INSERT		
				sqlSessionTemplate.update("master.cmcl.InsertMasterCmClApCloseConfirm_v2", formData);				
				
				count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClArBillCloseUserList", formData);
				if(Integer.parseInt(count) > 0) {					
					// 미마감제출자 UPDATE
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClApBillCloseUserList", formData);					
				} else {
					// 미마감제출자 INSERT
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApBillCloseUserList", formData);
				}
			
				// 마감제출 처리
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_ApConfirm", formData);	
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if (_bizErrMsg != null) {
				throw new RuntimeException(_bizErrMsg);
			}
			if("APconfirm".equals(_jobKind)) {
				throw new RuntimeException("\n\n[ 마감제출 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			} else {
				throw new RuntimeException("\n\n[ 수정 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
		return _rtnMsg;
	}
	
	
	// 전송 - IF 저장
//	@Transactional(propagation=Propagation.NEVER, noRollbackFor={Throwable.class})
	public void saveAPsendData(Map<String,String>  formData) {
		String LIFNR = "";
//		String UMSKZ = "";
		String HKONT = "";
		String _comCode = "";
		String BUPLA = "";
		String MWSKZ = "";
		boolean SHKZG = true; // true : 정상, false : 반품
		
		// 기존 I/F 오류내역 처리 방법 체크
		if ( "D".equals(formData.get("processType")) ) {
			// IT_AP_LINE 세금계산서 번호 delete
			formData.put("if_table", "AP");
			sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_GL_LINE 세금계산서 번호 delete
			formData.put("if_table", "GL");
			sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_TAX_LINE 세금계산서 번호 delete
			formData.put("if_table", "TAX");
			sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_HEADER 세금계산서 번호 delete
			formData.put("if_table", "HEADER");
			sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
		}
		else if ( "B".equals(formData.get("processType")) ) {
			// IT_AP_LINE 세금계산서 번호 update
			formData.put("if_table", "AP");
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_GL_LINE 세금계산서 번호 update
			formData.put("if_table", "GL");
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_TAX_LINE 세금계산서 번호 update
			formData.put("if_table", "TAX");
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_HEADER 세금계산서 번호 update
			formData.put("if_table", "HEADER");
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
			
			// IT_REVERSE 세금계산서 번호 update
			formData.put("if_table", "REVERSE");
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
		}

		// 신규 전송일 경우만 처리
		if ( "N".equals(formData.get("processType")) ) {
			// 외상매입_세금계산서 (결제조건) update
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_Pay", formData);
		}
		
		List<Map<String,String>> _selectList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_APsend", formData);
			
		for ( int j=0; j < _selectList.size(); j++ ) {
			formData.putAll((Map<String, String>)_selectList.get(j));
			
			LOGGER.debug("########## SAP 분개 {} Row Start ##########", j+1);
			LOGGER.debug("<<<<<<<<<<============ SAP 분개라인(AP) Start ============>>>>>>>>>>");
			
			// 02. 차대변지시자 (SHKZG - M) => (정상H,반품시S)
			if ( Integer.valueOf(String.valueOf(formData.get("AMT"))) < 0 ) {
				SHKZG = false;
				formData.put("SHKZG", "S");
				LOGGER.debug("SHKZG : {}", "S");
			} else {
				SHKZG = true;
				formData.put("SHKZG", "H");
				LOGGER.debug("SHKZG : {}", "H");
			}
			
			// 03. 회원사 정보에서 협력사 SAP코드 가져오기 (LIFNR - M) 
//			formData.put("com_code", formData.get("AGENT_CODE"));
			formData.put("BUSINESS_COND", "S"); // 회원사구분(B:고객사, S:협력사, M:운영사)
			LIFNR = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_KUNNR_LIFNR", formData);
			//--Test Setting
//			if ( "".equals(CommonUtil.nvl(LIFNR)) ) {
//				formData.put("LIFNR", "0060012461"); //--샘플데이터W
//			} else {
				formData.put("LIFNR", LIFNR);
//			}
			LOGGER.debug("IRS_NO : {}", formData.get("IRS_NO"));
			LOGGER.debug("BUSINESS_COND : {}", formData.get("BUSINESS_COND"));
			LOGGER.debug("LIFNR : {}", LIFNR);
			
			// 04. 공통코드에서 특별GL코드 가져오기  (UMSKZ)
//			UMSKZ = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_UMSKZ", formData);
//			formData.put("UMSKZ", UMSKZ);
			formData.put("UMSKZ", "");
			LOGGER.debug("UMSKZ : {}", "");
			
			// 05. 공통코드에서 GL계정 가져오기 (HKONT - M)
			formData.put("TYPE", "SA12");
			HKONT = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_Account", formData);
			formData.put("HKONT", HKONT);
			LOGGER.debug("HKONT : {}", HKONT);
			
			// 06. 전표통화금액 (WRBTR - M) - 합계
			if ( SHKZG ) {
				formData.put("WRBTR", String.valueOf(formData.get("AMT")));
			} else {
				formData.put("WRBTR", String.valueOf(-Integer.valueOf(String.valueOf(formData.get("AMT")))));
			}
			LOGGER.debug("WRBTR : {}", String.valueOf(formData.get("AMT")));
			
			// 07. 현지통화금액 (DMBTR)
			formData.put("DMBTR", "0");
			LOGGER.debug("DMBTR : {}", "0");
			
			// 08. 지급조건 (ZTERM) - (매출:수금/매입:지급)
			formData.put("ZTERM", formData.get("PAY_TERMS"));
			LOGGER.debug("ZTERM : {}", formData.get("PAY_TERMS"));
//			formData.put("ZTERM", "G001");
//			LOGGER.debug("ZTERM : {}", "G001");
			
			// 09. 기산일 (ZFBDT) => (확인필요)
//			formData.put("ZFBDT", formData.get("ISSUE_DATE"));
//			LOGGER.debug("ZFBDT : {}", formData.get("ISSUE_DATE"));
			formData.put("ZFBDT", "");
			LOGGER.debug("ZFBDT : {}", "");
			
			// 10. 지급방법 (ZLSCH)
//			formData.put("ZLSCH", formData.get("PAY_TYPE"));
//			LOGGER.debug("ZLSCH : {}", formData.get("PAY_TYPE"));
			formData.put("ZLSCH", "");
			LOGGER.debug("ZLSCH : {}", "");
			
//			// 11. 지급참조 (KIDNO) => 매출용
//			formData.put("KIDNO", "");
//			LOGGER.debug("KIDNO : {}", "");
			
			// 11. 파트너은행유형 (BVTYP) => 매입용
			formData.put("BVTYP", "");
			LOGGER.debug("BVTYP : {}", "");
			
			// 공통코드에서 회사코드 가져오기
			formData.put("TYPE", "SA04");
			_comCode = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_ComCode", formData);
			formData.put("com_code", _comCode);
			LOGGER.debug("com_code : {}", _comCode);
			
			// 12. 부가세사업장 가져오기 (BUPLA)
			BUPLA = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_BUPLA", formData);
			formData.put("BUPLA", BUPLA);
			LOGGER.debug("BUPLA : {}", BUPLA);
			
			// 13. 공통코드에서 부가세코드 가져오기 (MWSKZ)
			formData.put("TYPE", "SA10");
			MWSKZ = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_Account", formData);
			formData.put("MWSKZ", MWSKZ);
			LOGGER.debug("MWSKZ : {}", MWSKZ);
			
			// 14. 지정 (ZUONR) - 협력사 사업자번호
			formData.put("ZUONR", formData.get("IRS_NO"));
			LOGGER.debug("ZUONR : {}", formData.get("IRS_NO"));
			
			// 손익센터, 코스트센터 가져오기 (PRCTR, KOSTL)
			Map<String, String> _PRCTR_KOSTL = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_PRCTR_KOSTL", formData);
			
			// 15. 참조1 (XREF1) - 손익센터
			formData.put("XREF1", _PRCTR_KOSTL.get("PRCTR"));
			LOGGER.debug("XREF1 : {}", _PRCTR_KOSTL.get("PRCTR"));
			
			// 16. 참조2 (XREF2) - 고객사 사업자번호
			formData.put("XREF2", formData.get("BUYER_IRS_NO"));
			LOGGER.debug("XREF2 : {}", formData.get("BUYER_IRS_NO"));
			
			// 17. 참조3 (XREF3) - 고객사명
			formData.put("XREF3", formData.get("BUYER_COM_NAME"));
			LOGGER.debug("XREF3 : {}", formData.get("BUYER_COM_NAME"));
			
			// 18. 적요 (SGTXT)
			formData.put("SGTXT", formData.get("REMARK_DESCRIPTION"));
			LOGGER.debug("SGTXT : {}", formData.get("REMARK_DESCRIPTION"));
			
			// SAP 분개라인(AR) insert
			sqlSessionTemplate.update("master.cmcl.insertMasterCmClSalesTaxsheetIssueReg_IT_AP_LINE", formData);
			LOGGER.debug("<<<<<<<<<<============ SAP 분개라인(AP) End ============>>>>>>>>>>");
			LOGGER.debug(" ");
			LOGGER.debug("<<<<<<<<<<========== SAP 분개라인(GL) Start ==========>>>>>>>>>>");
			
			// 02. 차대변지시자 (SHKZG - M) => (정상S,반품시H)
			if ( Integer.valueOf(String.valueOf(formData.get("SUPP_PRICE"))) < 0 ) {
				SHKZG = false;
				formData.put("SHKZG", "H");
				LOGGER.debug("SHKZG : {}", "H");
			} else {
				SHKZG = true;
				formData.put("SHKZG", "S");
				LOGGER.debug("SHKZG : {}", "S");
			}
			
			// 03. 공통코드에서 GL계정 가져오기 (HKONT - M)
			formData.put("TYPE", "SA13");
			HKONT = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_Account", formData);
			formData.put("HKONT", HKONT);
			LOGGER.debug("HKONT : {}", HKONT);
			
			// 04. 전표통화금액 (WRBTR - M) - 공급가액
			if ( SHKZG ) {
				formData.put("WRBTR", String.valueOf(formData.get("SUPP_PRICE")));
			} else {
				formData.put("WRBTR", String.valueOf(-Integer.valueOf(String.valueOf(formData.get("SUPP_PRICE")))));
			}
			LOGGER.debug("WRBTR : {}", String.valueOf(formData.get("SUPP_PRICE")));
			
			// 05. 현지통화금액 (DMBTR)
			formData.put("DMBTR", "0");
			LOGGER.debug("DMBTR : {}", "0");
			
			// 06. 손익센터 (PRCTR)
			formData.put("PRCTR", _PRCTR_KOSTL.get("PRCTR"));
			LOGGER.debug("PRCTR : {}", _PRCTR_KOSTL.get("PRCTR"));
			
			// 07. 코스트센터 (KOSTL)
			formData.put("KOSTL", "");
			LOGGER.debug("KOSTL: {}", "");
			
			// 08. 부가세사업장 가져오기 (BUPLA) - [ AP_LINE꺼 사용 ]
			// 09. 공통코드에서 부가세코드 가져오기 (MWSKZ) - [ AP_LINE꺼 사용 ]
			// 10. 지정 (ZUONR) - 고객사 사업자번호 - [ AP_LINE꺼 사용 ]
			// 11. 참조1 (XREF1)
			formData.put("XREF1", "");
			LOGGER.debug("XREF1 : {}", "");
			
			// 12. 참조2 (XREF2)
			formData.put("XREF2", "");
			LOGGER.debug("XREF2 : {}", "");
			
			// 13. 참조3 (XREF3)
			formData.put("XREF3", "");
			LOGGER.debug("XREF3 : {}", "");
			
			// 14. 적요 (SGTXT) - [ AP_LINE꺼 사용 ]
			
			// SAP 분개라인(GL) insert
			sqlSessionTemplate.update("master.cmcl.insertMasterCmClSalesTaxsheetIssueReg_IT_GL_LINE", formData);
			LOGGER.debug("<<<<<<<<<<========== SAP 분개라인(GL) End ==========>>>>>>>>>>");
			LOGGER.debug(" ");
		}
		
		LOGGER.debug("<<<<<<<<<<========== SAP 분개라인(TAX) Start ==========>>>>>>>>>>");
		
		// 02. 차대변지시자 (SHKZG - M) => (정상S,반품시H)
		if ( Integer.valueOf(String.valueOf(formData.get("TOT_TAX_PRICE"))) < 0 ) {
			SHKZG = false;
			formData.put("SHKZG", "H");
			LOGGER.debug("SHKZG : {}", "H");
		} else {
			SHKZG = true;
			formData.put("SHKZG", "S");
			LOGGER.debug("SHKZG : {}", "S");
		}
		
		// 03. 공통코드에서 GL계정 가져오기 (HKONT - M)
		formData.put("TYPE", "SA14");
		HKONT = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_Account", formData);
		formData.put("HKONT", HKONT);
		LOGGER.debug("HKONT : {}", HKONT);
		
		// 04. 부가세금액 (WRBTR - M)
		if ( SHKZG ) {
			formData.put("WRBTR", String.valueOf(formData.get("TOT_TAX_PRICE")));
		} else {
			formData.put("WRBTR", String.valueOf(-Integer.valueOf(String.valueOf(formData.get("TOT_TAX_PRICE")))));
		}
		LOGGER.debug("WRBTR : {}", String.valueOf(formData.get("TOT_TAX_PRICE")));
		
		// 05. 공급가액 (FWBAS - M)
		if ( SHKZG ) {
			formData.put("FWBAS", String.valueOf(formData.get("TOT_SUPP_PRICE")));
		} else {
			formData.put("FWBAS", String.valueOf(-Integer.valueOf(String.valueOf(formData.get("TOT_SUPP_PRICE")))));
		}
		LOGGER.debug("FWBAS : {}", String.valueOf(formData.get("TOT_SUPP_PRICE")));
		
		// 06. 부가세사업장 가져오기 (BUPLA) - [ AP_LINE꺼 사용 ]
		// 07. 공통코드에서 부가세코드 가져오기 (MWSKZ) - [ AP_LINE꺼 사용 ]
		// 08. 참조1 (XREF1) - 사업자번호
		formData.put("XREF1", formData.get("IRS_NO"));
		LOGGER.debug("XREF1 : {}", formData.get("IRS_NO"));
		
		// 09. 참조2 (XREF2) - [ GL_LINE꺼 사용 ]
		// 10. 참조3 (XREF3) - [ GL_LINE꺼 사용 ]
		// 11. 적요 (SGTXT)
		formData.put("SGTXT", "매입-MRO용품외");
		LOGGER.debug("SGTXT : {}", "매입-MRO용품외");
		
		// 세액이 0원일 경우 저장을 안함(SAP 전송을 안하기 위해서)
		if ( !"0".equals(String.valueOf(formData.get("TOT_TAX_PRICE"))) ) {
			// SAP 분개라인(TAX) insert
			sqlSessionTemplate.update("master.cmcl.insertMasterCmClSalesTaxsheetIssueReg_IT_TAX_LINE", formData);
			// AR(AP)_LIN - BUPLA(부가세사업장), MWSKZ(부가세코드) Clear
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_IT_AP_LINE", formData);
			// GL_LINE - BUPLA(부가세사업장), MWSKZ(부가세코드) Clear
			sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_IT_GL_LINE", formData);
		}
		LOGGER.debug("<<<<<<<<<<========== SAP 분개라인(TAX) End ==========>>>>>>>>>>");
		LOGGER.debug(" ");
		LOGGER.debug("<<<<<<<<<<========== SAP 분개헤더(HEADER) Start ==========>>>>>>>>>>");
		
		// 00. 시스템구분(MRO,CMRO) (TAX_SYSTEM - FIX)
		formData.put("TAX_SYSTEM", "MRO");
		LOGGER.debug("TAX_SYSTEM : {}", "MRO");
		
		// 03. 증빙일 (BLDAT - M)
		formData.put("BLDAT", formData.get("ISSUE_DATE"));
		LOGGER.debug("BLDAT : {}", formData.get("ISSUE_DATE"));
		
		// 04. 전기일 (BUDAT - M)
		formData.put("BUDAT", formData.get("ISSUE_DATE"));
		LOGGER.debug("BUDAT : {}", formData.get("ISSUE_DATE"));
		
		// 05. 전표유형 (BLART) => (1:매출(AR), 2:매입(AP))
		formData.put("blart_type", "2");
		String BLART = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_BLART", formData);
		formData.put("BLART", BLART);
		LOGGER.debug("BLART : {}", BLART);
		
		// 06. 공통코드에서 통화코드 가져오기 (WAERS - M)
		formData.put("TYPE", "SA05");
		String WAERS = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_ComCode", formData);
		formData.put("WAERS", WAERS);
		LOGGER.debug("WAERS : {}", WAERS);
		
		// 07. 환율 (KURSF)
		formData.put("KURSF", "");
		LOGGER.debug("KURSF : {}", "");
		
		// 08. 세금계산서번호 (XBLNR - M)
		formData.put("XBLNR", formData.get("TAX_BILL_NO").substring(4));
		LOGGER.debug("XBLNR : {}", formData.get("TAX_BILL_NO").substring(4));
		
		// 09. 헤더텍스트 (BKTXT)
		formData.put("BKTXT", "매입-MRO용품외");
		LOGGER.debug("BKTXT : {}", "매입-MRO용품외");
		
		// 10. 전표입력자 이름 (ZZ_CNAME)
		formData.put("ZZ_CNAME", formData.get("USER_NAME"));
		LOGGER.debug("ZZ_CNAME : {}", formData.get("USER_NAME"));
		
		// 11. 시스템 구분 (XREF1_HD)
		formData.put("XREF1_HD", "KOREAB2B");
		LOGGER.debug("XREF1_HD : {}", "KOREAB2B");
		
		// 12. 전표입력자 부서명 (XREF2_HD)
		formData.put("XREF2_HD", formData.get("DEPT_NAME"));
		LOGGER.debug("XREF2_HD : {}", formData.get("DEPT_NAME"));
		
		// 13. 매입출세금계산서 유형 (ZZ_TAXINV_TYPE) => 발행조건(KEP:1, 거래처:2, 수기:3)
		if ( "10".equals(formData.get("BILL_TYPE")) ) {
			formData.put("ZZ_TAXINV_TYPE", "1");
			LOGGER.debug("ZZ_TAXINV_TYPE : {}", "1");
		} else 	if ( "11".equals(formData.get("BILL_TYPE")) ) {
			formData.put("ZZ_TAXINV_TYPE", "2");
			LOGGER.debug("ZZ_TAXINV_TYPE : {}", "2");
		} else if ( "12".equals(formData.get("BILL_TYPE")) ) {
			formData.put("ZZ_TAXINV_TYPE", "3");
			LOGGER.debug("ZZ_TAXINV_TYPE : {}", "3");
		}
		
		// 14. 거래선 이메일 주소 (ZZ_TAXINV_MAIL -- BILL_ACCOUNTING /* 회원사경리담당자관리 */ EMAIL 사용 )
		formData.put("ZZ_TAXINV_MAIL", formData.get("EMAIL"));
		LOGGER.debug("ZZ_TAXINV_MAIL : {}", formData.get("EMAIL"));
		
		// 15. 고객사 담당자 이름(ZZ_RREE_TXT1) ==> 매출전용
		formData.put("ZZ_RREE_TXT1", "");
		LOGGER.debug("ZZ_RREE_TXT1 : {}", "");

		// SAP 분개헤더 insert
		sqlSessionTemplate.selectOne("master.cmcl.SP_HEADER_INS", formData);
		LOGGER.debug("<<<<<<<<<<========== SAP 분개헤더(HEADER) End ==========>>>>>>>>>>");
		
		// 외상매출_세금계산서 update
		LOGGER.debug("<<<<<<<<<<========== 외상매입_세금계산서 update ==========>>>>>>>>>>");
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_APsend", formData);
	}
	
	// 전송 - SAP 전송
	public String sendAPsendData(Map<String,String>  formData) {
		List<Map<String, String>> _resultListMap = null;
		Map<String, String> _resultMap = new HashMap<String, String>();
		_rtnMsg = "success";
		
		List<Map<String,String>> _pHeaderList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_HEADER", String.valueOf(formData.get("TAX_BILL_NO")));
		List<Map<String,String>> _pAPLineList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_AP_LINE", String.valueOf(formData.get("TAX_BILL_NO")));
		List<Map<String,String>> _pGLLineList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_GL_LINE", String.valueOf(formData.get("TAX_BILL_NO")));
		List<Map<String,String>> _pTAXLineList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_TAX_LINE", String.valueOf(formData.get("TAX_BILL_NO")));
		
		// SAP 웹서비스 호출
		_resultListMap = debtInWebService.addList(_pHeaderList, _pAPLineList, _pGLLineList, _pTAXLineList);
		LOGGER.debug("_resultListMap ===>>>{} <<<===", _resultListMap);
		
		for ( int i = 0; i < _resultListMap.size(); i++ ) {
			LOGGER.debug("<<<<<============== {} ===============>>>>>", i);
			LOGGER.debug("ZResultCd ===>>>{}<<<===", _resultListMap.get(i).get("ZResultCd"));
			LOGGER.debug("ZResultMsg ===>>>{}<<<===", _resultListMap.get(i).get("ZResultMsg"));
			LOGGER.debug("GRP_CD ===>>>{}<<<===", _resultListMap.get(i).get("GRPCD"));
			LOGGER.debug("O_BELNR ===>>>{}<<<===", _resultListMap.get(i).get("OBELNR"));
			LOGGER.debug("O_GJAHR ===>>>{}<<<===", _resultListMap.get(i).get("OGJAHR"));
			LOGGER.debug("O_MSG ===>>>{}<<<===", _resultListMap.get(i).get("OMSG"));
		}
		
		if ( "E".equals(_resultListMap.get(0).get("ZResultCd")) ) {
			_rtnMsg = "error";
		}
		
		_resultMap.put("TAX_BILL_NO", String.valueOf(formData.get("TAX_BILL_NO")));
		_resultMap.put("KEP_IRS_NO", String.valueOf(formData.get("KEP_IRS_NO")));
		_resultMap.put("SVC_RESULTCD", String.valueOf(_resultListMap.get(0).get("ZResultCd")));
		_resultMap.put("SVC_RESULTMSG", String.valueOf(_resultListMap.get(0).get("ZResultMsg")));
		_resultMap.put("O_BELNR", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OBELNR"))));
		_resultMap.put("O_GJAHR", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OGJAHR"))));
		_resultMap.put("O_MSG", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OMSG"))));
		
		if ( "success".equals(_rtnMsg) ) {
			_resultMap.put("IF_SEND_FLAG", "Y");
			_resultMap.put("SVC_BILL_STAT", "PC");
		} else {
			_resultMap.put("IF_SEND_FLAG", "E");
			_resultMap.put("SVC_BILL_STAT", "P1");
		}

		// SAP 분개헤더 update 
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_Receive_IT_HEADER", _resultMap);
		
		// 외상매입_세금계산서 update 
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_Receive_KEPTAPDT", _resultMap);
		
		return _rtnMsg;
	}
	
	// 전송취소 - IF 저장
//	@Transactional(propagation=Propagation.NEVER, noRollbackFor={Throwable.class})
	public void saveAPreverseData(Map<String,String>  formData) {

		Map<String,String> _selectMap = sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_HEADER_REVERSE", formData);
		formData.putAll(_selectMap);

		// SAP REVERSE 요청 SP Call
		sqlSessionTemplate.selectOne("master.cmcl.SP_REVERSE_INS", formData);

		// 외상매입_세금계산서 update
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_APsend_REVERSE", formData);
	}
	
	// 전송취소 - SAP 전송
	public String sendAPreverseData(Map<String,String>  formData) {
		List<Map<String, String>> _resultListMap = null;
		Map<String, String> _resultMap = new HashMap<String, String>();
		_rtnMsg = "success";
		
		List<Map<String,String>> _pReverseList = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClSalesTaxsheetIssueRegList_IT_REVERSE", String.valueOf(formData.get("TAX_BILL_NO")));
		
		// SAP 웹서비스 호출
		_resultListMap = reverseInWebService.addList(_pReverseList);
		LOGGER.debug("_resultListMap ===>>>{} <<<===", _resultListMap);
		
		for ( int i = 0; i < _resultListMap.size(); i++ ) {
			LOGGER.debug("<<<<<============== {} ===============>>>>>", i);
			LOGGER.debug("ZResultCd ===>>>{}<<<===", _resultListMap.get(i).get("ZResultCd"));
			LOGGER.debug("ZResultMsg ===>>>{}<<<===", _resultListMap.get(i).get("ZResultMsg"));
			LOGGER.debug("GRP_CD ===>>>{}<<<===", _resultListMap.get(i).get("GRPCD"));
			LOGGER.debug("O_BELNR ===>>>{}<<<===", _resultListMap.get(i).get("OBELNR"));
			LOGGER.debug("O_GJAHR ===>>>{}<<<===", _resultListMap.get(i).get("OGJAHR"));
			LOGGER.debug("O_MSG ===>>>{}<<<===", _resultListMap.get(i).get("OMSG"));
		}
		
		if ( "E".equals(_resultListMap.get(0).get("ZResultCd")) ) {
			_rtnMsg = "error";
		}
		
		_resultMap.put("TAX_BILL_NO", String.valueOf(formData.get("TAX_BILL_NO")));
		_resultMap.put("KEP_IRS_NO", String.valueOf(formData.get("KEP_IRS_NO")));
		_resultMap.put("SVC_RESULTCD", String.valueOf(_resultListMap.get(0).get("ZResultCd")));
		_resultMap.put("SVC_RESULTMSG", String.valueOf(_resultListMap.get(0).get("ZResultMsg")));
		_resultMap.put("O_BELNR", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OBELNR"))));
		_resultMap.put("O_GJAHR", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OGJAHR"))));
		_resultMap.put("O_MSG", CommonUtil.nvl(String.valueOf(_resultListMap.get(1).get("OMSG"))));
		
		if ( "success".equals(_rtnMsg) ) {
			_resultMap.put("IF_SEND_FLAG", "C");
			_resultMap.put("SVC_BILL_STAT", "RC");
		} else {
			_resultMap.put("IF_SEND_FLAG", "F");
			_resultMap.put("SVC_BILL_STAT", "R1");
		}
		
		// SAP REVERSE 요청 update
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_Receive_IT_REVERSE", _resultMap);

		// SAP 분개헤더 update
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_Receive_IT_HEADER_REVERSE", _resultMap);
		
		// 외상매입_세금계산서 update 
		sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueReg_Receive_KEPTAPDT", _resultMap);
		
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제 처리 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				String _ifSendFlag = CommonUtil.nvl(formData.get("IF_SEND_FLAG"));
				LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
				
				//구매사별 입고 정보에서 물류비 마감여부가 'Y'인 건이 있으면 삭제 되지 않게
				List<Map<String, String>> _resultListMapICOMGRDT = new ArrayList<Map<String, String>>();
				_resultListMapICOMGRDT  = sqlSessionTemplate.selectList("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_ICOMGRDT", formData);
				if(_resultListMapICOMGRDT.size() >0){
					_rtnMsg = "물류비마감 건은 삭제 불가합니다.\n물류비마감 삭제 후 매입마감 삭제를 진행하세요.";
					throw new RuntimeException("물류비마감 건은 삭제 불가합니다.\n물류비마감 삭제 후 매입마감 삭제를 진행하세요.");
				}
				
				// 외상매입_세금계산서 delete
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg", formData);
				
				// 구매사별 입고정보 clear
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_Clear", formData);
				
				// 마감 미제출자 여부 N 변경
				//sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_BillCloseList", formData);
				/*
				// IF 테이블 내역 delete
				if ( "E".equals(_ifSendFlag) ) {
					// IT_AP_LINE 세금계산서 번호 delete
					formData.put("if_table", "AP");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_GL_LINE 세금계산서 번호 delete
					formData.put("if_table", "GL");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_TAX_LINE 세금계산서 번호 delete
					formData.put("if_table", "TAX");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_HEADER 세금계산서 번호 delete
					formData.put("if_table", "HEADER");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
				}*/
			}
			
		} catch(Exception e) {
			if(!"삭제 처리 완료 되었습니다.".equals(_rtnMsg)){
				throw new RuntimeException(_rtnMsg);
			}else{
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("\n\n[ 삭제 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}

		return _rtnMsg;
	}	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제 처리 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				String _ifSendFlag = CommonUtil.nvl(formData.get("IF_SEND_FLAG"));
				LOGGER.debug("_ifSendFlag : {}", _ifSendFlag);
				
				//구매사별 입고 정보에서 물류비 마감여부가 'Y'인 건이 있으면 삭제 되지 않게
				List<Map<String, String>> _resultListMapICOMIVDT = new ArrayList<Map<String, String>>();
				_resultListMapICOMIVDT  = sqlSessionTemplate.selectList("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_ICOMIVDT_v2", formData);
				if(_resultListMapICOMIVDT.size() >0){
					_rtnMsg = "물류비마감 건은 삭제 불가합니다.\n물류비마감 삭제 후 매입마감 삭제를 진행하세요.";
					throw new RuntimeException("물류비마감 건은 삭제 불가합니다.\n물류비마감 삭제 후 매입마감 삭제를 진행하세요.");
				}
				
				// 외상매입_세금계산서 delete
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg", formData);
				
				// 구매사별 입고정보 clear
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_Clear_v2", formData);
				
				// 마감 미제출자 여부 N 변경
				//sqlSessionTemplate.update("master.cmcl.updateMasterCmClPurchaseTaxsheetIssueReg_BillCloseList", formData);
				/*
				// IF 테이블 내역 delete
				if ( "E".equals(_ifSendFlag) ) {
					// IT_AP_LINE 세금계산서 번호 delete
					formData.put("if_table", "AP");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_GL_LINE 세금계산서 번호 delete
					formData.put("if_table", "GL");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_TAX_LINE 세금계산서 번호 delete
					formData.put("if_table", "TAX");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
					
					// IT_HEADER 세금계산서 번호 delete
					formData.put("if_table", "HEADER");
					sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClPurchaseTaxsheetIssueReg_IT_TABLE", formData);
				}*/
			}
			
		} catch(Exception e) {
			if(!"삭제 처리 완료 되었습니다.".equals(_rtnMsg)){
				throw new RuntimeException(_rtnMsg);
			}else{
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("\n\n[ 삭제 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}

		return _rtnMsg;
	}	
	// 역발행 요청삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delApMasterCmClPurchaseTaxsheetIssueRegList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "역발행요청 삭제 처리 완료 되었습니다.";
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				// 외상매입_세금계산서 delete
				sqlSessionTemplate.delete("master.cmcl.delApMasterCmClPurchaseTaxsheetIssueRegList", formData);

			}
			
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 삭제 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		return _rtnMsg;
	}
	// 전송
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String sendApSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "전송 처리 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));				
				// 전송처리
				sqlSessionTemplate.delete("master.cmcl.sendApMasterCmClPurchaseTaxsheetIssueReg", formData);

			}
			
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 삭제 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}

		return _rtnMsg;
	}	
	
	// 정발행 요청 메일
	@SuppressWarnings("unchecked")
	public String sendApMailSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정발행 메일 요청 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// 외상매입_세금계산서 이메일, 이메일 수신자 update
				sqlSessionTemplate.update("master.cmcl.sendApMailMasterCmClPurchaseTaxsheetIssueReg1", formData);
				
				// 메일 테이블 전송
				sqlSessionTemplate.update("master.cmcl.sendApMailMasterCmClPurchaseTaxsheetIssueReg2", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 요청 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	// 역발행 요청 메일
	public List<Map<String,String>> selectMasterCmClsendApRMailPop(Map<String,String> formData) {

		return MasterCmClSmartBillUploadingCreationDao.selectMasterCmClsendApRMailPop(formData);
	}
}
