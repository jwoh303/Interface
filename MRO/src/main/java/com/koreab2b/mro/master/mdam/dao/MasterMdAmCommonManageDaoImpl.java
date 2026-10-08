package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.TriggersRemove;

@Repository("masterMdAmCommonManageDao")
@Transactional
public class MasterMdAmCommonManageDaoImpl implements MasterMdAmCommonManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmCommonManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmCommonManageList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String status = formData.get("sStatus");

				if("I".equals(status)){
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmCommonManage", formData);
				}else if("U".equals(status)){
					sqlSessionTemplate.update("master.mdam.updateMasterMdAmCommonManage", formData);
				}
				
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
				
				sqlSessionTemplate.update("master.mdam.deleteMasterMdAmCommonManage", formData);
				logger.error("deleteMasterMdAmCommonManage 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

	
	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmCommonManageDetailList", param);
	}

	// 저장(상세)
	@SuppressWarnings("unchecked")
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String status = formData.get("sStatus");

				if("I".equals(status)){
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmCommonManageDetail", formData);
				}else if("U".equals(status)){
					sqlSessionTemplate.update("master.mdam.updateMasterMdAmCommonManageDetail", formData);
				}
				
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제(상세)
	@SuppressWarnings("unchecked")
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdam.deleteMasterMdAmCommonManageDetail", formData);
				logger.error("deleteMasterMdAmCommonManageDetail 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}		
}
