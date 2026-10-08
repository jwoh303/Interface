package com.koreab2b.mro.master.mdcm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsBuyInfoExcelUploadDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterMdCmCmsBuyInfoExcelUploadService")
@Transactional
public class MasterMdCmCmsBuyInfoExcelUploadServiceImpl implements MasterMdCmCmsBuyInfoExcelUploadService {

	@Autowired
	private MasterMdCmCmsBuyInfoExcelUploadDao masterMdCmCmsBuyInfoExcelUploadDao;

	// Oracle IN 절 상한(1000)에 맞춘 조회 단위
	private static final int IN_CHUNK = 1000;

	public List<Map<String,String>> getItemList(List<String> codes) {
		return selectByChunk(codes, "item");
	}

	public List<Map<String,String>> getExistingKeyList(List<String> codes) {
		return selectByChunk(codes, "dup");
	}

	public List<Map<String,String>> getAgentList(List<String> codes) {
		return selectByChunk(codes, "agent");
	}

	public List<String> getItemMakeTypeCodes() {
		List<String> codes = new ArrayList<String>();
		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadDao.selectItemMakeTypeList();
		if (rows != null) {
			for (Map<String,String> row : rows) {
				String code = CommonUtil.nvl(row.get("CODE")).trim();
				if (code.length() > 0) { codes.add(code); }
			}
		}
		return codes;
	}

	public List<Map<String,String>> getModBeforeList(List<String> buyInfoIds) {
		return selectByChunk(buyInfoIds, "modBefore");
	}

	/*
	 * 일괄수정 양식 다운로드 - 선택한 코드 순서대로 양식 1행씩.
	 * 조회 결과를 코드로 인덱싱한 뒤 입력 순서로 다시 늘어놓는다(IN 절은 순서를 보장하지 않는다).
	 * 없는 코드는 구매정보코드만 채운 빈 행으로 남긴다 - 담당자가 양식에서 바로 알아볼 수 있게.
	 */
	public List<Map<String,String>> getModFormRows(List<String> buyInfoIds) {
		List<String> uniq = distinctNonEmpty(buyInfoIds);
		Map<String, Map<String,String>> byCode = new HashMap<String, Map<String,String>>();
		for (Map<String,String> row : getModBeforeList(uniq)) {
			String id = CommonUtil.nvl(row.get("BUY_INFO_ID")).trim();
			if (id.length() > 0 && !byCode.containsKey(id)) { byCode.put(id, row); }
		}

		List<Map<String,String>> rows = new ArrayList<Map<String,String>>();
		for (String code : uniq) {
			Map<String,String> src = byCode.get(code);
			Map<String,String> row = new HashMap<String,String>();
			if (src != null) { row.putAll(src); }
			row.put("BUY_INFO_ID", code);
			rows.add(row);
		}
		return rows;
	}

	public List<Map<String,String>> getSupplyReasonList() {
		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadDao.selectSupplyReasonList();
		return (rows == null) ? new ArrayList<Map<String,String>>() : rows;
	}

	public List<String> getSupplyReasonNames() {
		return names(getSupplyReasonList(), "REASON_NAME");
	}

	public List<Map<String,String>> getTaxTypeList() {
		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadDao.selectTaxTypeList();
		return (rows == null) ? new ArrayList<Map<String,String>>() : rows;
	}

	public List<String> getItemMakeTypeNames() {
		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadDao.selectItemMakeTypeList();
		return names((rows == null) ? new ArrayList<Map<String,String>>() : rows, "TYPE_NAME");
	}

	public List<String> getExistingCatlgCodes(List<String> codes) {
		List<String> result = new ArrayList<String>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<String> part = masterMdCmCmsBuyInfoExcelUploadDao.selectCatlgExists(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	// 조회 결과에서 한 컬럼만 뽑아 중복 없이 순서대로.
	private List<String> names(List<Map<String,String>> rows, String key) {
		List<String> out = new ArrayList<String>();
		for (Map<String,String> row : rows) {
			String v = CommonUtil.nvl(row.get(key)).trim();
			if (v.length() > 0 && !out.contains(v)) { out.add(v); }
		}
		return out;
	}

	public List<Map<String,String>> getWarehouseList() {
		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadDao.selectWarehouseList();
		return (rows == null) ? new ArrayList<Map<String,String>>() : rows;
	}

	// 양식 드롭다운에 쓸 센터명만 뽑는다(저장은 코드라 화면이 이름 -> 코드로 되돌린다).
	public List<String> getWarehouseNames() {
		List<String> names = new ArrayList<String>();
		for (Map<String,String> row : getWarehouseList()) {
			String name = CommonUtil.nvl(row.get("WAREHOUSE_NAME")).trim();
			if (name.length() > 0 && !names.contains(name)) { names.add(name); }
		}
		return names;
	}

	/*
	 * 일괄수정 [확인]. 행마다 UPDATE 한다 - 값이 온 항목만 바뀌고 이력은 함수가 남긴다.
	 * ⚠ 매입단가 인상은 품의 대상이라 화면이 BUY_PRICE_AFTER 를 비워 보낸다. 같은 행의 다른 항목은 그대로 반영된다.
	 */
	public int saveModBulk(String userId, List<Object> gridData) {
		if (gridData == null) { return 0; }

		int saved = 0;
		for (Object obj : gridData) {
			Map<String,String> row = (Map<String,String>) obj;
			if (CommonUtil.nvl(row.get("BUY_INFO_ID")).trim().length() == 0) { continue; }

			/* 바꿀 항목이 하나도 없으면 건너뛴다.
			 * 매입단가 인상만 있던 행은 화면이 그 값을 비워 보내므로 여기서 빈 행이 된다 -
			 * 그대로 UPDATE 하면 최종변경일만 갱신돼 '반영됐다'로 보인다. */
			if (!hasModValue(row)) { continue; }

			Map<String,Object> param = new HashMap<String,Object>();
			param.putAll(row);
			param.put("st_user_id", CommonUtil.nvl(userId));

			saved += masterMdCmCmsBuyInfoExcelUploadDao.updateBuyInfoMod(param);
		}
		return saved;
	}

	// 실제로 바뀌는 값이 하나라도 있는가
	private boolean hasModValue(Map<String,String> row) {
		String[] cols = {"STATUS_AFTER", "BUY_PRICE_AFTER", "BUY_OPEN_DATE_AFTER", "BUY_CLOSE_DATE_AFTER"
		               , "DELIVERY_LT_AFTER", "ITEM_MAKE_TYPE_AFTER", "TAX_TYPE_AFTER", "SELLER_ITEM_NO_AFTER"};
		for (String col : cols) {
			if (CommonUtil.nvl(row.get(col)).trim().length() > 0) { return true; }
		}
		return false;
	}

	/*
	 * 일괄등록 [확인]. 행마다 INSERT 한다 —
	 * CATLG_SEQ 가 상품 안에서 증가하는 값이라 한 상품에 여러 건이 들어올 때 직전 건까지 보여야 한다.
	 */
	public int saveRegBulk(String userId, List<Object> gridData) {
		if (gridData == null) { return 0; }

		int saved = 0;
		for (Object obj : gridData) {
			Map<String,String> row = (Map<String,String>) obj;
			if (CommonUtil.nvl(row.get("CMS_CATLG_ID")).trim().length() == 0) { continue; }

			Map<String,Object> param = new HashMap<String,Object>();
			param.putAll(row);
			param.put("st_user_id", CommonUtil.nvl(userId));

			saved += masterMdCmCmsBuyInfoExcelUploadDao.insertBuyInfo(param);
		}
		return saved;
	}

	// 1000건씩 잘라 조회한 뒤 이어 붙인다.
	private List<Map<String,String>> selectByChunk(List<String> codes, String kind) {
		List<Map<String,String>> result = new ArrayList<Map<String,String>>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));

			List<Map<String,String>> part = null;
			if ("item".equals(kind))       { part = masterMdCmCmsBuyInfoExcelUploadDao.selectItemList(param); }
			else if ("dup".equals(kind))   { part = masterMdCmCmsBuyInfoExcelUploadDao.selectExistingKeyList(param); }
			else if ("agent".equals(kind)) { part = masterMdCmCmsBuyInfoExcelUploadDao.selectAgentList(param); }
			else if ("modBefore".equals(kind)) { part = masterMdCmCmsBuyInfoExcelUploadDao.selectModBeforeList(param); }

			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	// 빈 값 제거 + 중복 제거(입력 순서 유지). 중복 코드가 그대로 오면 IN 절만 커진다.
	private List<String> distinctNonEmpty(List<String> codes) {
		List<String> uniq = new ArrayList<String>();
		Set<String> seen = new HashSet<String>();
		if (codes == null) { return uniq; }
		for (String code : codes) {
			String v = CommonUtil.nvl(code).trim();
			if (v.length() == 0 || seen.contains(v)) { continue; }
			seen.add(v);
			uniq.add(v);
		}
		return uniq;
	}
}
