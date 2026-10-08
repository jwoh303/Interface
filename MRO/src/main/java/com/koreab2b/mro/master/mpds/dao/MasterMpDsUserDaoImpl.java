package com.koreab2b.mro.master.mpds.dao;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpds.controller.MasterMpDsUserController;

@Repository("masterMpDsUserDao")
@Transactional
public class MasterMpDsUserDaoImpl implements MasterMpDsUserDao {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsUserController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpds.selectMasterMpDsUserList", param);
	}
	
	// 저장(견적의뢰)
	@SuppressWarnings("unchecked")
	public int updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		
		try {
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String status = formData.get("sStatus");
				if("I".equals(status)){
					sqlSessionTemplate.insert("master.mpds.insertMasterMpDsUser", formData);
				}else if("U".equals(status)){
					sqlSessionTemplate.insert("master.mpds.updateMasterMpDsUser", formData);
				}else{
				}
			}
		} catch (Exception e){
			logger.debug("Exception : ", e);
			throw new RuntimeException( "저장에 실패하였습니다.");
		}
		return 0;
	}
	

}
