package com.koreab2b.mro.buyer.mpso.dao;

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

@Repository("buyerMpSoCartCowayDao")
@Transactional
public class BuyerMpSoCartCowayDaoImpl implements BuyerMpSoCartCowayDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartCowayDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 조회
	 */
	public List<Map<String, String>> selectList(Map<String, String> formData) {
		String st_query_cart = formData.get("st_query_cart").toString();
		List<Map<String, String>> list = null;
		if (st_query_cart.equals("ALL")) {
			list = sqlSessionTemplate.selectList("buyer.mpso.getShoppintCartSelectSql1", formData);
			
		} else {
			Map<String, Object> data = new HashMap<String, Object>();
			data.putAll(formData);
			List<String> _list = new ArrayList<String>();
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list.size() > 0) {
				data.put("st_query_cart_array", _list);
			}
			
			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_tmp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
			String st_query_cart_seq = "";
			data.put("st_seqYn", "N");

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
					} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
					if (str != null && str.length == 2){
						data.put("st_cart_seq", str[1]);
							data.put("st_seqYn", "Y");
							st_query_cart_seq += str[0] + str[1] + "@@";
					}else{ // 없으면 원문 그대로
						st_query_cart_seq = st_query_cart_tmp;
					}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			
			list = sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartOrderListConfirm1", data);
		}
		return list;
	}

	public List<Map<String, String>> selectBuyerUserCowayBudgetOrderListPop(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getDeptSelect", formData);
	}

	public List<Map<String, String>> selectBuyerUserCowayBudgetAccountListPop(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBdgtSelect", formData);
	}

	public List<Map<String, String>> selectBuyerCowayUserBudgetAccountListPop(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerAdminBudgetListSql", formData);
	}

	public String getK005List(Map<String, String> formData) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_item_chk"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}
		return sqlSessionTemplate.selectOne("buyer.mpso.getK005List", data);
	}

	public String getBuyerCartQty(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mpso.getBuyerCartQty", formData);
	}

	public String updateAttatch(Map<String, String> formData) {
		String st_query2 = formData.get("st_query2").toString();
		Map<String, String> _data = null;
		String _ICOMCART[] = st_query2.split("@@");
		if (_ICOMCART == null) {
			LOGGER.debug("_ICOMCART 미존재 ");
		} else {
			_data = new HashMap<String, String>();
			_data.put("IMAGE_KEY", _ICOMCART[0]);
			_data.put("BUYER", _ICOMCART[1]);
			_data.put("USER_ID", _ICOMCART[2]);
			_data.put("CONTRACT_NO", _ICOMCART[3]);
			_data.put("CONTRACT_SEQ", _ICOMCART[4]);
			_data.put("BUYER_ITEM_NO", _ICOMCART[5]);
			
			if(_ICOMCART.length > 6){
				_data.put("SEQ", _ICOMCART[6]);	
			}

			sqlSessionTemplate.update("buyer.mpso.updateAttatch", _data);
			/** 파일업로드 테이블 Y 로 변경 */
			// 첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
			Map<String, String> _fildData = new HashMap<String, String>();
			_fildData.put("DOC_NO", _data.get("IMAGE_KEY"));
			sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);
		}

		return "OK";
	}

	// /kr/coway_buyer/proxybuy/bdgt/coway_buyer_admin_bdgt_temp_check.jsp
	public List<Map<String, String>> selectCowayBuyerAdminBdgtTempCheck(Map<String, String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);

		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");

		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
				} 
			
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
				if (str != null && str.length == 2){
					data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
				}else{ // 없으면 원문 그대로
					st_query_cart_seq = st_query_cart_tmp;
				}
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
		
		return sqlSessionTemplate.selectList("buyer.mpso.selectCowayBuyerAdminBdgtTempCheckCoway", data);
	}

	public String setDeleteTempCart(Map<String, String> formData) {
		
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}
		
		sqlSessionTemplate.update("buyer.mpso.deleteIcomcart", data);
		return "OK";
	}

	@Override
	public List<Map<String, String>> selectClcsList(Map<String, String> formData) {

		String st_query_cart = formData.get("st_query_cart").toString();

		List<Map<String, String>> list = null;
		if (st_query_cart.equals("ALL")) {
			list = sqlSessionTemplate.selectList("buyer.mpso.getShoppintCartClcsSelectSql1", formData);
		} else {

			Map<String, Object> data = new HashMap<String, Object>();
			data.putAll(formData);

			List<String> _list = new ArrayList<String>();
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list.size() > 0) {
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_tmp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
			String st_query_cart_seq = "";
			data.put("st_seqYn", "N");

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
					} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
					if (str != null && str.length == 2){
						data.put("st_cart_seq", str[1]);
						data.put("st_seqYn", "Y");
						st_query_cart_seq += str[0] + str[1] + "@@";
					}else{ // 없으면 원문 그대로
						st_query_cart_seq = st_query_cart_tmp;
					}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			
			list = sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartClcsOrderListConfirm1", data);
		}
		return list;
	}

}
