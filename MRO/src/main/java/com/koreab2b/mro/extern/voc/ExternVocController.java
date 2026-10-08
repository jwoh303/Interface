package com.koreab2b.mro.extern.voc;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.extern.voc.service.ExternVocService;
import com.samsung.bqms.common.util.CCrypt;

@Controller("externVocController")
public class ExternVocController {
	
	@Autowired
	private ExternVocService externVocService;

	@RequestMapping(value = "/extern/getExternVocList.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String getExternVocList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		String referer	= req.getHeader("REFERER");
		
		List<Map<String, String>> keywordList = externVocService.getDomainKeywordList();
		boolean bRef	= false;
		
		if (keywordList.size() > 0) {
			for( Map<String, String> iMap : keywordList) {
				if (referer.indexOf(iMap.get("KEY_WORD")) > -1 ) {
					bRef	= true;
					break;
				}
			}	
		} else {
			bRef	= true;
		}
		
		String email	= pMap.get("st_user_email");
		
		if (email.indexOf("@") < 0) {
			try {
				String desStr	= CCrypt.decrypt(email);
				pMap.put("st_user_email", desStr);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		
		if ( !bRef ) {
			return "common/error/error";
		}
		
		String _page_no = pMap.get("curPage");
		if (_page_no == null) {
			pMap.put("st_st_no", "1");
			pMap.put("st_ed_no", "10");
			_page_no	=	"1";
		} else {
			int page_no	=	Integer.parseInt(_page_no);
			int page_size	= 10;
			
			int st_no	=	(page_no - 1) * page_size + 1;
			int ed_no	=	page_no * page_size;
			
			pMap.put("st_st_no", Integer.toString(st_no));
			pMap.put("st_ed_no", Integer.toString(ed_no));
		}
		
		List<Map<String,String>> _vocList = externVocService.getExternVocList(pMap);
		int _listCnt	= externVocService.getExternVocCount(pMap);
		pModel.addAttribute("vocList", _vocList);
		pModel.addAttribute("listCnt", _listCnt);
		pModel.addAttribute("page_no", _page_no);
		
		return "extern/voc/externVocList";
	}
	
	@RequestMapping(value = "/extern/getExternVocWrite.do", method = {RequestMethod.POST})
	public String getExternVocWrite(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		String referer	= req.getHeader("REFERER");
		
		List<Map<String, String>> keywordList = externVocService.getDomainKeywordList();
		boolean bRef	= false;
		
		if (keywordList.size() > 0) {
			for( Map<String, String> iMap : keywordList) {
				if (referer.indexOf(iMap.get("KEY_WORD")) > -1 ) {
					bRef	= true;
					break;
				}
			}	
		} else {
			bRef	= true;
		}

		String email	= pMap.get("st_user_email");
		
		if (email.indexOf("@") < 0) {
			try {
				String desStr	= CCrypt.decrypt(email);
				pMap.put("st_user_email", desStr);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}

		if ( !bRef ) {
			return "common/error/error";
		}
		
		return "extern/voc/externVocWrite";
	}
	
	@RequestMapping(value = "/extern/saveExternVocWrite.do", method = { RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> saveExternVocWrite(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String id = req.getParameter("ID");
		String referer	= req.getHeader("REFERER");

		List<Map<String, String>> keywordList = externVocService.getDomainKeywordList();
		boolean bRef	= false;
		
		if (keywordList.size() > 0) {
			for( Map<String, String> iMap : keywordList) {
				if (referer.indexOf(iMap.get("KEY_WORD")) > -1 ) {
					bRef	= true;
					break;
				}
			}	
		} else {
			bRef	= true;
		}

		String email	= pMap.get("st_user_email");
		
		if (email.indexOf("@") < 0) {
			try {
				String desStr	= CCrypt.decrypt(email);
				pMap.put("st_user_email", desStr);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}

		if ( !bRef ) {
			_response.put("msg", "Err");
			return _response;
		}
		
		String rtn = externVocService.saveExternVoc(pMap);
		
		_response.put("msg", rtn);
		
		return _response;
	}
	@RequestMapping(value = "/extern/reportInsolventMaterialsPop.do", method = {RequestMethod.POST, RequestMethod.GET})
	public String reportInsolventMaterialsPop(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		String referer	= req.getHeader("REFERER");
		List<Map<String, String>> keywordList = externVocService.getDomainKeywordList();
		boolean bRef	= false;
		if (keywordList.size() > 0) {
			for( Map<String, String> iMap : keywordList) {
				if(referer != null) {
					if (referer.indexOf(iMap.get("KEY_WORD")) > -1 ) {
						bRef	= true;
						break;
					}					
				}else {
					bRef	= true;
				}
			}	
		} else {
			bRef	= true;
		}
		String email	= pMap.get("st_user_email");

		if (email.indexOf("@") < 0) {
			try {
				String desStr	= CCrypt.decrypt(email);
				pMap.put("st_user_email", desStr);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}

		if ( !bRef ) {
			return "common/error/error";
		}
		
		return "extern/voc/reportInsolventMaterialsPop";
	}
}
