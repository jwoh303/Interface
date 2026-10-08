package com.koreab2b.mro.master.clmg.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterClMgAddCreditRegDao")
@Transactional
public class MasterClMgAddCreditRegDaoImpl implements MasterClMgAddCreditRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterClMgAddCreditRegDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgAddCreditReg", param);
	}

	// 추가여신 상세 리스트 조회
	public List<Map<String,String>> selectMasterClmgLoanHistoryPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClmgLoanHistoryPop", param);
	}
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 저장되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.clmg.insertMasterClMgAddCreditReg", formData);
				logger.error("insertMasterClMgAddCreditReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "선택된 내역이 삭제되었습니다";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.clmg.deleteMasterClMgAddCreditReg", formData);
				logger.error("deleteMasterClMgAddCreditReg 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
	}
}
