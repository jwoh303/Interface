//WMS TR 출력물 리포트 디자이너 Sheet
function setWmsTrSheet(sgid, carid, user_dept, warehouse_code, buyer, ik_no, user_id, legacy_po, legacy_po_seq, legacy_iv_serial, process_type_text, iv_no) {

	var seller = "KRKORE0001";
	var legacy_flag = legacy_po.substring(0, 2);
	var dhim_legacy_po_no = legacy_po.substring(0, 1);
	/**
	 * if(!doc_type){ doc_type = document.forms[0].st_doc_type.value; }
	 */
	var url = "/coco/showReportViewer.do";

	if (sgid == "P08-0000011-01") { // 두산중공업의 경우.

		// 리포트 디자이너 Sheet Open
		if (legacy_flag == 'PR' || legacy_flag == '') {
			reportTrOpen("RD_08_M_006_55","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			
/*			window.open(url + "" + "?fileName=RD_08_M_006_55&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=200");*/

		} else {
			reportTrOpen("RD_08_M_006_32","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_08_M_006_56","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			
/*			window.open(url + "" + "?fileName=RD_08_M_006_32&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");
			window.open(url + "" + "?fileName=RD_08_M_006_56&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=200");*/

		}
	} else if (sgid == "P08-0000011-02") { // 대우조선의 경우
		// 리포트 디자이너 Sheet Open
		if (legacy_flag == 'PR' || legacy_flag == '') {
			reportTrOpen("RD_08_M_006_55","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			
/*			window.open(url + "" + "?fileName=RD_08_M_006_55&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=200");*/

		} else {
			reportTrOpen("RD_08_M_006_48","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_08_M_006_47","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*			window.open(url + "" + "?fileName=RD_08_M_006_48&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=1090,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_08_M_006_47&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=1090,height=800,resizable=YES,top=0,left=200");*/

		}

	} else if (sgid == "P08-0000011-03") { // 덕흥공업의 경우
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_50","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_49","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_50&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_49&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == 'P08-0000011-04') { // FAG KOREA의 경우
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_35","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_34","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_35&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_34&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/
		
		if(dhim_legacy_po_no == "8"){ // 셰플러 LEGACY_PO_NO 8로 시작하면 태그 출력 - 20170612 HSJ
			reportTrOpen("RD_06_X_002_15","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*			window.open(url + "" + "?fileName=RD_06_X_002_15&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
			"width=770,height=800,resizable=YES,top=0,left=200");*/
		}

	} else if (sgid == "P08-0000011-05") {
		reportTrOpen("RD_08_M_006_61","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_33","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_61&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_33&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == "P08-0000011-06") { // 20140611 장민기 두산건설(주)_HRSG() 추가
		reportTrOpen("RD_08_M_006_30","[" + buyer + "][" + seller + "][" + ik_no + "]");
		reportTrOpen("RD_08_M_006_31","[" + buyer + "][" + seller + "][" + ik_no + "]");
		reportTrOpen("RD_08_M_006_29","[" + buyer + "][" + seller + "][" + ik_no + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_30&param=[" + buyer + "][" + seller + "][" + ik_no + "]", "",
				"width=1090,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_31&param=[" + buyer + "][" + seller + "][" + ik_no + "]", "",
				"width=1090,height=800,resizable=YES,top=0,left=50");

		window.open(url + "" + "?fileName=RD_08_M_006_29&param=[" + buyer + "][" + seller + "][" + ik_no + "]", "",
				"width=1090,height=800,resizable=YES,top=0,left=100");*/

	} else if (sgid == "P08-0000011-07") {
		reportTrOpen("RD_08_M_006_42","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_42&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

	} else if (sgid == "P08-0000011-08") { // 하이트맥주 마산
		reportTrOpen("RD_08_M_006_37","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_36","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_37&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_08_M_006_36&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == "P08-0000011-09") { // 구미 물류센터 코오롱 관련
		reportTrOpen("RD_08_M_006_46","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_45","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_46&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_45&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if ((sgid == "P08-0000011-10" || sgid == "P08-0000011-12" || sgid == "P08-0000011-11")
			&& (dhim_legacy_po_no == "5" || dhim_legacy_po_no == "4" || dhim_legacy_po_no == "A")) {

		var agent = warehouse_code;
		var agent_name = "";
		var sap_user = "20493";
		var sap_password = "20493";

		var loc = "http://doowin.doosaninfracore.com/keplogin.do?";
		window.open(loc += '&agent=' + agent + '&agent_name=' + agent_name + '&po_no=' + legacy_po + '&po_seq=' + legacy_po_seq + '&portal_user_id='
				+ sap_user + '&portal_password=' + sap_password, "newW", "left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");

		reportTrOpen("RD_08_M_006_55","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_55&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/		
/*		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// top.window.close();

	} else if ((sgid == "P08-0000011-10" || ((sgid == "P08-0000011-11" || sgid == "P08-0000011-13"))) && TrimCommon(legacy_flag) == "20") {
		var agent = warehouse_code;
		var agent_name = "";
		window.open("http://ez-van.doosaninfracore.co.kr/dhivan2/kep/index.asp?kepvndno=" + agent, "sheetWin_dae_1",
				"width=1015,height=700,resizable=YES,top=0,left=0");

	} else if (sgid == "P08-0000011-14") {
		reportTrOpen("RD_08_M_006_53","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		var win = window.open(url + "" + "?fileName=RD_08_M_006_53&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

		/* 20140424 장민기 요청번호 : 4 에스엔티중공업 기계공장 거래명세서 내용수정및 바코드 추가 후 분할 작업시작 */
	} else if (sgid == "P08-0000011-15") {
		reportTrOpen("RD_08_M_006_62","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_62&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

		/* 20140424 장민기 작업끝 */
	} else if (sgid == "P08-0000011-16") {
		reportTrOpen("RD_08_M_006_41","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_41&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

	} else if (sgid == "P08-0000011-17") {
		if(legacy_iv_serial == ''){
			alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}else{
			reportTrOpen("RD_06_S_001_131","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_06_S_001_132","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*			window.open(url + "" + "?fileName=RD_06_S_001_131&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "_1",
			"width=770,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_06_S_001_132&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "_2",
			"width=770,height=800,resizable=YES,top=0,left=200");*/			
		}
	} else if (sgid == "P08-0000011-18-1" || sgid == "P08-0000011-18-2") { // 대한제강의
																			// 경우

		if (sgid == "P08-0000011-18-2") { // 대한제강 물류센터 대한제강 녹산 물류센터
			window.open(url + "" + "?fileName=RD_08_M_006_02&param=[" + buyer + "][" + ik_no + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_08_M_006_00&param=[" + buyer + "][" + ik_no + "]", "setWmsTrSheetMRD12",
					"width=770,height=800,resizable=YES,top=0,left=200");

		} else {
			window.open(url + "" + "?fileName=RD_08_M_006_03&param=[" + buyer + "][" + ik_no + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");

			window.open(url + "" + "?fileName=RD_08_M_006_01&param=[" + buyer + "][" + ik_no + "]", "1",
					"width=770,height=800,resizable=YES,top=0,left=200");

		}
		reportTrOpen("RD_08_M_006_40","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po+ "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_40&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "VarCode", "width=100,height=100,resizable=YES,top=0,left=0");*/

	} else if (sgid == "P08-0000011-19") { // 한화 거래명세서
		reportTrOpen("RD_08_M_006_11","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_10","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_11&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_10&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == "P08-0000011-20") { // KEP_건설_두산메카텍
		reportTrOpen("RD_08_M_006_19","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_19&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

	} else if (sgid == "P08-0000011-21") {
		reportTrOpen("RD_08_M_006_28","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_28&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// 두산인프라코어
	} else if (sgid == "P08-0000011-22" || sgid == "P08-0000011-46") {

		if (sgid == "P08-0000011-46" && TrimCommon(legacy_flag) == "20") {

			var agent = warehouse_code;
			var agent_name = "";
			window.open("http://ez-van.doosaninfracore.co.kr/dhivan2/kep/index.asp?kepvndno=" + agent, "sheetWin_dae_1",
					"width=1015,height=700,resizable=YES,top=0,left=0");
		} else {
			reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			reportTrOpen("RD_08_M_006_08","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
			
/*			window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=200");
			window.open(url + "" + "?fileName=RD_08_M_006_08&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");*/

		}

		// (주)화승네트웍스
	} else if (sgid == "P08-0000011-23") {

		if (buyer == "KRHWAS0031") {

			if (user_dept == "00007" || user_dept == "00002") {
				reportTrOpen("RD_08_M_006_15","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*				window.open(url + "" + "?fileName=RD_08_M_006_15&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
						"width=770,height=800,resizable=YES,top=0,left=0");*/

			} else if (user_dept == "00012") {
				reportTrOpen("RD_08_M_006_16","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*				window.open(url + "" + "?fileName=RD_08_M_006_16&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
						"width=770,height=800,resizable=YES,top=0,left=0");*/

			} else {
				reportTrOpen("RD_08_M_006_14","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*				window.open(url + "" + "?fileName=RD_08_M_006_14&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
						"width=770,height=800,resizable=YES,top=0,left=0");*/

			}

		} else {
			reportTrOpen("RD_08_M_006_14","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*			window.open(url + "" + "?fileName=RD_08_M_006_14&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
					"width=770,height=800,resizable=YES,top=0,left=0");*/

		}
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "_2",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// 하이트맥주(주) + (주)진로
	} else if (sgid == "P08-0000011-24") {
		reportTrOpen("RD_08_M_006_12","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_12&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// 한국미쓰비시엘리베이터(주)
	} else if (sgid == "P08-0000011-25") {
		reportTrOpen("RD_08_M_006_21","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_21&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// 교보리얼코
	} else if (sgid == "P08-0000011-26") {
		reportTrOpen("RD_08_M_006_20","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_20&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/

		// 현대비앤지스틸 주식회사
	} else if (sgid == "P08-0000011-27") {
		reportTrOpen("RD_08_M_006_04","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_04&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

		// 한화케미칼(주) 여수
	} else if (sgid == "P08-0000011-28") {
		reportTrOpen("RD_08_M_006_09","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_09&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/
		// 두산엔진(주)
	} else if (sgid == "P08-0000011-29") {
		reportTrOpen("RD_08_M_006_07","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_07&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// 동일고무벨트
	} else if (sgid == "P08-0000011-30") {
		reportTrOpen("RD_08_M_006_06","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_06&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// 한국델파이(주)
	} else if (sgid == "P08-0000011-31") {
		reportTrOpen("RD_08_M_006_05","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_05&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// (주)효성
	} else if (sgid == "P08-0000011-32") {
		reportTrOpen("RD_08_M_006_17","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_57","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_17&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_08_M_006_57&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=200");*/

		/**
		 * KEPPROJECT
		 * 
		 * @author 최진수
		 * @programid CJS00008 start
		 * @remark 효성 세종 공장(KRHYOS0043) 추가
		 * @date 2014-06-24
		 */
		// (주)효성(SAP)
	} else if (sgid == "P08-0000011-33") {
		// 김민성 대리 요청으로 거래명세서와 태그를 분리함.
		reportTrOpen("RD_08_M_006_18","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		//reportTrOpen("RD_08_M_006_58","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_40","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		
		// 재고 일때 물류센터에서 출고지시에 고객사 전용 품목태그 출력
		if(process_type_text == "재고"){
			reportTrOpen("RD_06_S_001_78","[" + iv_no + "][" + seller + "][" + buyer + "]");	
		}
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_18&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_08_M_006_58&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "setWmsTrSheetTagMRD", "width=770,height=800,resizable=YES,top=50,left=50");
		window.open(url + "" + "?fileName=RD_08_M_006_40&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=100,left=100");*/
		/* @programid CJS00008 end */
		// 성동조선해양(주) 김상근 1021 seller 추가
	} else if (sgid == "P08-0000011-34") {
		reportTrOpen("RD_08_M_006_25","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_59","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_25&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_59&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=200");*/
		// 쌍용자동차(주)
	} else if (sgid == "P08-0000011-35") {
		reportTrOpen("RD_08_M_006_23","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_23&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// 유한 - 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 제외 2017.05.08 by HSJ
	} else if (sgid == "P08-0000011-36") {
		reportTrOpen("RD_08_M_006_22","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_22&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// 쌍용자동차 (주) 창원공장
	} else if (sgid == "P08-0000011-37") {
		reportTrOpen("RD_08_M_006_64","[" + warehouse_code + "][" + buyer + "][" + seller + "][" + ik_no + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_65","[" + warehouse_code + "][" + buyer + "][" + seller + "][" + ik_no + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_64&param=[" + warehouse_code + "][" + buyer + "][" + seller + "][" + ik_no + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_65&param=[" + warehouse_code + "][" + buyer + "][" + seller + "][" + ik_no + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=200");*/

		// 한화케미칼(주) 울산1,울산2,울산3
	} else if (sgid == "P08-0000011-38") {
		reportTrOpen("RD_06_S_001_106","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_106&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/

		// STX 조선해양
	} else if (sgid == "P08-0000011-39") {
		if (legacy_iv_serial == '') {
			alert("STX 시스템에 등록중입니다.");
			return;
		}

		window.open("http://scmerp.stxons.com/pcm/scm/0403/pcmScm0403sd_rpt.do?type=sd04&bill_id=" + legacy_iv_serial, "sheetWin2",
				"width=700,height=700,resizable=YES,top=50,left=50");
		window.open("http://scmerp.stxons.com/pcm/scm/0403/pcmScm0403sd_rpt.do?type=sd05&bill_id=" + legacy_iv_serial, "sheetWin3",
				"width=700,height=700,resizable=YES,top=100,left=100");

		// STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)
	} else if ((sgid == "P08-0000011-40")) {
		if (legacy_iv_serial == '') {
			alert("STX 시스템에 등록중입니다.");
			return;
		}
		// OZ Viewer 가 같은 창에만 열려서 이를 해결하기 위해 팝업처리함.
		var urlstx = "/wmgi/showMasterWmGiDaehanBarcodeReportPop.do";
		
		window.open(urlstx + "" + "?st_buyer=" + buyer + "&st_legacy_iv_serial=" + legacy_iv_serial, "sheetWin",
				"width=400,height=150,resizable=YES,top=0,left=0");

	} else if (sgid == "P08-0000011-41") { // 화천기공 김상근 1021 seller 추가
		reportTrOpen("RD_08_M_006_13","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_13&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/

		// 김상근 추가부분 1017 -- 시작
	} else if (sgid == 'P08-0000011-42') { // SM00035 20140903 KRFAGB0001분리 장민기
											// SR14008727 - P08-0000011-04에서 변경됨
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_74","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_75","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_74&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_75&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");*/
		
		if(dhim_legacy_po_no == "8"){ // 셰플러 LEGACY_PO_NO 8로 시작하면 태그 출력 - 20170612 HSJ
			reportTrOpen("RD_06_X_002_15","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*			window.open(url + "" + "?fileName=RD_06_X_002_15&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
			"width=770,height=800,resizable=YES,top=0,left=200");*/
		}

	} else if (sgid == 'P08-0000011-43') { // SM00033 유도스타 주식회사 20140820 장민기
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_76","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_77","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_76&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_08_M_006_77&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == 'P08-0000011-44') { // SM00033 유도썬셋 주식회사 20140820 장민기
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_78","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_08_M_006_79","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		
/*		window.open(url + "" + "?fileName=RD_08_M_006_78&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");

		window.open(url + "" + "?fileName=RD_08_M_006_79&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == 'P08-0000011-45') { // 20140724 장민기 한국제지 SR14007548 요청자
											// : 최효영대리
		reportTrOpen("RD_06_S_001_162","[" + ik_no + "][" + seller + "][" + buyer + "][" + legacy_po + "][" + user_id + "]");
		reportTrOpen("RD_06_S_001_53","[" + ik_no + "][" + seller + "][" + buyer + "][" + legacy_po + "][" + user_id + "]");
		
/*		window.open(url + "" + "?fileName=RD_06_S_001_51&param=[" + ik_no + "][" + seller + "][" + buyer + "][" + legacy_po + "][" + user_id + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_S_001_53&param=[" + ik_no + "][" + seller + "][" + buyer + "][" + legacy_po + "][" + user_id + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=200");*/

	} else if (sgid == "P08-0000011-47") { // 코오롱 SAP

		if (legacy_iv_serial == '') {
			alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}
		reportTrOpen("RD_06_T_003_01","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_T_003_01&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/
		
	} else if (sgid == "P08-0000011-48") { // 삼남석유회사
		reportTrOpen("RD_06_S_001_100","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_100&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/
	} else if (sgid == "P08-0000011-49") { // 삼남석유회사 제외한 삼양계열사(ICOMCOD2, TYPE='PLNT')
		reportTrOpen("RD_06_S_001_103","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_103&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=1015,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-50") { // 20151126 한승준 - 한화호텔앤드리조트 요청자 : 김연희 사원
		reportTrOpen("RD_06_S_001_102","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_102&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-51") { // 창성KRCHAN0076, KRCHAN0078,KRCHAN0079
		reportTrOpen("RD_06_S_001_108","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_108&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-52") { // 20160128 한승준 - 셀트리온 KRCELL0004 요청자 : 이지윤
		reportTrOpen("RD_06_S_001_109","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_109&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-53") { // 20160128 한승준 - 빙그레 KRBING0002, KRBING0003, KRBING0004, KRBING0005 요청자 : 김상훈, 일동제약 KRILDO0005 요청자 : 강대로, 20180404 유도썬스 KRYOUN0301 요청자 : 김상훈, 20180410 바이오토피아 KRBIOT0004 요청자 : 한영민
		reportTrOpen("RD_06_S_001_110","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_110&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-54") { // 20160429 현명환 광동 제약 KRKWAB0001
		reportTrOpen("RD_06_S_001_111","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_111&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-55") { // 20160518 한승준 효성사무용품(사업장) KRHYOS0051 요청자 : 신숙희
		reportTrOpen("RD_08_M_006_80","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_81","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_80&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
			"width=770,height=800,resizable=YES,top=0,left=200");
		window.open(url + "" + "?fileName=RD_08_M_006_81&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
			"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-56") { // 품목코드 있는 표준 코아비스(KRCOAV0001) 요청자 안병환/티씨테크, 20171124 한승준 셀트리온제약(KRCELL0008,KRCELL0009,KRCELL0010) - 정윤석CJ
		reportTrOpen("RD_06_S_001_110","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_110&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-58") { // 일진제강 수원, 전주 (KRILJI0055, KRILJI0056) 요청자 한다연
		reportTrOpen("RD_06_S_001_113","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_113&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-59") { // 윈체 (KRWINC0001, KRWINC0002, KRWINC0003) 요청자 박경혁GJ
		reportTrOpen("RD_06_S_001_122","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_122&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-60") { // (신)유도썬스 (KRYUDO0006) 요청자 김상훈CJ
		reportTrOpen("RD_06_S_003_44","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
		reportTrOpen("RD_06_S_003_45","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_003_44&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_S_003_45&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "][" + legacy_po
				+ "]", "", "width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-61") { // 에스원(KRS-1-0001) 요청자 김초롱SW
		reportTrOpen("RD_06_S_001_139","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_139&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-62") { //  삼성전자(KRSAMS0123), 삼성전자서비스(KRSAMS0192)
		reportTrOpen("RD_06_S_001_117","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_117&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-63") { //  대덕전자(KRDAED0079)
		reportTrOpen("RD_06_S_001_118","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_118&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-64") { //  미스미(KRMISU0014)
		reportTrOpen("RD_06_S_001_119","[" + ik_no + "][" + seller + "][" + buyer + "]");
		reportTrOpen("RD_06_X_002_79","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_119&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_X_002_79&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-65") { // 유한킴벌리 김천공장(KRYUHA0013), 김천공장_사무(KRYUHA0016) 요청자 박형근GJ 2017.05.08 by HSJ
		reportTrOpen("RD_06_S_001_120","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_120&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-66") { // 케이오씨전기(KRKOC-0001), 요청자 김민성 과장 2017.05.24 by HSJ
		reportTrOpen("RD_06_S_001_121","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_121&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-67") { //  삼성전기(KRSAMS0140), 요청자 심재운GJ 2017.06.01 by HSJ
		reportTrOpen("RD_06_S_001_123","[" + ik_no + "][" + seller + "][" + buyer + "]");
		reportTrOpen("RD_06_X_002_14","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_123&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_X_002_14&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-68") { // 롯데푸드 11개 고객사 2017.07.13 by HSJ
										/* 2024.07.19  롯데웰푸드 19개 고객사(KRLOTT0084,KRLOTT0085,KRLOTT0086,KRLOTT0087,KRLOTT0088,KRLOTT0089,KRLOTT0090,KRLOTT0091,KRLOTT0092,KRLOTT0093,
										KRLOTT0094,KRLOTT0095,KRLOTT0096,KRLOTT0097,KRLOTT0098,KRLOTT0099,KRLOTT0100,KRLOTT0101,KRLOTT0102) */
		reportTrOpen("RD_06_S_001_124","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_124&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-69") { // 위닉스(KRWINI0003) 2017.07.21 by HSJ
		reportTrOpen("RD_06_S_001_89","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_89&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-70") { // 미래페이퍼(KRMIRA0089) 2017.09.22 by HSJ
		reportTrOpen("RD_06_S_001_126","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_126&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-71") { // 일진머티리얼즈(KRILJI0006) 2017.10.12 by HSJ
		reportTrOpen("RD_06_S_001_127","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_127&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-72") { // 이케아(KRIKEA0001) 2017.10.24 by HSJ
		reportTrOpen("RD_06_S_001_128","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_128&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-73") { //  BQMS 미사용 오프라인 삼성전자(KRSAMS0149)
		reportTrOpen("RD_06_S_001_130","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_130&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-74") { //  일진전기_펀치아웃 대체용(KRILJI0066, KRILJI0067)
		reportTrOpen("RD_08_M_006_82","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_82&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-75") { // 롯데알미늄 8개 고객사(KRLOTT0030~KRLOTT0037)
		reportTrOpen("RD_06_S_001_133","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_133&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-76") { // 전략영업팀 전 고객사 중 삼성전자, 삼성전기, 대덕전자, 에스원 제외한 고객사
		reportTrOpen("RD_06_S_001_138","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_138&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-77") { // 품목별비고 기본 거래명세서 2018.10.05 by HSJ
		reportTrOpen("RD_06_S_001_200","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_200&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-78") { // 크린팩토메이션(KRCLEA0041) 거래명세서 & 현품표, 요청자 정윤석 2019.06.25 by HSJ
		reportTrOpen("RD_06_S_001_140","[" + ik_no + "][" + seller + "][" + buyer + "]");
		reportTrOpen("RD_06_S_001_141","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_140&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_S_001_141&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-79") { // 삼성에스디에스(KRSAMS0167)
		reportTrOpen("RD_06_S_001_143","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_143&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-80") { // 화천기계(KRHWAC0016) 화천보관용 & 공급사보관용, 요청자 최진수 2019.09.27 by HSJ
		reportTrOpen("RD_06_S_001_144","[" + ik_no + "][" + seller + "][" + buyer + "]");
		reportTrOpen("RD_06_S_001_145","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_144&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");
		window.open(url + "" + "?fileName=RD_06_S_001_145&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-81" || sgid == "P08-0000011-82" || sgid == "P08-0000011-83") { // 에스원 그룹(KRS-1-G001) 70개 고객사 거래명세서
		reportTrOpen("RD_06_S_001_146","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_146&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}else if (sgid == "P08-0000011-84") { // 휴켐스(주) 여수2공장 (KRHUCH0002)
		reportTrOpen("RD_06_S_001_147","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_147&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}
	else if (sgid == "P08-0000011-85") { // 대원강업
		reportTrOpen("RD_06_S_001_148","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_148&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}
	else if (sgid == "P08-0000011-86") { // 에스와이에스리테일(IF) (KRSYS-0002)
		reportTrOpen("RD_06_S_001_149","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_149&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}
	else if (sgid == "P08-0000011-87") { // 경농(주) (KRKYUN0184)
		reportTrOpen("RD_06_S_001_150","[" + ik_no + "][" + seller + "][" + buyer + "]");
/*		window.open(url + "" + "?fileName=RD_06_S_001_150&param=[" + ik_no + "][" + seller + "][" + buyer + "]", "",
		"width=770,height=800,resizable=YES,top=0,left=0");*/
	}
	else if (sgid == "P08-0000011-88") { // 동화그룹 (KRDONGG007)
		reportTrOpen("RD_06_S_001_151","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-89") { // SPC
		reportTrOpen("RD_06_S_001_152","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-90") { // 넥센타이어 IF(KRNEXE0008, KRNEXE0009)
		reportTrOpen("RD_06_S_001_153","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-91") { // non-IF 품목코드, 발주번호, 관리코드 표준 거래명세서
		reportTrOpen("RD_06_S_001_300","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-92") { // 지에스건설 (KRGS-E0001)
		reportTrOpen("RD_06_S_001_400","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-93") { // 한화기계그룹(KRHANW0096, KRHANW0097, KRHANW0098)
		reportTrOpen("RD_06_S_001_155","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-94") { /* 한화방산글로벌(KRHANW0085, KRHANW0086, KRHANW0087, KRHANW0088, KRHANW0089, KRHANW0090, KRHANW0091, 
														KRHANW0092, KRHANW0093, KRHANW0094, KRHANW0100)*/
		reportTrOpen("RD_06_S_001_156","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-95") { // 램리서치코리아테크놀로지(KRLAM-0001)
		reportTrOpen("RD_06_S_001_157","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-96") { // 팔도(KRPALD0001, KRPALD0002, KRPALD0003, KRPALD0004, KRPALD0005)
		reportTrOpen("RD_06_S_001_158","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-97") { // 엘에스메탈(주)장항공장(KRLS-M0002)
		reportTrOpen("RD_06_S_001_201","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-98") { // 롯데알미늄(KRLOTT0070,KRLOTT0071,	KRLOTT0072, KRLOTT0073, KRLOTT0074, KRLOTT0075,	KRLOTT0076, KRLOTT0077)
		reportTrOpen("RD_06_S_001_133","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-99") { // 삼기(KRSAMK0030,KRSAMK0031)
		reportTrOpen("RD_06_S_001_159","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-100") { // 삼기이브이(KRSAMK0032,KRSAMK0033)
		reportTrOpen("RD_06_S_001_160","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-101") { // 금호석유화학(KRKUMH0043~KRKUMH0053)
		reportTrOpen("RD_06_S_001_172","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-102") { // 코오롱(NON IF, P08-0000011-47 와 같은 형식이지만 LEGACY_IV_SERIAL을 체크하지 않음)
		reportTrOpen("RD_06_T_003_01","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-103") { // 솔브레인 그룹
		if(dhim_legacy_po_no == "4" && legacy_iv_serial == ""){ // IF발주에 LEGACY_IV_SERIAL 없는 것들
			alert("고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)");
			return;
		}else{
			reportTrOpen("RD_06_S_001_164","[" + ik_no + "][" + seller + "][" + buyer + "]");	
		}
	}
	else if (sgid == "P08-0000011-104") { // SK마이크로웍스(KRSK--0001, KRSK--0002, KRSK--0003, KRSK--0004)
		reportTrOpen("RD_06_S_001_165","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-105") { // 피유코어 주식회사(KRSKPU0001)
		reportTrOpen("RD_06_S_001_166","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-106") { // 깨끗한나라(KRKLEA0003)
		reportTrOpen("RD_06_S_001_173","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-107") { // 일진그룹(KRILJIG004) - (주)일진, (주)일진베어링 KRILJI0093, KRILJI0094		
		reportTrOpen("RD_06_S_001_175","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else if (sgid == "P08-0000011-108") { // 디알비동일(KRDRB-0004, KRDRB-0005, KRDRB-0006)
		reportTrOpen("RD_06_S_001_176","[" + ik_no + "][" + seller + "][" + buyer + "]");		
	}
	else if (sgid == "P08-0000011-109") { // (주)일진(KRILJI0093)
		reportTrOpen("RD_06_S_001_174","[" + ik_no + "][" + seller + "][" + buyer + "]");
		reportTrOpen("RD_06_S_001_175","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}else if (sgid == "P08-0000011-110") { // 품목코드 있는 표준 코아비스(KRCOAV0001) 요청자 안병환/티씨테크, 20171124 한승준 셀트리온제약(KRCELL0008,KRCELL0009,KRCELL0010) - 정윤석CJ
		reportTrOpen("RD_06_S_001_167","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
	else {
		// 리포트 디자이너 Sheet Open
		reportTrOpen("RD_08_M_006_54","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
		reportTrOpen("RD_08_M_006_55","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_006_54&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=200");
		window.open(url + "" + "?fileName=RD_08_M_006_55&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + seller + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=0");*/
	}

	/* 피킹리스트 */
	reportTrOpen("RD_08_M_003_00","[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + user_id + "]");
/*	window.open(url + "" + "?fileName=RD_08_M_003_00&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "][" + user_id + "]", "",
			"width=770,height=800,resizable=YES,top=0,left=400");*/
	/* 패킹리스트 */
	if (carid != "") {
		reportTrOpen("RD_08_M_005_02","[" + warehouse_code + "][" + buyer + "][" + ik_no + "]");
/*		window.open(url + "" + "?fileName=RD_08_M_005_02&param=[" + warehouse_code + "][" + buyer + "][" + ik_no + "]", "",
				"width=770,height=800,resizable=YES,top=0,left=600");*/
	}

	/* 기본 출력과 함께 필요한 케이스 */
	if(sgid == "P08-0000011-57"){// GS칼텍스 분할납품요청서(발주서) 같이 출력 2016.08.11 by HSJ
		window.open("http://supplier.gscaltex.co.kr/apprtoffice/KEP_FILE_M.do?PO_NO="+legacy_po,"sheetWin2","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}
	else if (sgid == "P08-0000011-101") { // 금호석유화학(KRKUMH0043~KRKUMH0053) 검수보고서 추가 출력
		reportTrOpen("RD_06_S_001_161","[" + ik_no + "][" + seller + "][" + buyer + "]");
	}
}
