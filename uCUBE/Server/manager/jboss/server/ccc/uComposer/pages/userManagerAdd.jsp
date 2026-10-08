<%@page pageEncoding="UTF-8"%>
<!-- 사용자 추가 화면임(userManager.jsp에 포함 -->
<table id=userManagerAddTbl width="600" style="position:absolute;top:170px;Left:350px;display:none" bgcolor=white border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
	<tr width=690>
		<td valign=top width=600 align=center>
			<table bgcolor=white>
				<tr height=10><td> </td></tr>
				<tr bgcolor=white> 
					<td height=25> 
						<table height="25" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<img src="img/comm_img02_blank.gif" width="5" height="10">
									<img src="img/comm_img03_ic.gif" width="11" height="10">
									<span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
									<span class="tit01">User 등록</span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td background="img/m000006img.gif" ><img src="img/m000006img.gif" width="2" height="7"></td>
				</tr>
				<tr height=25>
					<td align=right>
						<img src="img/m000007ico.gif" style="cursor:hand" align="absmiddle" onClick="registUser();" alt="등록">
						<img src="img/m000005ico.gif" style="cursor:hand" align="absmiddle" onClick="javascript:userManagerAddTbl.style.display='none';" alt="닫기">
					</td>
				</tr>
				<tr>
					<td background="img/m000006img.gif" ><img src="img/m000006img.gif" width="2" height="7"></td>
				</tr>								
				<tr>
					<td>
						<table width="500" border="1" cellpadding="1" cellspacing="0" bordercolor="Black" bordercolorlight="#626262" bordercolordark="White" class="tblcb1" valign="TOP" style="table-layout:fixed">
							<tr height="22" class=tbldb>
								<td class=tbldb width=130><b>항목</b></td>
								
								<td class=tbldb width=%><b>값</b></td>
							</tr>
							<tr>
								<td class="tblcb3"><font color=red>*</font> 아 이 디 </td>
								<td class="tbllw">&nbsp;<input type="text" name="UserEmpNoP" value="" maxlength=12 size=15 class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'"/>
								<!--img src="img/join-member-sub-icon02.gif" style="cursor:hand" align="absmiddle" onClick="registUser();" alt="중복확인" -->
								<br>&nbsp;<font color="FF5C00">(아이디는 4~12자까지이고 영문 숫자 조합, 특수문자 불가)</font></td>
							</tr>
							<tr>
								<td class="tblcb3"><font color=red>*</font> 비밀번호</td>
								<td class="tbllw">&nbsp;<input type="password" maxlength=12 size=15 name="EaiUserPasswordP" value="" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
								<font color="FF5C00"> (영문 숫자 4~12자 이내 조합, 특수문자 불가)</font></td>
							</tr>
							<tr>
								<td class="tblcb3"><font color=red>*</font> 비밀번호 확인</td>
								<td class="tbllw">&nbsp;<input type="password" maxlength=12 size=15 name="EaiUserPasswordP1" value="" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
								<font color="FF5C00"> (확인을 위해서 다시 한번 입력해주세요)</font></td>
							</tr>
							<tr>
								<td class="tblcb3">사용자 이름</td>
								<td class="tbllw">&nbsp;<input name="LastNameP" type="text" value="" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" /></td>
							</tr>
							<tr>
								<td class="tblcb3">이메일 주소</td>
								<td class="tbllw">&nbsp;<input type="text" name="EmailAddressP"  maxlength=50 size=20 value="" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
								<font color="FF5C00"> (입력 예 : ucube@posdata.co.kr)
								</td>
							</tr>
							<tr>
								<td class="tblcb3">접근레벨</td>
								<td class="tbllw">&nbsp;
									<SELECT name="SysUserTpP" class="adf">
									<OPTION value=3>Developer</OPTION>
									<OPTION value=1>Manager</OPTION>
									<!--OPTION value=2>Admin</OPTION-->
									</SELECT>
								</td>
							</tr>
							<tr>
								<td class="tblcb3"><font color=red>*</font> 핸드폰 번호</td>
								<td class="tbllw">&nbsp;<input maxlength=13 name="HandPhoneP" type="text" value="" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'"/>
								<font color="FF5C00"> (입력  예 : 011-0000-0000)</font></td>
							</tr>
							<tr>
								<td class="tblcb3">SMS 수신여부</td>
								<td class=tbllw>&nbsp;<input type=checkbox checked name=smsChecked /> 
								<input type="hidden" name=SmsRcvFlagP /></td>
							</tr>
						</table>
						&nbsp;&nbsp;<font color=red>*</font> 는 필수 항목입니다.
					</td>
				</tr>
				<tr height=40><td> </td></tr>				
			</table>
		</td>
	</tr>					
</table>
<!-- 사용자 추가 화면임 -->
