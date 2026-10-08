package com.koreab2b.mro.master.wmco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmCoMgDao")
@Transactional
public class MasterWmCoMgDaoImpl implements MasterWmCoMgDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoMgDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// warehouse_code 조회
	public String getForwarehouseCode(Map<String,Object> param) {
	
		 String wareHouse_code =   sqlSessionTemplate.selectOne("master.wmco.selectForwarehouseCode", param);
		 
		 return  wareHouse_code;
	}
	
	
	// warehouse_Agent조회
	public String getForwarehouseAgent(Map<String,Object> param) {
		
		 return  sqlSessionTemplate.selectOne("master.wmco.selectForwarehouseAgent", param);
	}


}
