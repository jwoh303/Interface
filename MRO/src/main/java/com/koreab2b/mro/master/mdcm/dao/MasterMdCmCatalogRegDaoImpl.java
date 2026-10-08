package com.koreab2b.mro.master.mdcm.dao;

import java.util.Calendar;
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


@Repository("masterMdCmCatalogRegDao")
@Transactional
public class MasterMdCmCatalogRegDaoImpl implements MasterMdCmCatalogRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogRegList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장이 정상적으로 이루어 졌습니다.";
		//String mode = formData.get("st_mode");
		String str = "";		
		try{
			//reg메시지 없음.
			/*if(mode.equals("reg")){
				_rtnMsg = "";
			}*/
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				str = gridMap.get("NEW_YN").toString();
					
					if(str.equals("Y")){
						//insert
						sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCatalogReg", formData);
					}else{
						// update
						sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogReg", formData);
					}
				
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			/*mode = formData.get("st_mode");
			if(mode.equals("reg")){
				throw new RuntimeException("품의상신에 실패 했습니다.\n\n관리자에게 문의 하세요");
			}else{
				throw new RuntimeException("저장에 실패 했습니다.\n\n관리자에게 문의 하세요");
			}*/
			
			throw new RuntimeException("저장에 실패 했습니다.\n\n관리자에게 문의 하세요");
			
				
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmCatalogReg", formData);
				logger.error("deleteMasterMdCmCatalogReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("카탈로그 삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	
	// 등록
	@SuppressWarnings("unchecked")
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "카탈로그 등록이 정상적으로 이루어 졌습니다.  ";
		String str = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				str = gridMap.get("NEW_YN").toString();
				
				if(str.equals("Y")){
					//insert
					sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCatalogReg", formData);
				}else{
					// update
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogReg", formData);
				}

				//등록로직 수행
				sqlSessionTemplate.update("master.mdcm.regMasterMdCmCatalogReg", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("카탈로그 등록이 실패하였습니다. 다시 확인하여 주십시요.  ");
		}
		return _rtnMsg;
	}
	
	// 품의상신
	@SuppressWarnings("unchecked")
	public Map<String,String> consSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 되었습니다.";
		String str = "";
		String _pm_no = null;
		int _pm_seq = 1;
		String dssChk = "Y";
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				str = gridMap.get("NEW_YN").toString();
				String comOrgCode = CommonUtil.nvl(formData.get("BUYER"), "");
				//제제업체 발생 시 오류 발생				
				formData.put("AGENT", CommonUtil.nvl(formData.get("AGENT_CODE"), ""));
				formData.put("BUYER", CommonUtil.nvl(formData.get("BELOW_COMORG_CODE"), ""));
				dssChk = (String) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegBNot", formData);
				formData.put("BUYER", comOrgCode);
				if(dssChk.equals("Y")) { // 제제대상 없으면
					//저장로직 수행.
					if(str.equals("Y")){
						//insert
						sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCatalogReg", formData);
					}else{
						// update
						sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogReg", formData);
					}
					
					if (i == 0){
						pMap.put("COM_CODE", "KRKORE0001");
						pMap.put("DOC_TYPE", "PM");
						
						//sqlSessionTemplate.update("common.updateDocuNo", pMap);
						//sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
						
						_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM"); 
						formData.put("PM_NO", _pm_no);
						sqlSessionTemplate.update("master.mdcm.insertNcaKEPMGPHD", formData);
					}
					
					formData.put("PM_NO", _pm_no);
					formData.put("PM_SEQ", String.valueOf(_pm_seq));
					sqlSessionTemplate.update("master.mdcm.insertNcaKEPMGPDT", formData);
					_pm_seq++;
					
					
					//품의상신 로직 수행(AS-IS ICOMTRXL테이블 INSERT)
					//sqlSessionTemplate.update("master.mdcm.consMasterMdCmCatalogReg", formData);
				} else {					
					throw new RuntimeException((i+1) + "번째 행 제제업체(협력사) 입니다.\n"+CommonUtil.nvl(formData.get("BELOW_COMORG_CODE"), "") + "<->" + CommonUtil.nvl(formData.get("AGENT_CODE"), ""));
				}
				
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(dssChk.equals("Y")) {
				throw new RuntimeException("품의상신에 실패 했습니다.\n\n관리자에게 문의 하세요");
			} else {
				throw new RuntimeException(e.getMessage());
			}
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		return pMap;
	}
	
	// 일괄업로드
	@SuppressWarnings("unchecked")
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "엑셀 업로드 완료되었습니다.";		
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				// insert
				sqlSessionTemplate.insert("master.mdcm.batchMasterMdCmCatalogReg", formData);
				
			
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("엑셀 업로드에 실패 했습니다.\n\n관리자에게 문의 하세요");
				
		}
		return _rtnMsg;
	}
	
	// 복사
	@SuppressWarnings("unchecked")
	public String copySelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 복사되었습니다. ";
		double copy_cnt_temp;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				copy_cnt_temp = Double.parseDouble(formData.get("st_copy_cnt").toString());
				
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				for(int j = 1; j<copy_cnt_temp+1; j++) {
					//copy
					sqlSessionTemplate.update("master.mdcm.copyMasterMdCmCatalogReg", formData);
				}
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("복사에 실패 했습니다.\n\n관리자에게 문의 하세요");
				
		}
		return _rtnMsg;
	}
	
	// cms등록
	@SuppressWarnings("unchecked")
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 등록의뢰 되었습니다.";
		String str = "";
		String strQuatationNo = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				str = gridMap.get("NEW_YN").toString();
				
				//저장로직 수행.
				if(str.equals("Y")){
					//insert
					sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmCatalogReg", formData);
				}else{
					// update
					sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogReg", formData);
				}
				
				strQuatationNo =getOrderNo(formData.get("st_buyer_code"),"CM");
				formData.put("QUOTATION_NO", strQuatationNo);
				formData.put("QUOTATION_SEQ", String.valueOf(i+1));
				
				//CMS등록로직 수행(1, KEPRQDT insert 2, ICOMBYIT_ADD update)
				sqlSessionTemplate.update("master.mdcm.confirmInsertMasterMdCmCatalogReg", formData);
				sqlSessionTemplate.update("master.mdcm.confirmUpdateMasterMdCmCatalogReg", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록의뢰중 실패하였습니다.관리자에게 문의하여 주시길 바랍니다.  ");
		}
		return _rtnMsg;
	}
	
	//채번
	public String getOrderNo(String cmpyId, String docType) throws Exception{
		String returnValue = null;
		Map<String, String>  pMap = new HashMap<String, String>();
		
		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			logger.debug("채번 - returnValue : ", returnValue);
			
			if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);
				
				String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
				returnValue = docType +year.substring(2,4) + "000001";
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
			}
			logger.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			logger.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
	
	
	public String getBuyerRateAdaptFlag(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("master.mdcm.getBuyerRateAdaptFlag",pMap);
	}
	
	public String getBuyerRateInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("master.mdcm.getBuyerRateInfo",pMap);
	}
	
	public String getProcessTypeRateInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("master.mdcm.getProcessTypeRateInfo",pMap);
	}
	
	public String getBuyerStandardRate(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("master.mdcm.getBuyerStandardRate",pMap);
	}
	
	public Map<String,String> getTotProcessTypeRateInfo(Map<String,String>  pMap){
		return sqlSessionTemplate.selectOne("master.mdcm.getTotProcessTypeRateInfo",pMap);
	};
	
	
	public String getCatalogRegBottomOrgCodeMultiPop(Map<String,String>  pMap){
		
		StringBuffer sb = new StringBuffer();
		List<Map<String,String>> _result = sqlSessionTemplate.selectList("master.mdcm.selectCatalogRegBottomOrgCodeMultiPop",pMap);
		if (_result != null){
			for (int i =0; i <_result.size(); i++){
				Map<String,String> rmap = _result.get(i);
				if (rmap != null){
					sb.append(rmap.get("COM_CODE"));
					sb.append(",,,");
				}
			}
		}
		
		return sb.toString();
	}
	
	
	// 카탈로그신규등록 요청 후 처리(NCA)
	public String ncaRequest(Map<String,String> formData){
		
		List<Map<String,String>> _result = sqlSessionTemplate.selectList("master.mdcm.selectNcaApprovalRequestList", formData);
		if(_result.size() >0){
			for(int i=0 ; i<_result.size() ; i++){
				Map<String, String> _pMap = _result.get(i);
				// STEP1
				sqlSessionTemplate.update("master.mdcm.updateInitICOMBYITADD", _pMap);
			}
		}
        
		return "OK";
	}
	
	// 카탈로그신규등록 결재 상신취소 후 처리(NCA)
	public String ncaCancel(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		
		_pMap.put("STATUS", "D");
		
		// delete ICOMBYIT_ADD
        //sqlSessionTemplate.update("master.mdcm.updateCancelICOMBYITADD", _pMap);
		// STEP1
		sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
        
		return "OK";
	}
	
	// 카탈로그신규등록 결재 승인 후 처리(NCA)
	public String ncaApproval(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "A");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        _pMap.put("USER_DEPT", formData.get("USER_DEPT"));
		
        // ICOMBYIT_ADD테이블 update
        sqlSessionTemplate.update("master.mdcm.updateApprovalICOMBYITADD", _pMap);
        // STEP1
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPRQDT", _pMap);
		// STEP2 - 고객사로 부터 네고요청 들어온 건에 대해 운영자가 바로 고객사 네고 견적 제출
		sqlSessionTemplate.update("master.mprq.updateApprovalICOMCQDT", _pMap);
		// STEP3
		sqlSessionTemplate.update("master.mprq.updateApprovalICOMBYIT", _pMap);
		// STEP4
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPRQDT2", _pMap);
		// STEP5
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPHD", _pMap);
		// STEP6
		sqlSessionTemplate.update("master.mprq.updateApprovalKEPMGPDT", _pMap);
		return "OK";
	}
	
	// 카탈로그신규등록 결재 반려 후 처리(NCA)
	public String ncaReject(Map<String,String> formData){
		
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);
		
        _pMap.put("STATUS", "B");
        _pMap.put("USER_ID", formData.get("USER_ID"));
        
        // delete ICOMBYIT_ADD
        //sqlSessionTemplate.update("master.mdcm.updateCancelICOMBYITADD", _pMap);
        // STEP1
        sqlSessionTemplate.update("master.mprq.updateCancelKEPRQDT", _pMap);
		// STEP2
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPHD", _pMap);
		// STEP3
        sqlSessionTemplate.update("master.mprq.updateRejectKEPMGPDT", _pMap);
		
		return "OK";
	}
	public List<Map<String,String>> ncaResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectNcaResultList", param);
	}
	public List<Map<String,String>> scaResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectScaResultList", param);
	}
	// 재계약 취소
	public String rctCancel(Map<String,String> formData){
		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",formData);        
		_pMap.put("STATUS", "D");
		// STEP1 KEP_RCDT 제출상태 변경
		sqlSessionTemplate.update("master.mdcm.updateCancleKepRcdt", _pMap);
		// STEP2 KEPMGPHD 상태 업데이트
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPHD", _pMap);
		// STEP3 KEPMGPDT 상태 업데이트
		sqlSessionTemplate.update("master.mprq.updateCancelKEPMGPDT", _pMap);
		return "OK";
	}
}
