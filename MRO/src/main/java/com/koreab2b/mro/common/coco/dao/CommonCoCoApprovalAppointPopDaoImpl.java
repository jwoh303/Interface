package com.koreab2b.mro.common.coco.dao;

import java.util.ArrayList;
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

@Repository("commonCoCoApprovalAppointPopDao")
@Transactional
public class CommonCoCoApprovalAppointPopDaoImpl implements CommonCoCoApprovalAppointPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoApprovalAppointPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> getApprovalMultiPathList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getApprovalMultiPathList", pMap);
	}
	
	public String setCommonCoCoApprovalInfo(Map<String,String> pMap) {
		
		//선택된 디폴트결재선외 초기화
		sqlSessionTemplate.update("common.coco.updateAppPath_defaultApproval", pMap);
		
		Map<String,String> param = null;
		
		String user_id = (String) pMap.get("st_user_id");
		String[] app_path = CommonUtil.StrToArray((String) pMap.get("app_path"), ",");
		String[] subject = CommonUtil.StrToArray((String) pMap.get("subject"), ",");
		String[] defaultFlag = CommonUtil.StrToArray((String) pMap.get("defaultFlag"), ",");
		
		for(int inx = 0 ; inx < subject.length ; inx++){
			param = new HashMap<String, String>();
			param.put("st_user_id", user_id);
			param.put("app_path", app_path[inx]);
			param.put("subject", subject[inx]);
			param.put("defaultFlag", defaultFlag[inx]);
			sqlSessionTemplate.update("common.coco.insertAppPathCreate", param);
		}
		
		return "INSERT_OK";
	}
	
	public void updateAppPathDefaultApproval(Map<String,String> pMap) {
		sqlSessionTemplate.update("common.coco.updateAppPath_defaultApproval", pMap);
	}
	
	public void insertAppPathCreate(Map<String,String> pMap) {
		sqlSessionTemplate.update("common.coco.insertAppPathCreate", pMap);
	}
	
	public void deleteAppPathRemove_appt(Map<String,String> pMap) {
		sqlSessionTemplate.update("common.coco.deleteAppPathRemove_appt", pMap);
	}
	
	public void deleteAppPathRemove_apse(Map<String,String> pMap) {
		sqlSessionTemplate.update("common.coco.deleteAppPathRemove_apse", pMap);
	}
	
	public List<Map<String,String>> getApprovalMultiPathUserList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.coco.getApprovalMultiPathUserList", pMap);
	}
	
	public List<Map<String,String>> getApprovalMultiPathUserNm_arry(Map<String,String> pMap) {
		List<Map<String,String>> resultList = null;
		String[] arry_user_id = CommonUtil.StrToArray((String) pMap.get("arry_user_id"), ",");
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("arry_user_id", arry_user_id);
		param.put("gubun", (String) pMap.get("gubun"));
		if(arry_user_id != null && arry_user_id.length > 0){
			resultList = sqlSessionTemplate.selectList("common.coco.getApprovalMultiPathUserNm_arry", param);
		}else{
			resultList = new ArrayList<Map<String,String>>();
		}
		return resultList;
	}
	
	public void deleteAppPathDetailRemove_all(Map<String,String> pMap) {
		sqlSessionTemplate.delete("common.coco.deleteAppPathDetailRemove_all", pMap);
	}
	
	public void insertAppPathDetailCreate(Map<String,String> pMap) {
		sqlSessionTemplate.update("common.coco.insertAppPathDetailCreate", pMap);
	}
	
	public String delCommonCoCoApprovalInfo(Map<String,String> pMap) {
		sqlSessionTemplate.delete("common.coco.deleteAppPathRemove_appt", pMap);
		sqlSessionTemplate.delete("common.coco.deleteAppPathRemove_apse", pMap);
		return "OK";
	}
	
	public String regApproverInfoList(Map<String,String> pMap) {
		// 결재/참조 정보 삭제
		sqlSessionTemplate.delete("common.coco.deleteAppPathDetailRemove_all", pMap);
		
		Map<String,String> param = null;
		String[]  to_str_id_list = CommonUtil.StrToArray((String) pMap.get("to_str_id"), ",");
		String[]  cc_str_id_list = CommonUtil.StrToArray((String) pMap.get("cc_str_id"), ",");
		
		// 결재자 정보 등록
		if(to_str_id_list != null && to_str_id_list.length > 0){
			for(int inx = 0 ; inx < to_str_id_list.length ; inx++){
				param = new HashMap<String, String>();
				param.put("app_path", CommonUtil.nvl((String) pMap.get("app_path"),""));
				param.put("st_user_id", CommonUtil.nvl((String) pMap.get("st_user_id"),""));
				
				if(to_str_id_list[inx].substring(0, 1).equals("^")){
					param.put("gubun", "H");
					param.put("appr_id", to_str_id_list[inx].replace("^", ""));
				}else{
					param.put("gubun", "C");
					param.put("appr_id", to_str_id_list[inx]);
				}
				
				param.put("appr_seq", String.valueOf(inx+1));
				
				sqlSessionTemplate.update("common.coco.insertAppPathDetailCreate", param);
			}
		}
		
		// 참조자 정보 등록
		if(cc_str_id_list != null && cc_str_id_list.length > 0){
			for(int inx = 0 ; inx < cc_str_id_list.length ; inx++){
				param = new HashMap<String, String>();
				param.put("app_path", CommonUtil.nvl((String) pMap.get("app_path"),""));
				param.put("st_user_id", CommonUtil.nvl((String) pMap.get("st_user_id"),""));
				param.put("appr_id", cc_str_id_list[inx]);
				param.put("appr_seq", String.valueOf(0));
				param.put("gubun", "R");
				
				sqlSessionTemplate.update("common.coco.insertAppPathDetailCreate", param);
			}
		}
		
		return "INSERT_OK";
	}
	
}
