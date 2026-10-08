package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpRqSgUserMngDao")
@Transactional
public class MasterMpRqSgUserMngDaoImpl implements MasterMpRqSgUserMngDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqSgUserMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqSgUserMngList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqSgUserMngList", param);
		}
		return resultList;
	}
}
