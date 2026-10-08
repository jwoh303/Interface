package com.koreab2b.mro.common.mpcl.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpClTranBuyerChoicePopDao")
@Transactional
public class SellerMpClTranBuyerChoicePopDaoImpl implements SellerMpClTranBuyerChoicePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	/**
	 * 고객사 목록 조회 (무한 스크롤 페이징 지원)
	 * - pageNum, pageSize 파라미터가 있으면 페이징 처리
	 * - 없으면 전체 조회 (기존 동작 유지)
	 */
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.putAll(formData);

		// 페이징 파라미터 처리
		String pageNumStr = formData.get("pageNum");
		String pageSizeStr = formData.get("pageSize");

		if (pageNumStr != null && pageSizeStr != null
				&& !pageNumStr.isEmpty() && !pageSizeStr.isEmpty()) {
			try {
				int pageNum = Integer.parseInt(pageNumStr);
				int pageSize = Integer.parseInt(pageSizeStr);
				int startRow = (pageNum - 1) * pageSize;
				int endRow = pageNum * pageSize;

				param.put("startRow", startRow);
				param.put("endRow", endRow);
				param.put("pageSize", pageSize);
			} catch (NumberFormatException e) {
				// 숫자 변환 실패 시 페이징 없이 전체 조회
			}
		}

		return sqlSessionTemplate.selectList("common.mpcl.selectSellerMpClTranBuyerChoicePopList", param);
	}
	
}
