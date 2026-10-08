package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpIvObtnodrReceiptDao")
@Transactional
public class SellerMpIvObtnodrReceiptDaoImpl implements SellerMpIvObtnodrReceiptDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> param) {
//		String pageflag = (String) param.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
//		if("0".equals(pageflag)){
		
		sqlSessionTemplate.select("seller.mpiv.selectSellerMpIvObtnodrReceiptList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
			 
//		}else{
//			resultList =  sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvObtnodrReceiptList", param);
//		}
		return resultList;
	}

	public List<Map<String,String>> selectExcelList(Map<String,String> param) {
//		String pageflag = (String) param.get("paging");
//		ResultRowHandler _resultHander = new ResultRowHandler();
//		List<Map<String, String>> resultList = null;
//		if("0".equals(pageflag)){
//			 sqlSessionTemplate.select("seller.mpiv.selectSellerMpIvObtnodrReceiptList", param, _resultHander);
//			 resultList = (List<Map<String, String>>)_resultHander.getList();
//		}else{
//			resultList =  sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvObtnodrReceiptExcelList", param);
//		}
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvObtnodrReceiptExcelList", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptList_v2(Map<String,Object> param) {
		List<String> list = CommonUtil.getStringArrary((String)param.get("st_po_no"), ",");
		if(list.size() != 0){
			param.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvObtnodrReceiptList_v2", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptMultiList_v2(Map<String,Object> param) {
		List<String> list = CommonUtil.getStringArrary((String)param.get("st_po_no"), ",");
		if(list.size() != 0){
			param.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvObtnodrReceiptMultiList_v2", param);
	}
	
}
