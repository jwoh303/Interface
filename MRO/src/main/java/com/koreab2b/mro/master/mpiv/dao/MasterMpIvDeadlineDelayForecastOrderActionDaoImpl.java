package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIvDeadlineDelayForecastOrderActionDao")
@Transactional
public class MasterMpIvDeadlineDelayForecastOrderActionDaoImpl implements MasterMpIvDeadlineDelayForecastOrderActionDao {
//	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDeadlineDelayForecastOrderActionDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List<String> list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_code", list);
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpiv.selectMasterMpIvDeadlineDelayForecastOrderActionList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
		
	}
}
