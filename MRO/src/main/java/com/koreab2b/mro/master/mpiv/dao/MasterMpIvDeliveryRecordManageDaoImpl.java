package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIvDeliveryRecordManageDao")
@Transactional
public class MasterMpIvDeliveryRecordManageDaoImpl implements MasterMpIvDeliveryRecordManageDao {
//	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDeliveryRecordManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpiv.selectMasterMpIvDeliveryRecordManageList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
		
//		return sqlSessionTemplate.selectList("master.mpiv.selectMasterMpIvDeliveryRecordManageList", param);
	}
}
