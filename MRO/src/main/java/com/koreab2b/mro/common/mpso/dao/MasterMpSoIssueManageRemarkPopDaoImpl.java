package com.koreab2b.mro.common.mpso.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoIssumeManageRemarkPopDao")
@Transactional
public class MasterMpSoIssueManageRemarkPopDaoImpl implements MasterMpSoIssueManageRemarkPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoIssueManageRemarkPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public Map<String, String> selectCqDt(Map<String, String> formData) {
		String req_Map = "";
		if("000000".equals(formData.get("st_po_seq"))){
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoSeq", formData);
			formData.put("st_po_seq", req_Map);
		}
		return sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopCqDt", formData);
	}

	@Override
	public Map<String, String> selectPoHd(Map<String, String> formData) {
		String req_Map = "";
		if("000000".equals(formData.get("st_po_seq"))){
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoSeq", formData);
			formData.put("st_po_seq", req_Map);
		}
		return sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoHd", formData);
	}

	@Override
	public List<Map<String, String>> selectIvDt(Map<String, String> formData) {
		String req_Map = "";
		if("000000".equals(formData.get("st_po_seq"))){
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoSeq", formData);
			formData.put("st_po_seq", req_Map);
		}
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoIssueManageRemarkPopIvDt", formData);
	}

	@Override
	public List<Map<String, String>> selectList(Map<String, Object> formData) {
		String req_Map = "";
		if("000000".equals(formData.get("st_po_seq"))){
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoSeq", formData);
			formData.put("st_po_seq", req_Map);
		}
		String _st_sheet = (String) formData.get("st_sheet");
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoIssueManageRemarkPopList"+_st_sheet, formData);
	}

	@Override
	public List<Map<String, String>> selectPoMn(Map<String, String> formData) {
		String req_Map = "";
		if("000000".equals(formData.get("st_po_seq"))){
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPoSeq", formData);
			formData.put("st_po_seq", req_Map);
		}
		
		// 수주접수 여부 확인
		int count = 0;
		count = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopPreAutoProcess1", formData);
		
		if(count > 0) {
			// 수주미접수 자동처리 전처리
			if( sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueManageRemarkPreAutoProcess2", formData) == 0 ) {
				throw new RuntimeException("UPDATE ERR");
			}
		}
		
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoIssueManageRemarkPopPoMn", formData);
	}

	@Override
	public Map<String, String> selectRptInfo(Map<String, String> formData) {
		return  sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkPopRptUrl", formData);
	}
	
	@Override
	public String updateRemark(Map<String, String> formData) {
		String _rtnMsg = "";
		// st_po_multiYN = Y인 경우 같은 PO_NO 내에서 st_type이 같은 경우 같이 update
		try {
			List<Map<String, String>> seq_list = new ArrayList<Map<String, String>>();
			if(formData.get("st_po_multiYN").equals("Y") && formData.get("st_status").equals("RE")) { // 동일발주 처리인경우 SEQ, PO_SEQ, DS_SEQ 저장하여 FOR 문	 
				seq_list = sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoIssueManageRemarkPoMultiSeq", formData); 
			}
			
			if( sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueManageRemark", formData) == 0 ) {
				throw new RuntimeException("UPDATE ERR");
			}

			if(formData.get("st_type").equals("D") && formData.get("st_status").equals("CM")) { // 거래유형 변경요청 승인 시 발주번호 기준 전체 변경
				String job_hist_id = "";
				job_hist_id = sqlSessionTemplate.selectOne("common.mpso.getGlobalUniqueKey", formData); // 공통
				
				formData.put("HIST_ID", job_hist_id);
				formData.put("BUYER", formData.get("st_buyer"));
				formData.put("PO_NO", formData.get("st_po_no"));
				formData.put("HIST_RSN_CD", "C002");
				formData.put("HIST_RSN_MEMO", "협력사 거래유형 변경요청 승인");
				formData.put("PROC_USER_ID", formData.get("st_user_id"));
				
				// 거래유형 발주 변경 이력 쌓기(C002) - PROC_ODRHIST_GEN
				sqlSessionTemplate.update("common.mpso.call_PROC_ODRHIST_GEN", formData); // 공통
				
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueProcessTypePrdt", formData);

				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueProcessTypePodt", formData);

				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueProcessTypePohd", formData);
			}else if(formData.get("st_type").equals("G") && formData.get("st_status").equals("CM")) { // 납품예정일 변경요청 승인 시 분할항번 변경
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueDsDatePors", formData);
			}else if(formData.get("st_type").equals("I") && formData.get("st_status").equals("CM")) { // 수주접수 초기화요청 승인 시 발주번호 기준 전체 변경
				String _posb_chk = "";
				_posb_chk = sqlSessionTemplate.selectOne("master.mpso.getMasterMpSoIssueClearPosbChk", formData); // 변경 납품예정일이 기존에 있는 경우 오류
				
				if("N".equals(_posb_chk)) {
					_rtnMsg = "수주접수 이외 상태가 존재합니다(발주초기화 불가).";
					throw new RuntimeException(_rtnMsg);
				}
				
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueClearPrdt", formData);

				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueClearPodt", formData);
				
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueClearPors", formData);
				
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueClearPrhd", formData);
			}
			
			if (formData.get("st_status").equals("RE")) {
				if(formData.get("st_po_multiYN").equals("Y")) { // 동일발주 일괄 처리 시 
					for(int i = 0; i < seq_list.size(); i++) {
						Map<String,String> rowData = new HashMap<String, String>();
						rowData.putAll(formData);
						rowData.put("st_po_seq", seq_list.get(i).get("PO_SEQ"));
						rowData.put("st_ds_seq", seq_list.get(i).get("DS_SEQ"));
						rowData.put("st_seq", seq_list.get(i).get("SEQ"));
						
						LOGGER.debug(i+ "th rowData : {}", rowData);
						if( sqlSessionTemplate.update("master.mpso.insertMasterMpSoIssueManageRemark", rowData) == 0 ) {
							throw new RuntimeException("INSERT RE ERR");
						}
					}
				}else {
					if( sqlSessionTemplate.update("master.mpso.insertMasterMpSoIssueManageRemark", formData) == 0 ) {
						throw new RuntimeException("INSERT RE ERR");
					}	
				}
			}
			
			if (formData.get("st_type").equals("E") && formData.get("st_voc_autoYN").equals("Y")) {
				if(!saveMasterMpVoVocReceiptList(formData).equals("OK")) {
					throw new RuntimeException("INSERT VOC ERR");
				}
				
			}
				
		}catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("이슈 저장에 실패하였습니다.\n" + e.getMessage());
		}
		_rtnMsg="OK";
		return _rtnMsg;
	}
	
	public String saveMasterMpVoVocReceiptList(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			String vc_no = getOrderNo("KRKORE0001", "VC");
			
			Map<String,String> req_Map = new HashMap<String, String>();
			req_Map = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoIssueManageRemarkAgent", formData);
			
			req_Map.put("st_buyer_code", formData.get("st_buyer"));
			req_Map.put("st_user_id", formData.get("st_user_id"));
			req_Map.put("st_req_remark", formData.get("st_req_remark"));
			req_Map.put("st_vc_no", vc_no);
			req_Map.put("st_po_no", formData.get("st_po_no"));
			req_Map.put("st_po_seq", formData.get("st_po_seq"));
			req_Map.put("st_remark_atoa", formData.get("st_remark_atoa"));
			req_Map.put("st_seq", formData.get("st_seq"));
			
			// 처리희망일 WDAY 3일, SM담당자로 자동 지정, 발주>주문내용변경
			sqlSessionTemplate.update("master.mpso.insertMasterMpVoVocReceiptReg", req_Map);
			sqlSessionTemplate.update("master.mpso.updateMasterMpSoIssueManageRemarkAfterVoc", req_Map);
		} catch (Exception e) {
			_rtnMsg = "Err";
		}
		return _rtnMsg;
	}
	
	private String getOrderNo(String company, String dept_type){
		
		Map<String,String> pMap = new HashMap<String, String>();
		pMap.put("st_company", company);
		pMap.put("st_doc_type", dept_type);
		
		String orderNo = CommonUtil.nvl((String) sqlSessionTemplate.selectOne("master.mpvo.selectMasterMpVoVocReceiptVcNo", pMap), "");
		
		if("".equals(orderNo)){
			sqlSessionTemplate.update("master.mpvo.insertICOMSQMT", pMap);
			int year_num = Calendar.getInstance().get(Calendar.YEAR);
			String year_str = String.valueOf(year_num);
			orderNo = dept_type + year_str.substring(2,4) + "000001";
		}else{
			sqlSessionTemplate.update("master.mpvo.updateICOMSQMT", pMap);
		}
		
		return orderNo;
	}

	@Override
	public String insertMemo(Map<String, String> formData) {
		String _rtnMsg = "OK";
		try {
			if(formData.get("st_memo_issue_type").equals("M")) {
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoIssueManageMemo2", formData);
			}
			sqlSessionTemplate.update("master.mpso.insertMasterMpSoIssueManageMemo", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.\n");
		}
		return _rtnMsg;
	}

}
