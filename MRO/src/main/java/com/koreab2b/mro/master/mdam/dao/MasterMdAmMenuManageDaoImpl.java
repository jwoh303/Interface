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

@Repository("masterMdAmMenuManageDao")
@Transactional
public class MasterMdAmMenuManageDaoImpl implements MasterMdAmMenuManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMenuManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMenuManageList", param);
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
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmMenuManage", formData);
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.insertMasterMdAmMenuManage").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "메뉴별권한관리");
					data.put("LOG_TYPE", "권한추가");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("MENU_ID"));
					data.put("ATTR_03", formData.get("NAME"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				}else if("U".equals(status)){
					sqlSessionTemplate.update("master.mdam.updateMasterMdAmMenuManage", formData);
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.updateMasterMdAmMenuManage").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "메뉴별권한관리");
					data.put("LOG_TYPE", "권한추가");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("MENU_ID"));
					data.put("ATTR_03", formData.get("NAME"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				}
				
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	
	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMenuManageDetailList", param);
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
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmMenuManageDetail", formData);
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.insertMasterMdAmMenuManageDetail").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "메뉴별권한관리(상세)");
					data.put("LOG_TYPE", "권한추가");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("MENU_ID"));
					data.put("ATTR_03", formData.get("AUTH_ID"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				}else if("U".equals(status)){
					sqlSessionTemplate.update("master.mdam.updateMasterMdAmMenuManageDetail", formData);
					/*로그 기록*/
					String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.updateMasterMdAmMenuManageDetail").getBoundSql(formData).getSql();
					String attr_01 = "";
					for(Map.Entry<String, String>entry: formData.entrySet()){
						attr_01 += entry.getKey() + "="+entry.getValue() + "/";
					}
					Map<String, Object> data = new HashMap<String, Object>();
					data.putAll(formData);
					data.put("SYSTEM", "KOREAB2B");
					data.put("MENU", "메뉴별권한관리(상세)");
					data.put("LOG_TYPE", "권한추가");
					data.put("ATTR_01", strSql+"/"+attr_01);
					data.put("ATTR_02", formData.get("MENU_ID"));
					data.put("ATTR_03", formData.get("AUTH_ID"));
					sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
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
				
				sqlSessionTemplate.update("master.mdam.deleteMasterMdAmMenuManageDetail", formData);
				/*로그 기록*/
				String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdam.deleteMasterMdAmMenuManageDetail").getBoundSql(formData).getSql();
				String attr_01 = "";
				for(Map.Entry<String, String>entry: formData.entrySet()){
					attr_01 += entry.getKey() + "="+entry.getValue() + "/";
				}
				Map<String, Object> data = new HashMap<String, Object>();
				data.putAll(formData);
				data.put("SYSTEM", "KOREAB2B");
				data.put("MENU", "메뉴별권한관리(상세)");
				data.put("LOG_TYPE", "권한삭제");
				data.put("ATTR_01", strSql+"/"+attr_01);
				data.put("ATTR_02", formData.get("MENU_ID"));
				data.put("ATTR_03", formData.get("AUTH_ID"));
				sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				logger.error("deleteMasterMdAmMenuManageDetail 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}		
}
