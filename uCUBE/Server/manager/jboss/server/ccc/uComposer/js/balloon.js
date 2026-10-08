/**
 * Created by 행복한고니
 *
 * Homepage    : http://mygony.com
 * Last update : 2005/04/10
 *
 * 2005-04-10 
 *     - 첫번째 릴리즈
 */

function balloonHint(Id)
{
	balloonHint.layerId = Id;
	document.addEventListener('mouseover', balloonHint.Show, false);
	document.addEventListener('mouseout', balloonHint.Hide, false);
}

balloonHint.layerId = null;
balloonHint.Show = function (evt) {
	if (typeof evt == "undefined" || typeof evt.target == "undefined") {
		(evt=event).target = event.srcElement;
	}

	var hint = evt.target.getAttribute("hint");
	if (hint == null || hint.length == 0) return;
	if (balloonHint.layer == null) balloonHint.makeLayer();

	with (balloonHint.layer) {
		innerHTML = sourceHTML.replace("{{hint}}", hint);
		show(evt.clientX, evt.clientY);
	}
}

balloonHint.Hide = function (evt) {
	if (typeof evt == "undefined" || typeof evt.target == "undefined") {
		(evt=event).target = event.srcElement;
	}

	var hint = evt.target.getAttribute("hint");
	if (hint == null || hint.length == 0) return;

	balloonHint.layer.hide();
}

balloonHint.makeLayer = function()
{
	if (typeof document.body == "undefined") {
		document.body = document.getElementsByTagName("BODY")[0];
	}

	balloonHint.layer = document.getElementById(balloonHint.layerId);
	balloonHint.layer.sourceHTML = balloonHint.layer.innerHTML;
	balloonHint.layer.style.position = "absolute";

	if (typeof window.createPopup == "undefined") {
		balloonHint.layer.show = function(x, y) {
			balloonHint.layer.style.display = "block";
			balloonHint.layer.style.left = (x+document.body.scrollLeft) + "px";
			balloonHint.layer.style.top =  (y+document.body.scrollTop) + "px";
		}
		balloonHint.layer.hide = function() {
			balloonHint.layer.style.display = "none";
		}
	} else {
		balloonHint.layer.popup = window.createPopup();
		balloonHint.layer.show = function(x, y) {
			with (balloonHint.layer) {
				style.display = "block";
				var w = offsetWidth, h = offsetHeight;
				style.display = "none";
				popup.document.body.innerHTML = innerHTML;
				popup.show(x, y, w, h, document.body);
			}
		}
		balloonHint.layer.hide = function() {
			balloonHint.layer.popup.hide();
		}
	}
}

if (typeof document.addEventListener == "undefined") {
	if (typeof document.attachEvent != "undefined") {
		document.addEventListener = function (eventType, listener) {
			document.attachEvent("on"+eventType, listener);
		}
		document.removeEventListener = function (eventType, listener) {
			document.detachEvent("on"+eventType, listener);
		}
	}
}
