package com.koreab2b.mro.master.wmgr.dao;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvTranStatementWritePopService;
import com.koreab2b.mro.util.ResultRowHandler;




@Repository("masterWmGrBarcodeDao")
@Transactional
public class MasterWmGrBarcodeDaoImpl implements MasterWmGrBarcodeDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmGrBarcodeDaoImpl.class);

	@Autowired
	private SellerMpIvTranStatementWritePopService sellerMpIvTranStatementWritePopService;
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<String> buyerParam;
		List<String> agnetrParam;
		List<String> invoParam;
		buyerParam = Arrays.asList( ((String)param.get("st_buyer_code")).split("@"));
		agnetrParam = Arrays.asList( ((String)param.get("st_agent_code")).split("@"));
		
	    if(buyerParam.size() >1 || !"".equals((String)param.get("st_buyer_code")) )
	    {
	    	param.put("buyerParam",buyerParam);
	    	param.put("buyerCnt","1");
	    }
	    if(agnetrParam.size() >1 || !"".equals((String)param.get("st_agent_code")) )
	    {
	    	param.put("agnetrParam",agnetrParam );
	    	param.put("agentCnt","1");
	    }
	    List<Map<String, String>> resultList = null;
	    if("0".equals(param.get("pageflag"))){
		    ResultRowHandler _resultHander = new ResultRowHandler();
			sqlSessionTemplate.select("master.wmgr.selectMasterWmGrBarcodeList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
	    }
	    else{
	    	resultList = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrBarcodeList", param);
	    }

		return resultList;
	}


}
