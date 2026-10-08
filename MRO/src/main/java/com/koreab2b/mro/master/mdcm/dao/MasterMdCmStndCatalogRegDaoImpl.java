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

@Repository("masterMdCmStndCatalogRegDao")
@Transactional
public class MasterMdCmStndCatalogRegDaoImpl implements MasterMdCmStndCatalogRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndCatalogRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmStndCatalogRegList", param);
	}

	// 생성
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "표준카탈로그 등록 요청이 완료되었습니다.";
		
		try{
			Map<String,String> _dataDetailParam = null;
			String subject = "";
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				if(i ==0){
					subject = formData.get("DESCRIPTION_LOC");
					logger.debug("subject : {}", subject);
				}
				//변경 내역 저장.
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmStndCatalogReg", formData);
				//표준카탈로그 등록
				sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmStndCatalogReg", formData);
				//CMSCATLG_ADD 업데이트
				sqlSessionTemplate.insert("master.mdcm.updateMasterMdCmStndCatalogRegAdd", formData);
				
				
				logger.error("updateSelectedData 실행 완료");

			}
			_dataDetailParam = new HashMap<String,String>() ;
			_dataDetailParam.put("RECEIVE_EMAIL", formData.get("st_recv_mail"));
			_dataDetailParam.put("RECEIVE_NAME", formData.get("st_recv_name"));
			_dataDetailParam.put("SUBJECT", "[KoreaB2B.com] 표준카탈로그 등록요청 메일이 도착하였습니다.");
			_dataDetailParam.put("CONTENTS", subject+"포함 "+gridData.size()+"건 표준카탈로그 등록 요청하였으니 구매대행 > 상품관리 > 표준카탈로그 승인대상 조회화면에서 처리 바랍니다.");
			sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmKepMail", _dataDetailParam);
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("표준카탈로그 등록에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
	
	// 등록품의
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> saveMasterMdCmStndCatalogApprList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "품의상신 하여햐 합니다.";
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
					formData.put("PM_NO", _pm_no);
					sqlSessionTemplate.update("master.mdcm.insertMasterMdcmScaKEPMGPHD", formData);
				}
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.mdcm.insertMasterMdcmScaKEPMGPDT", formData);
				//변경 내역 저장. 상태업데이트
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmStndCatalogApprReg", formData);
				logger.error("updateSelectedData 실행 완료");
				_pm_seq++;
			}
		}catch(Exception e){
			throw new RuntimeException("표준카탈로그 등록품의에 실패하였습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
		
	}
	// 등록품의
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> saveMasterMdCmStndCatalogApprPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "품의상신 하여햐 합니다.";
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
					formData.put("PM_NO", _pm_no);
					sqlSessionTemplate.update("master.mdcm.insertMasterMdcmScaKEPMGPHD", formData);
				}
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.mdcm.insertMasterMdcmScaKEPMGPDT", formData);
				//변경 내역 저장. 상태업데이트
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmStndCatalogRegPop", formData);
				logger.error("updateSelectedData 실행 완료");
				_pm_seq++;
			}
		}catch(Exception e){
			throw new RuntimeException("표준카탈로그 등록품의에 실패하였습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
		
	}
	public String nextCmscatlgVal(String cmpyId)
	{
		String returnValue = null;
		Map<String, String>  pMap = new HashMap<String, String>();
		
		pMap.put("COM_CODE", cmpyId);
		try {
			returnValue = sqlSessionTemplate.selectOne("master.mdcm.getCmscatlgVal", pMap);
		} catch (Exception e){
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcm.deleteMasterMdCmStndCatalogReg", formData);
				logger.error("deleteMasterMdCmStndCatalogReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	
	// 파일업로드
	@SuppressWarnings("unchecked")
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "File Upload 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.insert("master.mdcm.batchMasterMdCmStndCatalogReg", formData);
				logger.error("batchSelectedData 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("File Upload에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}

		return _rtnMsg;		
		
	}	

	// 임시저장
	@SuppressWarnings("unchecked")
	public String saveTempMasterMdCmStndCatalogRegList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장이 정상적으로 이루어 졌습니다.";
		String str = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				
				str = gridMap.get("sStatus").toString();
				logger.debug("STR요청 파라미터 : {}", str);
				if(str.equals("I")){
					//insert
					sqlSessionTemplate.insert("master.mdcm.insertpTempMasterMdCmStndCatalogReg", formData);
				}else{
					// update
					sqlSessionTemplate.update("master.mdcm.updateTempMasterMdCmStndCatalogReg", formData);
				}
				
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패 했습니다.\n\n관리자에게 문의 하세요");
				
		}
		return _rtnMsg;
	}
	// 생성
	@SuppressWarnings("unchecked")
	public String saveMasterMdCmStndCatalogRegPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "표준카탈로그 등록 요청 완료되었습니다.";
		
		try{
			Map<String,String> _dataDetailParam = null;
			String subject = "";
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				if(i ==0){
					subject = formData.get("DESCRIPTION_LOC");
					logger.debug("subject : {}", subject);
				}
				//표준카탈로그 등록
				sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmStndCatalogRegPopReg", formData);
			}
			_dataDetailParam = new HashMap<String,String>() ;
			_dataDetailParam.put("RECEIVE_EMAIL", formData.get("st_recv_mail"));
			_dataDetailParam.put("RECEIVE_NAME", formData.get("st_recv_name"));
			_dataDetailParam.put("SUBJECT", "[KoreaB2B.com] 표준카탈로그 등록요청 메일이 도착하였습니다.");
			_dataDetailParam.put("CONTENTS", subject+"포함 "+gridData.size()+"건 표준카탈로그 등록 요청하였으니 구매대행 > 상품관리 > 표준카탈로그 승인대상 조회화면에서 처리 바랍니다.");
			sqlSessionTemplate.insert("master.mdcm.insertMasterMdCmKepMail", _dataDetailParam);
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("표준카탈로그 등록에 실패 했습니다.\n\n관리자에게 문의 하세요");
		}
		return _rtnMsg;
	}
	
}
