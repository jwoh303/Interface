package com.koreab2b.mro.master.mdct.dao;

import java.util.ArrayList;
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

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCtCustomerInfoManageDao")
@Transactional
public class MasterMdCtCustomerInfoManageDaoImpl implements MasterMdCtCustomerInfoManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtCustomerInfoManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtCustomerInfoManageList", param);
	}
	//고객 엑셀 업로드
	@SuppressWarnings("unchecked")
	public String uploadMasterMdCtCustomerInfoManage(Map<String, String> param,List<Object> gridData) {
		
		String _rtnMsg = "저장완료 되었습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				List<Map<String,String>>_list = null;
				_list = sqlSessionTemplate.selectList("master.mdct.checkMasterMdCtCustomerInfo",param);
				String resultYn = CommonUtil.getListKeyValue(_list,"RESULT_YN","");				
				String nextCodeVal = sqlSessionTemplate.selectOne("master.mdct.selectMasterMdCdCpAddrNextcodeVal", param);
				param.put("nextCodeVal", nextCodeVal);				
				
				//기존 등록 되어있으면  Y:update N:insert
				if(resultYn.equals("Y")){
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtCustomerInfo", param);
					sqlSessionTemplate.update("master.mdct.insertMasterMdCtCustomerInfoCpAddr", param);					
				}else{
					sqlSessionTemplate.update("master.mdct.insertMasterMdCtCustomerInfo", param);
					sqlSessionTemplate.update("master.mdct.insertMasterMdCtCustomerInfoCpAddr", param);
				}
			}
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			String msg = "저장에 실패하였습니다.";
			throw new RuntimeException(msg);
		}
		return _rtnMsg; 
	}
	
	// 잠재고객등록 팝업
	public List<Map<String,String>> selectCustomerInfo(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectCustomerInfo", param);
	}

}
