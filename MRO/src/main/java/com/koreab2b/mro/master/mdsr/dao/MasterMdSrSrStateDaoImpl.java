package com.koreab2b.mro.master.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrStateDao")
@Transactional
public class MasterMdSrSrStateDaoImpl implements MasterMdSrSrStateDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		try{
			return sqlSessionTemplate.selectList("master.mdsr.selectMasterMdSrSrStateList", param);
		} catch (Exception e){
				throw new RuntimeException("조회에 실패하였습니다.");
		}
		
	}

}
