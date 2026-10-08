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

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdAmLogManageDao")
@Transactional
public class MasterMdAmLogManageDaoImpl implements MasterMdAmLogManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmLogManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmLogManageList", param);
	}

	// 감사로그 기록 (KEPSITE_LOG)
	// STMT_ID 를 넘기면 운영사 팝업(CommonPopupInfoDaoImpl#commonList)과 동일하게
	// ATTR_01 앞에 실행 SQL 전문을 붙인다. 안 넘기면 호출부가 만든 ATTR_01 을 그대로 쓴다.
	public void saveLog(Map<String,Object> param) {
		Object _stmtId = param.get("STMT_ID");
		if (_stmtId != null && !"".equals(_stmtId)) {
			String _sql = sqlSessionTemplate.getConfiguration()
					.getMappedStatement((String) _stmtId).getBoundSql(param).getSql();
			param.put("ATTR_01", _sql + "/" + CommonUtil.nvl((String) param.get("ATTR_01")));
		}
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", param);
	}

}
