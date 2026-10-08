package com.koreab2b.mro.master.mdcd.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCdBuyerCardSearchDao")
@Transactional
public class MasterMdCdBuyerCardSearchDaoImpl implements MasterMdCdBuyerCardSearchDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
		
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		if (!param.get("st_buyer_code").equals("")) {
			_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
			if (_list.size() > 0) {
				param.put("buyer_code_array", _list);
			}
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mdcd.selectMasterMdCdBuyerCardSearchList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mdcd.selectMasterMdCdBuyerCardSearchList", param);
		}
		
		return resultList;
	}
}
