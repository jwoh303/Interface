package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpRqDailySourcingBusinessListDao")
@Transactional
public class MasterMpRqDailySourcingBusinessListDaoImpl implements MasterMpRqDailySourcingBusinessListDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<String> _list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		List<String> _quotNoList = CommonUtil.getStringArrary((String) param.get("st_quotation_no_multi"),"@");
		if(_quotNoList.size() > 0){
			param.put("st_quotation_noArr", _quotNoList);
		}
		List<String> _keyList = CommonUtil.getStringArrary((String) param.get("st_quotation_key_multi"),"@");
		if(_keyList.size() > 0){
			param.put("st_quotation_keyArr", _keyList);
		}
		List<String> _itemNoList = CommonUtil.getStringArrary((String) param.get("st_item_no_multi"),"@");
		if(_itemNoList.size() > 0){
			param.put("st_item_noArr", _itemNoList);
		}

		if("0".equals(param.get("pageflag"))){
			ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("master.mprq.selectMasterMpRqDailySourcingBusinessList", param, _resultHander);
			return (List<Map<String, String>>)_resultHander.getList();
		}
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqDailySourcingBusinessList", param);
	}

}
