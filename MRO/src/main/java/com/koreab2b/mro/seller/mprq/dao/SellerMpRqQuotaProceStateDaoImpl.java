package com.koreab2b.mro.seller.mprq.dao;

import java.util.ArrayList;
import java.util.HashMap;
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

@Repository("sellerMpRqQuotaProceStateDao")
@Transactional
public class SellerMpRqQuotaProceStateDaoImpl implements SellerMpRqQuotaProceStateDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpRqQuotaProceStateDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	/*조회*/
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String>  param) {
		String pageflag = (String) param.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("seller.mprq.selectSellerMpRqQuotaProceState", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("seller.mprq.selectSellerMpRqQuotaProceState", param);
		}
		return resultList;
		
	}
	
	// 저장
	public String saveSellerMpRqQuotaProceState(Map<String,String> pMap) {

		String _rtnMsg = "저장 중 에러가 발생하였습니다.";
		
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", str[0]);
				_map.put("quotation_no", str[1]);
				_map.put("quotation_seq", str[2]);
				_map.put("revision", str[3]);
				_map.put("agent", str[4]);
				_map.put("agent_revision", str[5]);
				_map.put("lead_time", str[6]);
				_map.put("stoa_list_price", str[7]);
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				sqlSessionTemplate.update("seller.mprq.updateSellerMpRqQuotaProceState", (Map<String, String>)_list.get(i));
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
}
