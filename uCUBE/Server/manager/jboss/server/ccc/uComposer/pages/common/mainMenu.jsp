<script language="JavaScript" src="/uComposer/js/dropdown.js"></script>
<script language="JavaScript" src="/uComposer/js/link.js"></script>

	<script language="JavaScript" type="text/JavaScript">
		function MM_preloadimage() {  // v3.0
			var d=document;
			if(d.image) {
				if(!d.MM_p) d.MM_p=new Array();
				var i,j=d.MM_p.length,a=MM_preloadimage.arguments;
				for(i=0; i<a.length; i++)
					if (a[i].indexOf("#")!=0) {
						d.MM_p[j]=new Image;
						d.MM_p[j++].src=a[i];
					}
			}
		}

		function MM_swapImgRestore() {  // v3.0
			var i,x,a=document.MM_sr;
			for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
		}

		function MM_findObj(n, d) {  // v4.01
			var p,i,x;
			if(!d) d=document;
			if((p=n.indexOf("?"))>0&&parent.frames.length) {
				d=parent.frames[n.substring(p+1)].document;
				n=n.substring(0,p);
			}
			if(!(x=d[n])&&d.all) x=d.all[n];
			for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
			for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
			if(!x && d.getElementById) x=d.getElementById(n);
			return x;
		}

		function MM_swapImage() {  // v3.0
			var i,j=0,x,a=MM_swapImage.arguments;
			document.MM_sr=new Array;
			for(i=0;i<(a.length-2);i+=3)
				if((x=MM_findObj(a[i]))!=null) {
					document.MM_sr[j++]=x;
					if(!x.oSrc) x.oSrc=x.src;
					x.src=a[i+2];
				}
		}

		function MM_preloadImages() {  // v3.0
			var d=document;
			if(d.images) {
				if(!d.MM_p) d.MM_p=new Array();
				var i,j=d.MM_p.length,a=MM_preloadImages.arguments;
				for(i=0; i<a.length; i++)
					if (a[i].indexOf("#")!=0) {
						d.MM_p[j]=new Image;
						d.MM_p[j++].src=a[i];
					}
			}
		}
	</script>




		<!--메인메뉴-->
		<table width="980"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20"><img src="/uComposer/img/ucube_img02_menu.gif" width="11" height="28"></td>
				<td width="20%" background="/uComposer/img/ucube_img03_menu.gif">&nbsp;</td>
				<td width="110"><a href="javascript:;" onMouseOver="MM_swapImage('Image1','','/uComposer/img/ucube_img04_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="/uComposer/img/ucube_img04_menu.gif" name="Image1" width="110" height="28" border="0" id="Image1"></a></td>
				<td width="104"><a href="javascript:;" onMouseOver="MM_swapImage('Image2','','/uComposer/img/ucube_img05_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="/uComposer/img/ucube_img05_menu.gif" name="Image2" width="104" height="28" border="0" id="Image2"></a></td>
				<td width="130"><a href="javascript:;" onMouseOver="MM_swapImage('Image4','','/uComposer/img/ucube_img06_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="/uComposer/img/ucube_img06_menu.gif" name="Image4" width="130" height="28" border="0" id="Image4"></a></td>
				<td width="130"><a href="javascript:;" onMouseOver="MM_swapImage('Image5','','/uComposer/img/ucube_img07_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()"><img src="/uComposer/img/ucube_img07_menu.gif" name="Image5" width="137" height="28" border="0" id="Image5"></a></td>

				<td width="124" >
					<div id="menu_parent" ><img src="/uComposer/img/ucube_img08_menu_over.gif" name="Image6" width="124" height="28" id="Image6"></div>
					<div id="menu_child" style="position: absolute; width: 127px; left: 680px; top: 58px;">
						<iframe id=mcomposersub style="z-index: 2; width: 193px; position: absolute; height: 66px" marginWidth=0 marginHeight=0
							src="/uComposer/pages/common/mcomposersub.htm"
							frameBorder=0 scrolling=no>
						</iframe>
					</div>
					<script type="text/javascript">
						at_attach("menu_parent", "menu_child", "hover", "y", "pointer");
					</script>
				</td>

				<td width="20%" background="/uComposer/img/ucube_img03_menu.gif">&nbsp;</td>
				<td width="27"><img src="/uComposer/img/ucube_img09_menu.gif" width="9" height="28"></td>
			</tr>
		</table>
		<!--메인메뉴 끝-->

