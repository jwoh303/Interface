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

@Repository("masterMdAmRoleManageDao")
@Transactional
public class MasterMdAmRoleManageDaoImpl implements MasterMdAmRoleManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmRoleManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmRoleManageList", param);
	}

	
	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmRoleManageDetailList", param);
	}

	// 저장(상세)
	@SuppressWarnings("unchecked")
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String roleFlag = formData.get("ROLE_FLAG");
				String status = formData.get("sStatus");

				if("S".equals(roleFlag)){//특수권한 추가/갱신
					if("I".equals(status)){
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmRoleManageDetail_S", formData);
					}else if("U".equals(status)){
						sqlSessionTemplate.update("master.mdam.updateMasterMdAmRoleManageDetail_S", formData);
					}
				}else{//일반권한 추가/갱신
					if("I".equals(status)){
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmRoleManageDetail", formData);
					}else if("U".equals(status)){
						sqlSessionTemplate.update("master.mdam.updateMasterMdAmRoleManageDetail", formData);
					}
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
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		

				String roleFlag = formData.get("ROLE_FLAG");

				if("S".equals(roleFlag)){
					sqlSessionTemplate.update("master.mdam.deleteMasterMdAmRoleManageDetail_S", formData);
				}else{
					sqlSessionTemplate.update("master.mdam.deleteMasterMdAmRoleManageDetail", formData);
				}

				logger.error("deleteMasterMdAmRoleManageDetail 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
