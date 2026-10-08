package com.koreab2b.mro.master.mpst.dao;

import java.util.List;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpStPriceAdjustmentDao")
@Transactional
public class MasterMpStPriceAdjustmentDaoImpl implements MasterMpStPriceAdjustmentDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 견적 최저가 예외 현황
	public List<Map<String,String>> getMasterMpStQuotExceptionList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStQuotExceptionList", param);
	}
	
	// 견적 최저가 예외 상세
	public List<Map<String,String>> getMasterMpStQuotExceptionDetailList(Map<String,Object> param) {
		List<String> list = CommonUtil.getStringArrary((String) param.get("st_buyer"), "@");
		param.put("st_buyer", list);
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStQuotExceptionDetailList", param);
	}
	
	// 주문 단가조정 현황
	public List<Map<String,String>> getMasterMpStPoPriceAdjustList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStPoPriceAdjustList", param);
	}
	
	// 주문 단가조정 상세
	public List<Map<String,String>> getMasterMpStPoPriceAdjustDetailList(Map<String,Object> param) {
		List<String> list = CommonUtil.getStringArrary((String) param.get("st_buyer"), "@");
		param.put("st_buyer", list);
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStPoPriceAdjustDetailList", param);
	}
}
