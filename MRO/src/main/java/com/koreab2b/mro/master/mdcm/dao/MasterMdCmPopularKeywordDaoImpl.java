package com.koreab2b.mro.master.mdcm.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmPopularKeywordDao")
@Transactional
public class MasterMdCmPopularKeywordDaoImpl implements MasterMdCmPopularKeywordDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmPopularKeywordDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public Map<String,String> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmPopularKeywordList", param);
	}

	// 저장
	public String updateSelectedData(Map<String,String> param) {
		
		_rtnMsg = "";
		
		String gbn_ins_up = "";
		try{
			
			gbn_ins_up = CommonUtil.nvl(param.get("st_gbn_ins_up"));

			if(gbn_ins_up.equals("insert")){
				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmPopularKeyword", param);	
			} else {
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmPopularKeyword", param);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("인기검색어 등록/수정이 실패하였습니다");
		}
		return _rtnMsg;
	}
}
