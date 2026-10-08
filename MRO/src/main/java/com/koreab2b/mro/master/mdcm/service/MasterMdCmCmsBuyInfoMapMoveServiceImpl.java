package com.koreab2b.mro.master.mdcm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsBuyInfoMapMoveDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterMdCmCmsBuyInfoMapMoveService")
@Transactional
public class MasterMdCmCmsBuyInfoMapMoveServiceImpl implements MasterMdCmCmsBuyInfoMapMoveService {

	@Autowired
	private MasterMdCmCmsBuyInfoMapMoveDao masterMdCmCmsBuyInfoMapMoveDao;

	public Map<String,String> getStdInfo(Map<String,Object> param) {
		return masterMdCmCmsBuyInfoMapMoveDao.selectStdInfo(param);
	}

	public List<Map<String,String>> getCustList(Map<String,Object> param) {
		return masterMdCmCmsBuyInfoMapMoveDao.selectCustList(param);
	}

	public List<Map<String,String>> getStdSelList(Map<String,Object> param) {
		return masterMdCmCmsBuyInfoMapMoveDao.selectStdSelList(param);
	}

	public int moveMapping(Map<String,String> param, List<Object> gridData) {
		return masterMdCmCmsBuyInfoMapMoveDao.moveMapping(param, gridData);
	}

	/* IN 절은 1000개 제한이 있다 — 잘라 조회하고 이어 붙인다(일괄수정과 같은 규약). */
	private static final int IN_CHUNK = 1000;

	public List<Map<String,String>> getMapFormList(List<String> codes) {
		return selectByChunk(codes, "form");
	}

	public List<Map<String,String>> getMapTargetList(List<String> codes) {
		return selectByChunk(codes, "target");
	}

	private List<Map<String,String>> selectByChunk(List<String> codes, String kind) {
		List<Map<String,String>> result = new ArrayList<Map<String,String>>();
		List<String> uniq = distinctNonEmpty(codes);

		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));

			List<Map<String,String>> part = "form".equals(kind)
				? masterMdCmCmsBuyInfoMapMoveDao.selectMapFormList(param)
				: masterMdCmCmsBuyInfoMapMoveDao.selectMapTargetList(param);

			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	private List<String> distinctNonEmpty(List<String> codes) {
		List<String> out = new ArrayList<String>();
		if (codes == null) { return out; }
		for (int i = 0; i < codes.size(); i++) {
			String v = CommonUtil.nvl(codes.get(i)).trim();
			if (v.length() > 0 && !out.contains(v)) { out.add(v); }
		}
		return out;
	}
}
