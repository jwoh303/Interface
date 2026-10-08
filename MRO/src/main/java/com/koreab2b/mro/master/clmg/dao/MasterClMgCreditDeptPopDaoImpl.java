package com.koreab2b.mro.master.clmg.dao;

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

@Repository("masterClMgCreditDeptPopDao")
@Transactional
public class MasterClMgCreditDeptPopDaoImpl implements MasterClMgCreditDeptPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditDeptPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgCreditDeptPop", param);
	}
	// 생성
	@SuppressWarnings("unchecked")
	public String saveMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "코드매핑 처리 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.clmg.insertMasterClMgCreditDeptPop", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("코드매핑 처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "코드매핑 삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.clmg.deleteMasterClMgCreditDeptPop", formData);

			}
		}catch(Exception e){
			throw new RuntimeException("코드매핑 삭제 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	// 여신한도 매핑  리스트 조회
	public List<Map<String,String>> getMasterClMgCreditBondPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgCreditBondPop", param);
	}
	// 여신한도 매핑 생성
	@SuppressWarnings("unchecked")
	public String saveMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "코드매핑 처리 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.clmg.insertMasterClMgCreditBondPop", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("코드매핑 처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 여신한도 매핑 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "코드매핑 삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.clmg.deleteMasterClMgCreditBondPop", formData);

			}
		}catch(Exception e){
			throw new RuntimeException("코드매핑 삭제 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	// 여신한도 예외 매핑  리스트 조회
	public List<Map<String,String>> getMasterClMgBondExcpPop(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgBondExcpPop", param);
	}
	// 여신한도 매핑 생성
	@SuppressWarnings("unchecked")
	public String saveMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "여신한도 제외 처리 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.clmg.insertMasterClMgBondExcpPop", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("여신한도 제외 처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "여신한도제외 해제 완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.clmg.deleteMasterClMgBondExcpPop", formData);

			}
		}catch(Exception e){
			throw new RuntimeException("여신한도제외 해제 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
}
