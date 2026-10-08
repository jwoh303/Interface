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

@Repository("MasterMpRqQuotationBulkHistroyDao")
@Transactional
public class MasterMpRqQuotationBulkHistroyDaoImpl implements MasterMpRqQuotationBulkHistroyDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationBulkHistroyDaoImpl.class);

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
		
		//진행상태코드
		param.put("st_status_all", CommonUtil.getStringArrary((String) param.get("st_status"), ","));
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqQuotationBulkHistroyList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqQuotationBulkHistroyList", param);
		}
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mprq.insertBulkQuotationList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}

}
