package com.koreab2b.mro.common.mdcp.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.wm.lang.schema.Empty;

@Repository("masterMdCpAgentContactManageDao")
@Transactional
public class MasterMdCpAgentContactManageDaoImpl implements MasterMdCpAgentContactManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpAgentContactManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 협력사 목록 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;

		// 협력사 조회
		resultList = sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentContactList", param);

		return resultList;
	}
	
	// 이메일/문자 발송내역 관리 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getAgentDmHistoryList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		String STR_DM_SUBJECT = "DM_SUBJECT";
		String STR_CHECKBOX_MAIL = "st_checkbox_mail";
		String STR_CHECKBOX_SMS = "st_checkbox_sms";
		String STR_SENDTYPE_MAIL = "M";
		String STR_SENDTYPE_SMS = "S";
		int MAX_LENGTH = 50;

		List<String> sendTypeList = new ArrayList<String>();
		if(param.get(STR_CHECKBOX_MAIL) != null) sendTypeList.add(STR_SENDTYPE_MAIL);
		if(param.get(STR_CHECKBOX_SMS) != null) sendTypeList.add(STR_SENDTYPE_SMS);
		if(sendTypeList.size() > 0) param.put("sendType", sendTypeList);
		// 협력사 DM 발송 이력 조회
		resultList = sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentDmHistoryList", param);

		// 제목/문구 50자 제한 적용
		for(int i=0; i < resultList.size(); i++){
			if(resultList.get(i).get(STR_DM_SUBJECT) != null)	resultList.get(i).put(STR_DM_SUBJECT, CommonUtil.textMore(resultList.get(i).get(STR_DM_SUBJECT), MAX_LENGTH));
		}

		return resultList;
	}

	// 협력사 연락처 관리 이력 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getContactHistoryiList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;

		// 협력사 연락처 관리 이력 조회
		resultList = sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentContactHistoryiList", param);

		return resultList;
	}
	
	// 수신처 정보 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getMasterMdCpAgentDmHistoryContactList(Map<String,Object> param) {

		// 수신처 정보 조회
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpAgentDmHistoryContactList", param);
	}
}
