package com.koreab2b.mro.master.mdam.dao;

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

import com.googlecode.ehcache.annotations.TriggersRemove;

@Repository("masterMdAmUserManageDao")
@Transactional
public class MasterMdAmUserManageDaoImpl implements MasterMdAmUserManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmUserManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmUserManageList", param);
	}

	
	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmUserManageDetailList", param);
	}

	// 저장(상세)
	@SuppressWarnings("unchecked")
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String roleFlag = formData.get("ROLE_FLAG");
				String status = formData.get("sStatus");
				
				if("S".equals(roleFlag)){//특수권한 추가/갱신
					if("I".equals(status)){
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmUserManageDetail_S", formData);
						/*로그 기록*/
						String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.insertMasterMdAmUserManageDetail_S").getBoundSql(formData).getSql();
						String attr_01 = "";
						for(Map.Entry<String, String>entry: formData.entrySet()){
							attr_01 += entry.getKey() + "="+entry.getValue() + "/";
						}
						Map<String, Object> data = new HashMap<String, Object>();
						data.putAll(formData);
						data.put("SYSTEM", "KOREAB2B");
						data.put("MENU", "사용자별권한관리");
						data.put("LOG_TYPE", "권한추가");
						data.put("ATTR_01", strSql+"/"+attr_01);
						data.put("ATTR_02", formData.get("USER_ID"));
						data.put("ATTR_03", formData.get("AUTH_ID"));
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
						
					}else if("U".equals(status)){
						sqlSessionTemplate.update("master.mdam.updateMasterMdAmUserManageDetail_S", formData);
						/*로그 기록*/
						String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.updateMasterMdAmUserManageDetail_S").getBoundSql(formData).getSql();
						String attr_01 = "";
						for(Map.Entry<String, String>entry: formData.entrySet()){
							attr_01 += entry.getKey() + "="+entry.getValue() + "/";
						}
						Map<String, Object> data = new HashMap<String, Object>();
						data.putAll(formData);
						data.put("SYSTEM", "KOREAB2B");
						data.put("MENU", "사용자별권한관리");
						data.put("LOG_TYPE", "권한추가");
						data.put("ATTR_01", strSql+"/"+attr_01);
						data.put("ATTR_02", formData.get("USER_ID"));
						data.put("ATTR_03", formData.get("AUTH_ID"));
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
					}
				}else{//일반권한 추가/갱신
					if("I".equals(status)){
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmUserManageDetail", formData);
						/*로그 기록*/
						String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.insertMasterMdAmUserManageDetail").getBoundSql(formData).getSql();
						String attr_01 = "";
						for(Map.Entry<String, String>entry: formData.entrySet()){
							attr_01 += entry.getKey() + "="+entry.getValue() + "/";
						}
						Map<String, Object> data = new HashMap<String, Object>();
						data.putAll(formData);
						data.put("SYSTEM", "KOREAB2B");
						data.put("MENU", "사용자별권한관리");
						data.put("LOG_TYPE", "권한추가");
						data.put("ATTR_01", strSql+"/"+attr_01);
						data.put("ATTR_02", formData.get("USER_ID"));
						data.put("ATTR_03", formData.get("AUTH_ID"));
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
					}else if("U".equals(status)){
						sqlSessionTemplate.update("master.mdam.updateMasterMdAmUserManageDetail", formData);
						/*로그 기록*/
						String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.updateMasterMdAmUserManageDetail").getBoundSql(formData).getSql();
						String attr_01 = "";
						for(Map.Entry<String, String>entry: formData.entrySet()){
							attr_01 += entry.getKey() + "="+entry.getValue() + "/";
						}
						Map<String, Object> data = new HashMap<String, Object>();
						data.putAll(formData);
						data.put("SYSTEM", "KOREAB2B");
						data.put("MENU", "사용자별권한관리");
						data.put("LOG_TYPE", "권한추가");
						data.put("ATTR_01", strSql+"/"+attr_01);
						data.put("ATTR_02", formData.get("USER_ID"));
						data.put("ATTR_03", formData.get("AUTH_ID"));
						sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
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
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public String deleteSelectedDetailData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		

				String roleFlag = formData.get("ROLE_FLAG");
				
				if("S".equals(roleFlag)){
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.deleteMasterMdAmUserManageDetail_S").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "사용자별권한관리");
					data.put("LOG_TYPE", "권한삭제");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("USER_ID"));
					data.put("ATTR_03", formData.get("AUTH_ID"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
					
					sqlSessionTemplate.update("master.mdam.deleteMasterMdAmUserManageDetail_S", formData);
				}else{
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.deleteMasterMdAmUserManageDetail").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "사용자별권한관리");
					data.put("LOG_TYPE", "권한삭제");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("USER_ID"));
					data.put("ATTR_03", formData.get("AUTH_ID"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
					
					sqlSessionTemplate.update("master.mdam.deleteMasterMdAmUserManageDetail", formData);
				}

				logger.error("deleteMasterMdAmUserManageDetail 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
