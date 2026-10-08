package com.koreab2b.mro.common.mpiv.dao;

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

@Repository("sellerMpIvKtagPlanEntryPopDao")
@Transactional
public class SellerMpIvKtagPlanEntryPopDaoImpl implements SellerMpIvKtagPlanEntryPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvKtagPlanEntryPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvKtagPlanEntryPopList", formData);
	}
	
	
	// 저장
	public String updateSelectedData(Map<String,String> pMap) {

		
		String _rtnMsg = "성공";
		Map<String,String> _map = null;		
		Map<String,String> _map2 = null;
		
		try{
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			String _str[] = check_str[0].split("@@",0);
			_map2 = new HashMap<String, String>();
			_map2.put("buyer" , _str[0]);
			_map2.put("inv_no" , _str[1]);
			_map2.put("inv_seq" , _str[2]);
			_map2.put("buyer_item_no" , _str[3]);

			System.out.println("!@#!@#!@#!@#$!@$!@#$@#%@#$%^====="+_map2.get("inv_no"));
			
			sqlSessionTemplate.delete("common.mpiv.deleteSellerMpIvKtagPlanEntryPop", _map2);
			_map2.clear();
			
			for(int i=0 ; i < check_str.length; i++){
				System.out.println("!@#!@#!@#!@#$!@$!@#$@#%@#$%^====="+check_str.length);
				String str[] = check_str[i].split("@@",0);
				_map = new HashMap<String, String>();
				_map.put("buyer",	str[0]);
				_map.put("inv_no", 	str[1]);
				_map.put("inv_seq", 		str[2]);
				_map.put("buyer_item_no", 		str[3]);
				_map.put("st_seq", 		str[4]);
				_map.put("inv_qty", 		str[5]);
				_map.put("cd_qty",	str[6]);
				_map.put("po_no",		str[7]);
				_map.put("po_seq",		str[8]);
				
				sqlSessionTemplate.insert("common.mpiv.insertSellerMpIvKtagPlanEntryPop", _map);

				}
		}catch(Exception e){
			_rtnMsg = "저장에 실패하였습니다";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	
}
	
