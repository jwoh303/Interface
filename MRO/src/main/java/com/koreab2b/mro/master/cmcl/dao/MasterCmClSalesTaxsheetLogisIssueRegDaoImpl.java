package com.koreab2b.mro.master.cmcl.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;
import com.koreab2b.mro.webservice.erp.bond.BondInWebService;
import com.koreab2b.mro.webservice.erp.reverse.ReverseInWebService;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSmartBillUploadingCreationDao;
;

@Repository("masterCmClSalesTaxsheetLogisIssueRegDao")
@Transactional
public class MasterCmClSalesTaxsheetLogisIssueRegDaoImpl implements MasterCmClSalesTaxsheetLogisIssueRegDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetLogisIssueRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterCmClSmartBillUploadingCreationDao MasterCmClSmartBillUploadingCreationDao;
	@Autowired
	private BondInWebService bondInWebService;
	
	@Autowired
	private ReverseInWebService reverseInWebService;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String,String>> resultList = null;
		
		LOGGER.debug("job_kind ==>>{}<<==", param.get("job_kind"));
		
		if ( "excelDetailDown".equals(param.get("job_kind")) ) {
			sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxsheetLogisIssueRegList_Detail", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		} else { 

			sqlSessionTemplate.select("master.cmcl.selectMasterCmClSalesTaxsheetLogisIssueRegList", param, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}
		
		return resultList;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _jobKind = formData.get("job_kind");
//		String _jobTyep = formData.get("job_type");
		
		try {
			
			// 확정 처리
			if ( "confirm".equals(_jobKind) ) {
				_rtnMsg = "확정 처리 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 외상매출_세금계산서 update
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_Confirm", formData);
					
				}
			}
			// 확정취소 처리
			else if ( "confirmCancle".equals(_jobKind) ) {
				_rtnMsg = "확정취소 처리 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 외상매출_세금계산서 update
					int _upCount = sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_ConfirmCancle", formData);
					
				}
			}
			// 수정 처리
			else if ( "update".equals(_jobKind) ) {
				_rtnMsg = "세금계산서 수정 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					
					// 외상매출_세금계산서 update
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_Update", formData);
					
				}
			}
			// 전송처리
			else if ( "ARsend".equals(_jobKind) ) {
				_rtnMsg = "세금계산서 전송이 완료 되었습니다.";
				
				for ( int i=0; i < gridData.size(); i++ ) {
					formData.putAll((Map<String, String>)gridData.get(i));
					// 전송처리
					sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetIssueArSend", formData);

				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			if ( "confirm".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 확정 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			else if ( "confirmCancle".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 확정취소 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
			else if ( "update".equals(_jobKind) ) {
				throw new RuntimeException("\n\n[ 수정 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
			}
		}
		
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
				
				// 외상매출_세금계산서 delete
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClSalesTaxsheetLogisIssueReg_Delete", formData);
				
				// 구매사별 입고정보 clear
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_Clear", formData);
				
				// 마감 미제출자 여부 N 변경
				//sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_BillCloseList", formData);
				
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
				
				// 외상매출_세금계산서 delete
				sqlSessionTemplate.delete("master.cmcl.deleteMasterCmClSalesTaxsheetLogisIssueReg_Delete", formData);
				
				// 구매사별 납품정보 clear
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_Clear_v2", formData);
				
				// 마감 미제출자 여부 N 변경
				//sqlSessionTemplate.update("master.cmcl.updateMasterCmClSalesTaxsheetLogisIssueReg_BillCloseList", formData);
				
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
	
}
