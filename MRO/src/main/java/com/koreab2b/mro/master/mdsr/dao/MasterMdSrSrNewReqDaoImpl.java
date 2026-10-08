package com.koreab2b.mro.master.mdsr.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Repository("masterMdSrSrNewReqDao")
@Transactional
public class MasterMdSrSrNewReqDaoImpl implements MasterMdSrSrNewReqDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrNewReqDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";

	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		String sr_no = "";
		
		try{
			
			if(formData.get("SR_NO") ==null || "".equals(formData.get("SR_NO"))){
				sr_no = buyerMpSoOrderInfoDao.getOrderNo(formData.get("st_com_code"), "SR");
				formData.put("SR_NO", sr_no);
			}

			sqlSessionTemplate.update("master.mdsr.insertMasterMdSrSrNewReq", formData);
			
			//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
			formData.put("DOC_NO", formData.get("st_image_key"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			
		} catch (Exception e){
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("S/R 요청이 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 품의상신 DOCU_NO 채번
	public Map<String,String> approvalSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		String sr_no = "";
		Map<String, String> pMap = new HashMap<String, String>();
		
		try{
			sr_no = buyerMpSoOrderInfoDao.getOrderNo(formData.get("st_com_code"), "SR");
			
		} catch (Exception e){
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품의상신에 실패 했습니다. 관리자에게 문의 하세요");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("SR_NO", sr_no);
		return pMap;
	}
	
	// S/R신규요청 요청 후 처리(SR)
	public String srRequest(Map<String,String> formData){
		
		return "OK";
	}
	
	// S/R신규요청 결재 상신취소 후 처리(SR) - 요청취소(GS)
	public String srCancel(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		
		_pMap.put("RECV_FLAG", "GS");
		_pMap.put("REQ_CONFIRM_ID", formData.get("USER_ID"));
		
		// STEP1
		sqlSessionTemplate.update("master.mdsr.updateApprovalKEPASRDT", _pMap);
        
		return "OK";
	}
	
	// S/R신규요청 결재 승인 후 처리(SR) - 요청(GA)
	public String srApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("RECV_FLAG", "GA");
		_pMap.put("REQ_CONFIRM_ID", formData.get("USER_ID"));
        // STEP1
 		sqlSessionTemplate.update("master.mdsr.updateApprovalKEPASRDT", _pMap);
		return "OK";
	}
	
	// 자료다운로드 결재 승인 후 처리
	public String srDataApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("RECV_FLAG", "PA");
		_pMap.put("REQ_CONFIRM_ID", formData.get("USER_ID"));
        // STEP1
 		sqlSessionTemplate.update("master.mdsr.updateDataApprovalKEPASRDT", _pMap);
		return "OK";
	}
	
	// S/R신규요청 결재 반려 후 처리(SR) - 결재반려(GB)
	public String srReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("RECV_FLAG", "GB");
		_pMap.put("REQ_CONFIRM_ID", formData.get("USER_ID"));
        // STEP1
 		sqlSessionTemplate.update("master.mdsr.updateApprovalKEPASRDT", _pMap);
		
		return "OK";
	}
	public List<Map<String,String>> srResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectNcaResultList", param);
	}
}
