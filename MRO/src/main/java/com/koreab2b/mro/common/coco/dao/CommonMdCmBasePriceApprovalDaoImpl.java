package com.koreab2b.mro.common.coco.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("CommonMdCmBasePriceApprovalDao")
@Transactional
public class CommonMdCmBasePriceApprovalDaoImpl implements CommonMdCmBasePriceApprovalDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonMdCmBasePriceApprovalDao.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> selectBasePriceApprList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("commonMdCmBasePriceApproval.selectBasePriceApprList", param);
	}

	/**
	 * 결재 완료. 신청 디테일을 한 건씩 읽어 CMSCATLG 에 반영한다.
	 * 단건(BP)이면 1행, 일괄(BPM)이면 N행이며 처리 방식은 같다.
	 */
	public String basePriceApprovalA(Map<String,String> param) {

		if (!closeRequest(param, "A")) {
			LOGGER.debug("기준가 결재 반영 건너뜀 - 결재중(C) 신청이 아님 : {}", param.get("KEY_1"));
			return "SKIP";
		}

		List<Map<String,String>> _list =
			sqlSessionTemplate.selectList("commonMdCmBasePriceApproval.selectBasePriceReqDtList", param);

		LOGGER.debug("기준가 결재 완료 반영 대상 {} 건", _list == null ? 0 : _list.size());

		if (_list != null) {
			for (int i = 0; i < _list.size(); i++) {
				Map<String,String> _row = _list.get(i);

				// 변경 기준가가 비어 있으면 반영하지 않는다(신청이 잘못 들어온 경우 CMSCATLG 를 NULL 로 밀지 않기 위해)
				String _price = _row.get("CH_BASE_PRICE");
				if (_price == null || "".equals(_price.trim())) {
					LOGGER.debug("기준가 결재 반영 건너뜀 - 변경 기준가 없음 : {}", _row.get("CMS_CATLG_ID"));
					continue;
				}

				Map<String,String> _p = new HashMap<String,String>();
				_p.put("CMS_CATLG_ID",             _row.get("CMS_CATLG_ID"));
				_p.put("CH_BASE_PRICE",            _price.trim());
				_p.put("CH_BASE_PRICE_TYPE",       _row.get("CH_BASE_PRICE_TYPE"));
				_p.put("CH_BASE_PRICE_TYPE_NM",    _row.get("CH_BASE_PRICE_TYPE_NM"));
				_p.put("BASE_PRICE_CHANGE_REASON", _row.get("BASE_PRICE_CHANGE_REASON"));
				_p.put("USER_ID",                  param.get("USER_ID"));

				sqlSessionTemplate.update("commonMdCmBasePriceApproval.updateBasePriceApply", _p);
			}
		}
		return "OK";
	}

	public String basePriceApprovalB(Map<String,String> param) {
		closeRequest(param, "B");
		return "OK";
	}

	public String basePriceCancel(Map<String,String> param) {
		closeRequest(param, "D");
		return "OK";
	}

	private boolean closeRequest(Map<String,String> param, String status) {
		param.put("STATUS", status);
		if (sqlSessionTemplate.update("commonMdCmBasePriceApproval.updateBasePriceReqHdStatus", param) == 0) {
			return false;
		}
		sqlSessionTemplate.update("commonMdCmBasePriceApproval.updateBasePriceReqDtStatus", param);
		return true;
	}
}
