package com.koreab2b.mro.seller.mpiv.dao;

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

@Repository("sellerMpIvDeliveryRecordDeleteDao")
@Transactional
public class SellerMpIvDeliveryRecordDeleteDaoImpl implements SellerMpIvDeliveryRecordDeleteDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryRecordDeleteDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvDeliveryRecordDeleteList", pMap);
	}


	// 삭제
	public String saveSellerMpIvDeliveryRecordDelete(Map<String,String> pMap){

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 			str[0]);
				_map.put("po_no", 			str[1]);
				_map.put("po_seq", 			str[2]);
				_map.put("inv_no", 			str[3]);
				_map.put("inv_seq",			str[4]);
				_map.put("delivery_qty",	str[5]);
				
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){

				// 1. ICOMIVDT UPDATE
				sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordDeleteIvdt", (Map<String, String>)_list.get(i));
				
				// 2. ICOMPODT UPDATE
				sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordDeletePodt", (Map<String, String>)_list.get(i));
				
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("납품실적삭제 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
}
