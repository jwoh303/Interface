package com.koreab2b.mro.common.mprq.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMpRqQuotationDmPreviewPopDao")
@Transactional
public class MasterMpRqQuotationDmPreviewPopDaoImpl implements MasterMpRqQuotationDmPreviewPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) formData.get("st_quotation_seq_arr"),"@");
		if(_list.size() > 0){
			formData.put("st_quotation_seq_arr", _list);
		}
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqQuotationDmPreviewPopList", formData);
	}
}

