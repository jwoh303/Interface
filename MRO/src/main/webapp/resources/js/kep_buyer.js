 function GoPass(checkpass,pass_flag , nu_tot_price,pass_buyer,pass_attach_yn)
{ 
	 
    var type =  document.forms.processForm.TYPE.value;
	    var category_no =  "";
		if(document.forms.processForm.st_category_no){
		    category_no =  document.forms.processForm.st_category_no.value;
		}

    // 경동보일러 일 경우 회원사 결재조건 설정여부와 상관없이 발주결재상신(PS) 상태로 처리함
    // 경동보일러(KRBOIL0002) 그룹웨어 결재 사용(결재완료시 I/F 쪽에서 발주생성함) , KOREAB2B.COM 사이트에서는  발주결재상신(PS) 상태까지 진행하고 ,  이후 진행은 I/F 에서 발주처리
    // ServerCall(GW_NO,recvFlag) ==> 발주모듈 생성할때  ==> GW_NO = 'GW0200XXX' 결재 처리한 건 ,  GW_NO = 'N' 결재 미처리 건, GW_NO = 'GROUPWARE' 경동보일러 건

    //  그룹웨어 결재 if(buyer == "KRBOIL0002" || buyer == "KRKDBO0001" || buyer == "KRKDBO0002" || buyer == "KRKDPR0001") 일 경우
    if(pass_flag == "G"){
        ServerCall("GROUPWARE","PS");
        return;
    }
    
    //alert("checkpass " +checkpass);
    //alert("pass_flag " +pass_flag);
    //alert("type " +type);
    
  //  checkpass = true; // 임시
  //  pass_flag = "N"; // 임시

    if(checkpass == "false" || checkpass == false) {        // 결재 처리를 하지 않는 경우

        if(type =="PR"){
            ServerCall("N","GA");
            return;
        }else if(type =="NS"){
            ServerCall("N","CM"); //신규소싱 단가합의 시 결재
            return;
        }else {
            ServerCall("N","PC");
            return;
        }

    }else{                  // 결재 처리 하는 경우

        if(pass_flag == "N"){
            if(type =="NS"){ //신규소싱 단가합의 시 결재
                if (!confirm("전자 결재 처리 하시겠습니까? \n\n직접 합의 하시려면 취소버튼을 눌러 주십시오.")){
                    ServerCall("N","CM");
                    return;
                }
            }else {
                // 결재 처리를 하지 않고 바로 Data를 처리하는 경우
                if (!confirm("전자 결재 처리 하시겠습니까? \n\n바로 주문을 하시려면 취소버튼을 눌러 주십시오.")){
                    if(type =="PR"){
                        ServerCall("N","GA");
                        return;
                    }else {
                        ServerCall("N","PC");
                        return;
                    }
                }
            }
        }
 
		//alert("상신팝업호출");
		
        openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=' + type + '&requesTemptYn=Y&DOCU_NO=&BIZ_DOCU_NO=&nu_tot_price='+nu_tot_price+'&st_category_no='+category_no+'&st_buyer='+pass_buyer+'&pass_attach_yn='+pass_attach_yn , "800,860,no");
    } 
}


function buyerMpSoCartListReport(buyer,param){
	
	if ("KRFUJI0002" == buyer){
		reportOpen("RD_06_B_001_00", param);  // cart_print_t_xerox
	}else if ("KRKOLO0016" == buyer){
		reportOpen("RD_06_B_001_07", param); //cart_print_t_kolo_kim
	}else if ("KRTAEY0004" == buyer){
		reportOpen("RD_06_B_001_08", param);  // cart_print_t_taey_new
	}else if ("KRHITE0004" == buyer){
		reportOpen("RD_06_B_001_09", param);  // cart_print_t_hite_masan_report
	}else if ("KRJINR0004" == buyer || "KRJINR0005" == buyer || "KRJINR0006" == buyer || "KRJINR0007" == buyer){
		reportOpen("RD_06_B_001_10", param);  // cart_print_t_jinro_new
	}else if ("KRMYUN0046" == buyer || "KRMYUN0047" == buyer || "KRMYUN0048" == buyer || "KRSEUN0026" == buyer || "KRSEUN0027" == buyer || "KRSEUN0028" == buyer){
		reportOpen("RD_06_B_001_11", param);  // cart_print_myunghwa_t
	}else if ("KRKOLO0041" == buyer){
		reportOpen("RD_06_B_001_12", param);  // cart_print_kolo0041_t
	}else if ("KRKOLO0078" == buyer || "KRPNS0001" == buyer){
		reportOpen("RD_06_B_001_13", param);  // cart_print_kolo0041_t
	}else {
		reportOpen("RD_06_B_001_17", param);  // cart_print_t
	}
	
	
	 
	if ("KRJINR0004" == buyer || "KRJINR0005" == buyer || "KRJINR0006" == buyer || "KRJINR0007" == buyer){
		reportOpen("prt_button_poom_jinro", param);  // /kr/customer/sheet/prt_button_poom_jinro.htm
	}else if ("KRKOLO0077" == buyer){
		reportOpen("RD_06_B_001_15", param);  // prt_button_poom2
	}else if ("KRWOOS0062" == buyer){
		reportOpen("prt_button_poom3", param);  // /kr/customer/sheet/prt_button_poom3.htm
	}else {
		reportOpen("prt_button_poom", param);  // /kr/customer/sheet/prt_button_poom.htm
	}
	 
	
	
}






 
