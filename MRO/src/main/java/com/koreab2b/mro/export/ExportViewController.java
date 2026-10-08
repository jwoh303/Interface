package com.koreab2b.mro.export;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("exportViewController")
public class ExportViewController {

	// 패킹업체 입고등록
	@RequestMapping(value = "/exiv/showExportExIvObtnodrReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExIvObtnodrReceipt() {
		return "export/exiv/exportExIvObtnodrMultiReceiptList";
	}

	// CI, PL 등록 대상조회
	@RequestMapping(value = "/exiv/showExportExIvCIReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExIvCIReceipt() {
		return "export/exiv/exportExIvCIReceipt";
	}
	
	// CI, PL 등록
	@RequestMapping(value = "/exiv/showExportExIvCIReceiptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiReleaseTransPop() {
		return "export/exiv/exportExIvCIReceiptPop";
	}
	
	// BL 등록
	@RequestMapping(value = "/exiv/showExportExIvBlReceipt.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExIvBlReceipt() {
		return "export/exiv/exportExIvBlReceipt";
	}
	
	// LOT 등록
	@RequestMapping(value = "/exiv/showExportExIvCiLotRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExIvCiLotRegPop() {
		return "export/exiv/exportExIvCiLotRegPop";
	}
	
	//ICOMCOD2 기준 팝업.
	@RequestMapping(value = "/exiv/exportExIvIcomCodPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExIvIcomCodPop() {
		return "export/exiv/exportExIvIcomCodPop";
	}
	
	// B/L 등록 대상조회
	@RequestMapping(value = "/exbl/showExportExBlProcList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExBlProcList() {
		return "export/exbl/exporExBlProcList";
	}
	
	// B/L 등록
	@RequestMapping(value = "/exbl/showExportExBlBlReceiptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExBlBlReceiptPop() {
		return "export/exbl/exportExBlBlReceiptPop";
	}
	
	// 외자납품 관리
	@RequestMapping(value = "/exol/showExportExOlExportProgress.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExOlExportProgress() {
		return "export/exol/exportExOlExportProgress";
	}
	
	// 외자납품 관리(PO기준)
	@RequestMapping(value = "/exol/showExportExOlExportProgressPo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExOlExportProgressPo() {
		return "export/exol/exportExOlExportProgressPo";
	}
	
	// LOT 상세정보 팝업
	@RequestMapping(value = "/exol/showExportExOlExportProgressLotPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showExportExOlExportProgressLotPop() {
		return "export/exol/exportExOlExportProgressLotPop";
	}
}
