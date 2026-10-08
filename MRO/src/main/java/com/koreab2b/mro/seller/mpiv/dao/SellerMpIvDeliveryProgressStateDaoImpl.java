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

@Repository("sellerMpIvDeliveryProgressStateDao")
@Transactional
public class SellerMpIvDeliveryProgressStateDaoImpl implements SellerMpIvDeliveryProgressStateDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryProgressStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvDeliveryProgressStateList", formData);
	}
	
	// 납품예정일 변경요청
	public String updateSellerMpIvDsDateChangeReq(Map<String,String> pMap) {
		String _rtnMsg = "변경요청 중 에러가 발생하였습니다.";
		
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
				_map.put("ds_seq",			str[3]);
				_map.put("pr_no", 			str[4]);
				_map.put("pr_seq",			str[5]);
				_map.put("agent",			str[6]);
				_map.put("re_ds_date",		str[7]);
				_map.put("ch_ds_date",		str[8]);
				_map.put("delay_reason",	str[9]);
				_map.put("st_user_id",	pMap.get("st_user_id"));
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				String ds_date_dup_chk = "";
				ds_date_dup_chk = sqlSessionTemplate.selectOne("seller.mpiv.getSellerMpIvDsDateDupChk", (Map<String, String>)_list.get(i)); // 변경 납품예정일이 기존에 있는 경우 오류
				
				if("Y".equals(ds_date_dup_chk)) {
					_rtnMsg = "기존 등록된 납품예정일로 변경은 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				sqlSessionTemplate.insert("seller.mpiv.insertSellerMpIvDsDateChangeReq", (Map<String, String>)_list.get(i));
			}
			
			_rtnMsg = "변경요청이 완료되었습니다.";
			
		}catch(Exception e){
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 수주접수 초기화요청
	public String updateSellerMpIvIvInfoChangeReq(Map<String,String> pMap) {
		String _rtnMsg = "변경요청 중 에러가 발생하였습니다.";
		
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");

			logger.debug("query_str============ : {}", query_str);
			logger.debug("check_str[]============ : {}", check_str);
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				logger.debug("str[]============ : {}", str);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 			str[0]);
				_map.put("po_no", 			str[1]);
				_map.put("agent",			str[2]);
				_map.put("change_reason", pMap.get("st_reason"));
				_map.put("st_user_id", pMap.get("st_user_id"));
				_list.add(_map);
				
				logger.debug("_map============ : {}", _map);
				logger.debug("_list============ : {}", _list);
			}
			
			
			for(int i=0; i < _list.size(); i++){
				logger.debug("_list.get(i)============ : {}", (Map<String, String>)_list.get(i));
				sqlSessionTemplate.insert("seller.mpiv.insertSellerMpIvIvInfoChangeReq", (Map<String, String>)_list.get(i));
			}
			
			_rtnMsg = "변경요청이 완료되었습니다.";
			
		}catch(Exception e){
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 리뉴얼 > 조회
	public List<Map<String,String>> getSellerMpIvDeliveryProgressStateList_v2(Map<String,Object> formData) {
		List<String> list = CommonUtil.getStringArrary((String)formData.get("st_po_no"), ",");
		if(list.size() != 0){
			formData.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliveryProgressStateList_v2", formData);
	}
	
}
