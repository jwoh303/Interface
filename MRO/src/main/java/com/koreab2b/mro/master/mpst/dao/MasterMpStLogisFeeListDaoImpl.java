package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpStLogisFeeListDao")
@Transactional
public class MasterMpStLogisFeeListDaoImpl implements MasterMpStLogisFeeListDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 물류수수료(부서별)
	public List<Map<String,String>> selectDeptList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStLogisFeeDeptList", param);
	}
	
	// 물류수수료(고객사별)
	public List<Map<String,String>> selectBuyerList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStLogisFeeBuyerList", param);
	}
	
	// 물류수수료(사유별)
	public List<Map<String,String>> selectReasonList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStLogisFeeReasonList", param);
	}
}
