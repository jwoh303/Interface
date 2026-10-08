package com.koreab2b.mro.master.wmre.dao;

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

@Repository("masterWmReReturnRegDao")
@Transactional
public class MasterWmReReturnRegDaoImpl implements MasterWmReReturnRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmReReturnRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmReReturnRegList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmre.insertMasterWmReReturnReg", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmre.deleteMasterWmReReturnReg", formData);
				logger.error("deleteMasterWmReReturnReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	// 수주접수이력체크
	public List<Map<String,String>> getPorsYn(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmRePorsYn", formData);
	}
	// 계산서발행체크
	public List<Map<String,String>> getArApYn(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmReArApYn", formData);
	}
	public List<Map<String,String>> getArApYn_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmReArApYn_v2", formData);
	}
	// 수주접수이력체크
	public List<Map<String,String>> getIvGrYn(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmReIvGrYn", formData);
	}
	// 발주취소
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> saveMasterWmReCancleReturn(Map<String,String>  formData, List<Object> gridData) {
		
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
					sqlSessionTemplate.update("master.wmre.insertMasterWmReKEPMGPHD", formData);
				}
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.wmre.insertMasterWmReKEPMGPDT", formData);
				_pm_seq++;
			}
		}catch(Exception e){
			throw new RuntimeException("발주취소에 실패하였습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
		
	}
	
	// 반품일괄종결
	@SuppressWarnings("unchecked")
	public String updateEndAllData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "반품일괄종결 완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmre.updateMasterWmReReturnEndAll", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
