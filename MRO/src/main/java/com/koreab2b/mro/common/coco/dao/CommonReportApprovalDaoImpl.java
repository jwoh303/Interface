package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogInfoMultiAlterDaoImpl;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("CommonReportApprovalDao")
@Transactional
public class CommonReportApprovalDaoImpl implements CommonReportApprovalDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogInfoMultiAlterDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 품의상신(RPT)
	public String rptRequest(Map<String,String> formData){
		formData.put("DOC_NAME","RPT");
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		_pMap.put("USER_ID", formData.get("USER_ID"));
		_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		//결재상신 KEP_REPORT_DT 결재처리
		_pMap.put("REPORT_STATUS", "A");
		sqlSessionTemplate.update("commonReportApproval.updateKePReporStatustDt", _pMap);
		return "OK";
	}
	
	// 리포트 자동화 결재 취소(RPT)
	public String rptCancel(Map<String,String> formData){
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		_pMap.put("STATUS", "D");	// 삭제 처리
		_pMap.put("USER_ID", formData.get("USER_ID"));
		_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		// STEP1
		sqlSessionTemplate.update("commonReportApproval.updateCancelReportKEPMGPHD", _pMap);
		// STEP2
		sqlSessionTemplate.update("commonReportApproval.updateCancelReportKEPMGPDT", _pMap);
		//결재상신 KEP_REPORT_DT 결재처리 등록상태 변경
		_pMap.put("REPORT_STATUS", "R");
		sqlSessionTemplate.update("commonReportApproval.updateKePReporStatustDt", _pMap);
		return "OK";
	}
	
	// 리포트 자동화 결재 승인 후 처리(RPT)
	public String rptApproval(Map<String, String> formData) {
		String _rtnMsg = "결재완료 되었습니다.";
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		if (_pMap != null){
			try{
				_pMap.put("STATUS", "A");
				_pMap.put("USER_ID", formData.get("USER_ID"));
				_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
				// STEP1
				sqlSessionTemplate.update("commonReportApproval.updateApprovalReportKEPMGPHD", _pMap);
				sqlSessionTemplate.update("commonReportApproval.updateApprovalReportKEPMGPDT", _pMap);
				//결재상신 KEP_REPORT_DT 결재처리
				_pMap.put("REPORT_STATUS", "C");
				sqlSessionTemplate.update("commonReportApproval.updateKePReporStatustDt", _pMap);
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
					throw new RuntimeException("결재완료에 실패하였습니다.");
			}
		}
		return _rtnMsg; 
	}
	
	// 리포트자동화 반려 처리(RPT)
	public String rptReject(Map<String,String> formData){
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
		Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		_pMap.put("STATUS", "B");
		_pMap.put("USER_ID", formData.get("USER_ID"));
		_pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		        
		// STEP1
		sqlSessionTemplate.update("commonReportApproval.updateRejectReportKEPMGPHD", _pMap);
		// STEP2
		sqlSessionTemplate.update("commonReportApproval.updateRejectReportKEPMGPDT", _pMap);
		//결재상신 KEP_REPORT_DT 결재처리 등록상태 변경
		_pMap.put("REPORT_STATUS", "R");
		sqlSessionTemplate.update("commonReportApproval.updateKePReporStatustDt", _pMap);
		return "OK";
	}

	// 리포트자동화 결재 리스트(RPT)
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> approvalReportListPop(Map<String,String> formData) {
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("commonReportApproval.selectReportResultList", formData, _resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("commonReportApproval.selectReportResultList", formData);
		}
		return resultList;
	}
}
