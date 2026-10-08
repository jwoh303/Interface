package com.koreab2b.mro.master.mdcm.dao;

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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMdCmCatalogRegProgressDao")
@Transactional
public class MasterMdCmCatalogRegProgressDaoImpl implements MasterMdCmCatalogRegProgressDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegProgressDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	private String _rtnMsg = "";
	private String _errMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogRegProgressList", param);
	}

	// 재소싱요청
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateReSourcingData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재소싱요청이 정상적으로 이루어 졌습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 차수 기존이력 추가
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogRegRevision", formData);
				
				// 차수 새이력 추가
				sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCatalogRegRevision", formData);
				
				// 매입단가, 차수 변경
				sqlSessionTemplate.update("master.mdcm.saveMasterMdCmCatalogRegReSourcing", formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재소싱요청에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
	
	// 취소
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 취소되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmCatalogRegProgress", formData);
				logger.error("deleteMasterMdCmCatalogRegProgress 실행 완료");
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("취소에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
	
	// 소싱변경 업로드
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String batchSourcingData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "엑셀 업로드 완료되었습니다.";
		_errMsg = "엑셀 업로드에 실패 했습니다.\n\n관리자에게 문의 하세요";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				// select
				int uploadCheck = (Integer)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegSourcingChk", formData);
				
				if(uploadCheck < 1){
					_errMsg = "엑셀 업로드에 실패 했습니다.\n존재 데이터 확인 or 진행상태를 확인하시기 바랍니다.";
					throw new RuntimeException(_errMsg);
				}
				
				// update
				sqlSessionTemplate.update("master.mdcm.batchMasterMdCmCatalogRegSourcing", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_errMsg);
		}
		return _rtnMsg;
	}
	
	// 판가변경 업로드
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String batchUnitPriceData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "엑셀 업로드 완료되었습니다.";
		_errMsg = "엑셀 업로드에 실패 했습니다.\n\n관리자에게 문의 하세요";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				// select
				int uploadCheck = (Integer)sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegUnitPriceChk", formData);
				
				if(uploadCheck < 1){
					_errMsg = "엑셀 업로드에 실패 했습니다.\n존재 데이터 확인 or 진행상태를 확인하시기 바랍니다.";
					throw new RuntimeException(_errMsg);
				}
				
				// update
				sqlSessionTemplate.update("master.mdcm.batchMasterMdCmCatalogRegUnitPrice", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_errMsg);
		}
		return _rtnMsg;
	}
	
	// 카탈로그 등록 차수 팝업 조회
	public List<Map<String,String>> getMasterMdCmCatalogRegRevisionList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.getMasterMdCmCatalogRegRevisionList", param);
	}
	
	// 소싱제출, 판가제출 품의 상신
	@SuppressWarnings("unchecked")
	public Map<String,String> updateData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 되었습니다.";
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				
				if (i == 0){
					_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM"); 
					formData.put("PM_NO", _pm_no);
					sqlSessionTemplate.update("master.mdcm.insertCaReqKEPMGPHD", formData);
				}
				
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.mdcm.insertCaReqKEPMGPDT", formData);
				_pm_seq++;
				
				if("CRS".equals(formData.get("st_approval_gubun"))) { // 소싱제출자 정보등록
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogRegSourcing", formData);	
				}
				
				if("CRU".equals(formData.get("st_approval_gubun"))) { // 판가제출자 정보등록
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogRegUnitPrice", formData);
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품의상신에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		return pMap;
	}
	
	// 소싱제출 상신 후 처리 
	public String crsRequest(Map<String,String> formData){
		try{
			formData.put("TYPE", "0"); // 0 - request
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRS_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("상신 후처리에 실패하였습니다.");
		}

		return "OK";
	}
	
	// 소싱제출 승인 후 처리
	public String  crsApproval(Map<String, String> formData) {
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
			
	        _pMap.put("STATUS", "A");
	        _pMap.put("USER_ID", formData.get("USER_ID"));
	        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
	        
			// STEP1
	        sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
			// STEP2
	        sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
			
	        formData.put("TYPE", "1"); // 1 - approval
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRS_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("승인 후처리에 실패하였습니다.");
		}

		return "OK";
	}
	
	// 소싱제출 반려 후 처리 
	public String crsReject(Map<String,String> formData){
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
			
	        _pMap.put("STATUS", "B");
	        _pMap.put("USER_ID", formData.get("USER_ID"));
	        
			// STEP1
	        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
			// STEP2
	        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
			
	        formData.put("TYPE", "2"); // 2 - reject
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRS_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("반려 후처리에 실패하였습니다.");
		}
		return "OK";
	}
	
	// 소싱제출 상신취소 후 처리 
	public String crsCancel(Map<String,String> formData){
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
			
			_pMap.put("STATUS", "D");
			
			// STEP1
			sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
			// STEP2
			sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
	        
			formData.put("TYPE", "3"); // 3 - cancel
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRS_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("상신취소 후처리에 실패하였습니다.");
		}
		return "OK";
	}
	
	// 판가제출 상신 후 처리 
	public String cruRequest(Map<String,String> formData){
		try{
			formData.put("TYPE", "0"); // 0 - request
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRU_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("상신 후처리에 실패하였습니다.");
		}

		return "OK";
	}
	
	// 판가제출 승인 후 처리
	public String  cruApproval(Map<String, String> formData) {
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
			
	        _pMap.put("STATUS", "A");
	        _pMap.put("USER_ID", formData.get("USER_ID"));
	        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
	        
			// STEP1
	        sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
			// STEP2
	        sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
			
	        formData.put("TYPE", "1"); // 1 - approval
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRU_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("승인 후처리에 실패하였습니다.");
		}

		return "OK";
	}
	
	// 판가제출 반려 후 처리 
	public String cruReject(Map<String,String> formData){
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
			
	        _pMap.put("STATUS", "B");
	        _pMap.put("USER_ID", formData.get("USER_ID"));
	        
			// STEP1
	        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
			// STEP2
	        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
			
	        formData.put("TYPE", "2"); // 2 - reject
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRU_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("반려 후처리에 실패하였습니다.");
		}
		return "OK";
	}
	
	// 판가제출 상신취소 후 처리 
	public String cruCancel(Map<String,String> formData){
		try{
			formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
	        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
			
			_pMap.put("STATUS", "D");
			
			// STEP1
			sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
			// STEP2
			sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
	        
			formData.put("TYPE", "3"); // 3 - cancel
			sqlSessionTemplate.update("master.mdcm.call_PROC_CRU_UPDATE", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("상신취소 후처리에 실패하였습니다.");
		}
		return "OK";
	}
	
	public List<Map<String,String>> caRqResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectCaRqResultList", param);
	}
}
