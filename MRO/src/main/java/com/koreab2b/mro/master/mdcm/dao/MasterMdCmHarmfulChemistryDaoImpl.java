package com.koreab2b.mro.master.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterMdCmHarmfulChemistryDao")
@Transactional
public class MasterMdCmHarmfulChemistryDaoImpl implements MasterMdCmHarmfulChemistryDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmHarmfulChemistryDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmHarmfulChemistryList", param);
	}
	// T실적데이터 생성
	public String createMasterMdCmHarmfulChemistry(Map<String,String>  formData){
		try{
				String st_close_month = formData.get("st_close_month").toString(); 
			 	Map<String,String> _data = null;
	     		_data = new HashMap<String,String>() ;
		        _data.put("st_close_month", st_close_month);
		        sqlSessionTemplate.update("master.mdcm.createMasterMdCmHarmfulChemistry", _data);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실적 데이터 생성에 실패하였습니다.");
		}
		return null;
	} 
}
