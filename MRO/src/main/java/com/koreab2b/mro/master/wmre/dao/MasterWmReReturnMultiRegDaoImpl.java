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

@Repository("masterWmReReturnMultiRegDao")
@Transactional
public class MasterWmReReturnMultiRegDaoImpl implements MasterWmReReturnMultiRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmReReturnMultiRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmre.selectMasterWmReReturnMultiRegList", param);
	}

	// BNTTRXL 저장
	@SuppressWarnings("unchecked")
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		
		try{
			// STEP1 - INSERT 전 본인 기존 등록건 삭제
			sqlSessionTemplate.update("master.wmre.initBntTrxlMasterWmreReturnMultiUplolad", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP2 - BNTTRXL INSERT
				sqlSessionTemplate.update("master.wmre.setBntTrxlMasterWmreReturnMultiUplolad", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// BNTTRXL 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 삭제되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmre.deleteBntTrxlMasterWmreReturnMultiUplolad", formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
	}

	// 등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 등록되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1 - BNTWMRE INSERT
				sqlSessionTemplate.update("master.wmre.insertMasterWmreReturnMulti", formData);
				
				// STEP2 - BNTTRXL DELETE
				sqlSessionTemplate.update("master.wmre.deleteBntTrxlMasterWmreReturnMultiUplolad", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
