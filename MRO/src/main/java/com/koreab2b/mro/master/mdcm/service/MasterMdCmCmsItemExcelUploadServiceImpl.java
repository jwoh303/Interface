package com.koreab2b.mro.master.mdcm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemExcelUploadDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterMdCmCmsItemExcelUploadService")
public class MasterMdCmCmsItemExcelUploadServiceImpl implements MasterMdCmCmsItemExcelUploadService {

	@Autowired
	private MasterMdCmCmsItemExcelUploadDao masterMdCmCmsItemExcelUploadDao;

	// 카테고리별 동적 속성 컬럼 정의 조회
	public List<Map<String,String>> getAttrColumns(Map<String,Object> param) {
		// ※ 실 속성 테이블 생기면 아래 한 줄로 교체:
		//    return masterMdCmCmsItemExcelUploadDao.selectAttrColumns(param);
		String categCode = CommonUtil.nvl((String) param.get("st_categ_id"));

		int cnt = resolveAttrCount(categCode);   // stub: 카테고리별 속성 개수
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		for (int i = 1; i <= cnt; i++) {
			Map<String,String> m = new HashMap<String,String>();
			m.put("ATTR_CODE", "ATTR" + i);
			m.put("ATTR_NAME", "속성" + i);
			m.put("SEQ", String.valueOf(i));
			list.add(m);
		}
		return list;
	}

	// stub: 카테고리코드 → 속성 개수 (실테이블 전 임시 규칙. 끝자리 홀수=3, 짝수=2, 미선택=0)
	private int resolveAttrCount(String categCode) {
		if (categCode == null || categCode.length() == 0) {
			return 0;
		}
		char last = categCode.charAt(categCode.length() - 1);
		if (last >= '0' && last <= '9') {
			return 2 + ((last - '0') % 2);
		}
		return 2;
	}

	// 담당(세션 사용자) 카테고리별 속성 조회 (CMS_CATEG_ID + ATTR1~20)
	public List<Map<String,String>> getFormList(Map<String,Object> param) {
		return masterMdCmCmsItemExcelUploadDao.selectFormList(param);
	}

	// Oracle IN 절 상한(1000)에 맞춘 조회 단위
	private static final int IN_CHUNK = 1000;

	// 일괄수정 결과 - 상품정보코드별 [기존] 값. 1000건씩 잘라 조회한 뒤 이어 붙인다.
	public List<Map<String,String>> getBeforeList(List<String> codes) {
		List<Map<String,String>> result = new ArrayList<Map<String,String>>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<Map<String,String>> part = masterMdCmCmsItemExcelUploadDao.selectBeforeList(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	// 일괄수정 결과 - 실재하는 상품정보코드만 걸러 돌려준다(대체코드 미존재 판정용)
	public List<String> getExistingCodes(List<String> codes) {
		List<String> result = new ArrayList<String>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<String> part = masterMdCmCmsItemExcelUploadDao.selectCodeExists(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	// 일괄수정 - 실재하는 제조사코드(ICOMCOD1 M104)만
	public List<String> getExistingMakerCodes(List<String> codes) {
		return selectCodesInChunks(codes, "MAKER");
	}

	// 일괄수정 - 실재하는 원산지코드(ICOMCOD1 M001)만
	public List<String> getExistingOriginCodes(List<String> codes) {
		return selectCodesInChunks(codes, "ORIGIN");
	}

	// 일괄수정 - 제조사 변경코드의 명칭(ICOMCOD1 M104). 결과 그리드 [변경] 열 표시용
	public List<Map<String,String>> getMakerNames(List<String> codes) {
		List<Map<String,String>> result = new ArrayList<Map<String,String>>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<Map<String,String>> part = masterMdCmCmsItemExcelUploadDao.selectMakerNames(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	// 코드 실재 조회 공통 - 1000건씩 잘라 부른다
	private List<String> selectCodesInChunks(List<String> codes, String kind) {
		List<String> result = new ArrayList<String>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<String> part = "MAKER".equals(kind)
					? masterMdCmCmsItemExcelUploadDao.selectMakerExists(param)
					: masterMdCmCmsItemExcelUploadDao.selectOriginExists(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	/*
	 * 일괄수정 양식 다운로드 - 선택한 코드 순서대로 양식 1행씩.
	 * 조회 결과를 코드로 인덱싱한 뒤 입력 순서로 다시 늘어놓는다(IN 절은 순서를 보장하지 않는다).
	 * 없는 코드는 상품정보코드만 채운 빈 행으로 남긴다 — 담당자가 양식에서 바로 알아볼 수 있게.
	 * ⚠ CMSCATTR 에 같은 상세분류가 2행이면 조인이 행을 불린다 → 코드 기준 Map 으로 흡수한다.
	 */
	public List<Map<String,String>> getModFormRows(List<String> codes) {
		List<String> uniq = distinctNonEmpty(codes);
		Map<String,Map<String,String>> byCode = new HashMap<String,Map<String,String>>();
		for (Map<String,String> row : getBeforeList(uniq)) {
			String id = CommonUtil.nvl(row.get("CMS_CATLG_ID")).trim();
			if (id.length() > 0 && !byCode.containsKey(id)) { byCode.put(id, row); }
		}

		List<Map<String,String>> rows = new ArrayList<Map<String,String>>();
		for (String code : uniq) {
			Map<String,String> src = byCode.get(code);
			Map<String,String> row = new HashMap<String,String>();
			if (src != null) { row.putAll(src); }
			row.put("CMS_CATLG_ID", code);

			// 속성값 열에는 현재 값을 채워 내려보낸다(담당자가 고칠 자리). 조회 별칭은 *_BVAL 이다.
			for (int i = 1; i <= ATTR_COUNT; i++) {
				row.put("ATTR" + i + "_VAL", CommonUtil.nvl(row.get("ATTR" + i + "_BVAL")));
			}
			rows.add(row);
		}
		return rows;
	}

	// 상품상태 변경사유 - 미사용 방향(OUT), [1] 사용 방향(IN). 양식 Sheet1 두 열이 된다.
	public List<List<String>> getStatusReasonLists() {
		List<String> out = new ArrayList<String>();
		List<String> in  = new ArrayList<String>();
		List<Map<String,String>> rows = masterMdCmCmsItemExcelUploadDao.selectReasonList();
		if (rows != null) {
			for (Map<String,String> row : rows) {
				String dir  = CommonUtil.nvl(row.get("DIR"));
				String name = CommonUtil.nvl(row.get("REASON_NAME"));
				if (name.length() == 0) { continue; }
				if ("OUT".equals(dir))     { out.add(name); }
				else if ("IN".equals(dir)) { in.add(name); }
			}
		}
		List<List<String>> result = new ArrayList<List<String>>();
		result.add(out);
		result.add(in);
		return result;
	}

	// 양식 드롭다운용 TR취급가능여부 명칭 목록. 코드가 없으면 빈 목록 - 그러면 드롭다운을 걸지 않는다
	public List<String> getTrHandleNames() {
		List<String> names = new ArrayList<String>();
		List<Map<String,String>> rows = masterMdCmCmsItemExcelUploadDao.selectTrHandleList();
		if (rows != null) {
			for (Map<String,String> row : rows) {
				String name = CommonUtil.nvl(row.get("TEXT1"));
				if (name.length() > 0) { names.add(name); }
			}
		}
		return names;
	}

	// 양식이 담는 속성 쌍 개수. cmsItemModForm.js 의 MDCM_MOD_ATTR_COUNT 와 같아야 한다.
	public static final int ATTR_COUNT = 13;

	/*
	 * 기준가 일괄수정 결과 - 상품정보코드별 [기존] 기준가 값. 1000건씩 잘라 조회한 뒤 이어 붙인다.
	 * ★ 기준가는 상품정보코드 단위다 — 구매정보코드는 보지 않는다.
	 */
	public List<Map<String,String>> getBasePriceBeforeList(List<String> codes) {
		List<Map<String,String>> result = new ArrayList<Map<String,String>>();
		List<String> uniq = distinctNonEmpty(codes);
		for (int from = 0; from < uniq.size(); from += IN_CHUNK) {
			int to = Math.min(from + IN_CHUNK, uniq.size());
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("codeList", uniq.subList(from, to));
			List<Map<String,String>> part = masterMdCmCmsItemExcelUploadDao.selectBasePriceBeforeList(param);
			if (part != null) { result.addAll(part); }
		}
		return result;
	}

	/*
	 * 기준가 일괄수정 양식 다운로드 - 선택한 코드 순서대로 양식 1행씩.
	 * 조회 결과를 코드로 인덱싱한 뒤 입력 순서로 다시 늘어놓는다(IN 절은 순서를 보장하지 않는다).
	 * 없는 코드는 상품정보코드만 채운 빈 행으로 남긴다 - 담당자가 양식에서 바로 알아볼 수 있게.
	 */
	public List<Map<String,String>> getBasePriceFormRows(List<String> codes) {
		List<String> uniq = distinctNonEmpty(codes);
		Map<String,Map<String,String>> byCode = new HashMap<String,Map<String,String>>();
		for (Map<String,String> row : getBasePriceBeforeList(uniq)) {
			String id = CommonUtil.nvl(row.get("CMS_CATLG_ID")).trim();
			if (id.length() > 0 && !byCode.containsKey(id)) { byCode.put(id, row); }
		}

		List<Map<String,String>> rows = new ArrayList<Map<String,String>>();
		for (String code : uniq) {
			Map<String,String> src = byCode.get(code);
			Map<String,String> row = new HashMap<String,String>();
			if (src != null) { row.putAll(src); }
			row.put("CMS_CATLG_ID", code);
			rows.add(row);
		}
		return rows;
	}

	// 기준가유형 명칭 목록(ICOMCOD1 M183). 양식 드롭다운 원본이자 업로드 값 검증 기준이다.
	public List<String> getBasePriceTypeNames() {
		List<String> names = new ArrayList<String>();
		List<Map<String,String>> rows = masterMdCmCmsItemExcelUploadDao.selectBasePriceTypeList();
		if (rows != null) {
			for (Map<String,String> row : rows) {
				String name = CommonUtil.nvl(row.get("TYPE_NAME"));
				if (name.length() > 0) { names.add(name); }
			}
		}
		return names;
	}

	// 빈 값 제거 + 중복 제거(입력 순서 유지). 중복 코드가 그대로 오면 IN 절만 커진다.
	private List<String> distinctNonEmpty(List<String> codes) {
		List<String> uniq = new ArrayList<String>();
		if (codes == null) { return uniq; }
		Set<String> seen = new HashSet<String>();
		for (String code : codes) {
			String v = CommonUtil.nvl(code).trim();
			if (v.length() == 0) { continue; }
			if (seen.add(v)) { uniq.add(v); }
		}
		return uniq;
	}

	// 조회된 행들에서 사용된 속성(ATTR1~20)의 최대 개수 — 동적 속성 컬럼 개수
	public int getMaxAttrCount(List<Map<String,String>> rows) {
		int max = 0;
		if (rows == null) {
			return 0;
		}
		for (Map<String,String> row : rows) {
			for (int i = 20; i > max; i--) {
				if (CommonUtil.nvl(row.get("ATTR" + i)).length() > 0) {
					max = i;
					break;
				}
			}
		}
		return max;
	}
}
