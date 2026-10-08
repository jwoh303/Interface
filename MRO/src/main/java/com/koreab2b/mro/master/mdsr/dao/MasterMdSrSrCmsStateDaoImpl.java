package com.koreab2b.mro.master.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrCmsStateDao")
@Transactional
public class MasterMdSrSrCmsStateDaoImpl implements MasterMdSrSrCmsStateDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		try{
			return sqlSessionTemplate.selectList("master.mdsr.selectMasterMdSrSrCmsStateList", param);
		} catch (Exception e){
				throw new RuntimeException("조회에 실패하였습니다.");
		}
		
	}

}
