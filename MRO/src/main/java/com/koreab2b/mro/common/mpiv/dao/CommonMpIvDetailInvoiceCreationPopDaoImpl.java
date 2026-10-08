package com.koreab2b.mro.common.mpiv.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("commonMpIvDetailInvoiceCreationPopDao")
@Transactional
public class CommonMpIvDetailInvoiceCreationPopDaoImpl implements CommonMpIvDetailInvoiceCreationPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvDetailInvoiceCreationPopList", formData);
	}
	
	// 송장 등록
	public Map<String, String> saveCommonMpIvDetailInvoiceCreationPop(Map<String,String> pMap){

		String st_vpo_no	= CommonUtil.nvl((String) pMap.get("st_vpo_no"),"");
		Map<String,String> _map = null;
		
		Map<String, String> resMap = new HashMap<String, String>();
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("st_buyer", 	CommonUtil.nvl((String) pMap.get("st_buyer"),""));
				_map.put("st_vpo_no", 	CommonUtil.nvl((String) pMap.get("st_vpo_no"),""));
				_map.put("buyer_item_no", 	CommonUtil.nvl(str[0],""));
				_map.put("iv_qty", 				CommonUtil.nvl(str[1],""));
				_map.put("rd_date", 				CommonUtil.nvl(str[2],""));
				_map.put("buyer", 				CommonUtil.nvl(str[3],""));
				_map.put("vpo_seq",				CommonUtil.nvl(str[4],""));
				
				sqlSessionTemplate.update("common.mpiv.updateCommonMpIvDetailInvoiceCreationPop", _map);
			}
			
		}catch(Exception e){
			throw new RuntimeException("송장작성 중 에러가 발생하였습니다.");
		}
		
		resMap.put("st_vpo_no", st_vpo_no);
		
		return resMap;
	}
	
}
