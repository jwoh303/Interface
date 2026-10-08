package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIvOrderReceiptDelayListDao")
@Transactional
public class MasterMpIvOrderReceiptDelayListDaoImpl implements MasterMpIvOrderReceiptDelayListDao {
//	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvOrderReceiptDelayListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List<String> list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_code", list);
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpiv.selectMasterMpIvOrderReceiptDelayList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
		
//		return sqlSessionTemplate.selectList("master.mpiv.selectMasterMpIvOrderReceiptDelayList", param);
	}
}
