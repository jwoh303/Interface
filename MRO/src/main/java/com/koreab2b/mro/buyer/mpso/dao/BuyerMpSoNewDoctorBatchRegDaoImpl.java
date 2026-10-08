package com.koreab2b.mro.buyer.mpso.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.rfc.coway.dao.BuyerCowayRfcDao;

@Repository("buyerMpSoNewDoctorBatchRegDao")
@Transactional
public class BuyerMpSoNewDoctorBatchRegDaoImpl implements BuyerMpSoNewDoctorBatchRegDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private BuyerCowayRfcDao buyerCowayRfcDao;

	@Override
	public List<Map<String, Object>> selectList(Map<String, String> formData) {
		List<Map<String, Object>> result= new ArrayList<Map<String, Object>>();
		List<Map<String, String>> attrList= null;
		List<String> itemList = new ArrayList<String>();
		
		itemList.add("6112073");
		itemList.add("6112077");
		itemList.add("6112172");
		itemList.add("6112175");
		itemList.add("6112174");
		itemList.add("6112173");
		itemList.add("6112078");
		itemList.add("6112170");
		itemList.add("6112171");
		itemList.add("6112079");
		itemList.add("6112076");
		itemList.add("6112075");
		itemList.add("6112074");
		/*
		itemList.add("6103560");
		itemList.add("6105768");
		itemList.add("6110340");
		itemList.add("6105875");
		itemList.add("6106061");
		itemList.add("6105979");
		itemList.add("6104616");
		itemList.add("6104679");
		itemList.add("6109211");
		itemList.add("6109210");
		itemList.add("6104462");
		itemList.add("6109170");
		itemList.add("6109171");
		*/
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("buyer", formData.get("st_buyer"));
		map.put("item_list", itemList);
		result = sqlSessionTemplate.selectList("buyer.mpso.getNewDoctorBatchOrderCatalog", map);
		for (int i = 0; i < result.size(); i++) {
			map = new HashMap<String, Object>();
			map.putAll(result.get(i));
			attrList= new ArrayList<Map<String, String>>();
			String[] rprsntItemNoList = String.valueOf(map.get("RPRSNT_ITEM_NO")).split("@@");
			String[] specificationList = String.valueOf(map.get("SPECIFICATION")).split("@@");
			Map<String, String> rprsntItemNoMap = null;
			for (int j = 0; j < rprsntItemNoList.length; j++) {
				rprsntItemNoMap = new HashMap<String, String>();
				rprsntItemNoMap.put("BUYER_ITEM_NO", rprsntItemNoList[j]);
				rprsntItemNoMap.put("ATTR", specificationList[j]);
				attrList.add(j, rprsntItemNoMap);
			}
			map.put("NO", i+1);
			map.put("ITEM", attrList);
			result.remove(i) ; 
			result.add(i, map); 
		}
		return result;
//		return getNewDoctorItemList(formData);
	}

	@Override
	public Map<String, String> setNewDoctorCreatePo(List<Map<String, String>> pList) {
		Map<String, String> rtn = new HashMap<String, String>();
		String stQueryCartValue = null;
		for (Map<String, String> map : pList) {
			sqlSessionTemplate.update("buyer.mdcm.insertBuyerMdCmGoodsLisCreate", map);
			stQueryCartValue = sqlSessionTemplate.selectOne("buyer.mdcm.getStQueryCartValue", map);
		}
		rtn.put("ST_QUERY_CART", stQueryCartValue);
		return rtn;
	}

	/**
	 * 관리품목 시스템 기준 기본리스트
	 * 
	 * @param formData
	 * @return
	 */
	@SuppressWarnings("unused")
	private List<Map<String, Object>> getNewDoctorItemList(Map<String, String> formData) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> row = null;
		List<Map<String, String>> attrList = null;
		Map<String, String> attrMap = null;
		int idx = 0;
		
		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "DIGITAL TESTER,디지털 테스터");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6103560");
		attrMap.put("ATTR", "DIGITAL TESTER,디지털 테스터;POCKET TYPE 직류450V,교류450V,저항42MΩ용도:닥터공구");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "THERMOMETER,온도계");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6105768");
		attrMap.put("ATTR", "THERMOMETER,온도계;-50~150도,0.1 단위,닥터공구");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "ELECTRIC DRILL,전동 드릴");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6105875");
		attrMap.put("ATTR", "ELECTRIC DRILL,전동 드릴;500W, 닥터공구");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "튜빙커터기");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6105875");
		attrMap.put("ATTR", "튜빙커터기;5/32~5/8\" 칼날SUS, 닥터공구");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "비데렌치(Dr. Site 전용)");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6105979");
		attrMap.put("ATTR", "닥터사이드 전용(5EA)");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "하트필터");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6104616");
		attrMap.put("ATTR", "하트필터;하트서비스필터;");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "(플라스틱)정수기용 피팅기");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6104679");
		attrMap.put("ATTR", "1EA:3PCS/플라스틱/11CM");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "실리콘제거기");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6109211");
		attrMap.put("ATTR", "양면날");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "닥터서류철");
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6109210");
		attrMap.put("ATTR", "A4");
		attrList = new ArrayList<Map<String, String>>();
		attrList.add(attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);

		row = new HashMap<String, Object>();
		row.put("NO", String.valueOf(idx + 1));
		row.put("DESCRIPTION", "공구가방");
		attrList = new ArrayList<Map<String, String>>();
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6104462");
		attrMap.put("ATTR", "A형 가로450X세로330X폭120");
		attrList.add(0, attrMap);
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6109170");
		attrMap.put("ATTR", "B형 가로400X세로305X폭130");
		attrList.add(1, attrMap);
		attrMap = new HashMap<String, String>();
		attrMap.put("BUYER_ITEM_NO", "6109171");
		attrMap.put("ATTR", "C형 가로430X세로300X폭220");
		attrList.add(2, attrMap);
		row.put("ITEM", attrList);
		row.put("USER_NAME_LOC", "");
		row.put("REQ_QTY", 1);
		row.put("MIN_QTY", 1);
		row.put("MAX_QTY", 1);
		row.put("DEDUCT_RATE", 0);
		row.put("UNIT_PRICE", 0);
		list.add(idx++, row);
		return list;
	}
}
