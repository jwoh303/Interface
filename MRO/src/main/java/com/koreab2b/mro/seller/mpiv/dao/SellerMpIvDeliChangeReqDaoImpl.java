package com.koreab2b.mro.seller.mpiv.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpIvDeliChangeReqDao")
@Transactional
public class SellerMpIvDeliChangeReqDaoImpl implements SellerMpIvDeliChangeReqDao {
//	Private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryProgressStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvDeliChangeReqList", formData);
	}
	public List<Map<String,String>> getSellerMpIvDeliChangeReqList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliChangeReqList_v2", formData);
	}
	
	
	// 취소요청
	public String updateSellerMpIvDeliChangeReqCancel(Map<String,String> pMap) {
		String _rtnMsg = "취소요청 중 에러가 발생하였습니다.";
		
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
				_map.put("seq",				str[4]);
				_map.put("agent",			str[5]);
				_map.put("st_user_id", pMap.get("st_user_id"));
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				sqlSessionTemplate.update("seller.mpiv.updateSellerMpIvDeliChangeReqCancel", (Map<String, String>)_list.get(i));
			}
			
			_rtnMsg = "취소요청이 완료되었습니다.";
			
		}catch(Exception e){
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 요청사항 상세 팝업
	public List<Map<String,String>> getSellerMpIvDeliChangeReqDetailPop(Map<String,String>  pMap){
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliChangeReqDetailPop", pMap);
	}
}
