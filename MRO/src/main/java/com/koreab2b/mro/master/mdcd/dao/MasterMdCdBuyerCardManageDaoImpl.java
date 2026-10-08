package com.koreab2b.mro.master.mdcd.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCdBuyerCardManageDao")
@Transactional
public class MasterMdCdBuyerCardManageDaoImpl implements MasterMdCdBuyerCardManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdBuyerCardManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mdcd.selectMasterMdCdBuyerCardManageList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mdcd.selectMasterMdCdBuyerCardManageList", param);
		}
		
		return resultList;
	}

	// 저장
	public String updateSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "OK";
		
		try {
			String _comCnt = sqlSessionTemplate.selectOne("master.mdcd.selectMasterMdCdBuyerCardManageCompanyCnt", formData);
			// STEP1
			if (Integer.parseInt(_comCnt) == 0) {
				sqlSessionTemplate.insert("master.mdcd.insertMasterMdCdBuyerCardManage", formData);
			} else {
				_rtnMsg = "DUP";
			}

		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("고객관리(INSERT KEP_VISITHD) 에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
}
