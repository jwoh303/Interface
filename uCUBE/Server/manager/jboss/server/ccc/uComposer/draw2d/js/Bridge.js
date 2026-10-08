/* This notice must be untouched at all times.

Open-jACOB Draw2D
The latest version is available at
http://www.openjacob.org

Copyright (c) 2006 Andreas Herz. All rights reserved.
Created 5. 11. 2006 by Andreas Herz (Web: http://www.freegroup.de )

LICENSE: LGPL

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License (LGPL) as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA,
or see http://www.gnu.org/copyleft/lesser.html
*/
draw2d.Bridge=function(/*:String*/ title, /*:String*/ image)
{
  this.title = title;
  this.service_group_type = image.toLowerCase();
  this.image = "sg_type_" + image.toLowerCase() + ".gif";
  draw2d.Node.call(this);

  this.setLineWidth(0);
  this.outputPort = null;
  this.inputPort = null;
  this.setDimension(44,44);
  this.setResizeable(false);

  //return this;
}

draw2d.Bridge.prototype = new draw2d.Node;
draw2d.Bridge.prototype.type="Bridge";

draw2d.Bridge.prototype.setWorkflow=function(/*:draw2d.Workflow*/ workflow)
{
  draw2d.ImageFigure.prototype.setWorkflow.call(this,workflow);

  if(workflow!=null && this.outputPort==null && this.inputPort==null)
  {

    // create a new Port element. Ports can be children of "Node" elements.
    // (Inheritance: Bridge->Image->Node->Figure->Object)
    this.inputPort = new draw2d.MyInputPort();
    this.inputPort.setWorkflow(workflow);
    this.inputPort.setName("input");
    this.inputPort.setBackgroundColor(new  draw2d.Color(115,115,245));
    this.inputPort.setColor(null);
    this.addPort(this.inputPort,0,this.height/2);

    this.outputPort = new draw2d.MyOutputPort();
    this.outputPort.setWorkflow(workflow);
    this.outputPort.setMaxFanOut(1);
    this.outputPort.setName("output");
    this.outputPort.setBackgroundColor(new  draw2d.Color(245,115,115));
    this.addPort(this.outputPort,this.width,this.height/2);

  }
}


/**
 * Add a centered label and image
 *
 * @private
 **/

draw2d.Bridge.prototype.createHTMLElement=function()
{
  var item = draw2d.CompartmentFigure.prototype.createHTMLElement.call(this);
/*
  this.label = document.createElement("div");

  this.label.style.position="absolute";
  //this.label.style.left   = "0px";
  //this.label.style.top    = "0px";
  this.label.style.width = "100%";
  //this.label.style.height = (this.getHeight())+"px";
  this.label.style.height = "100%";
  this.label.style.font="bold 12px verdana";
  this.label.style.textAlign="center";

  this.label.style.backgroundImage = "url(/uComposer/draw2d/images/"+this.type+".png"+")";
  this.label.style.backgroundRepeat = "no-repeat";

	this.label.innerHTML = "<div style='margin-top:60'>"+this.title+"</div>";
  item.appendChild(this.label);
*/

  item.innerHTML = "<div style='font:bold 12px verdana;height:100%;background-image:url(/uComposer/draw2d/images/" + this.image + ");background-repeat:no-repeat;background-position:up;' onfocus='this.blur()'><div style='height:50px;'></div>"+this.title+"</div>";

  return item;
}


/**
 * Callback method for the context menu..
 **/
draw2d.Bridge.prototype.getContextMenu=function()
{
  var menu =new draw2d.Menu();
  var oThis = this;

  if(this.service_group_type=="12") {
  	menu.appendMenuItem(new draw2d.MenuItem("Rule Management", null,function(){ ruleManagement(oThis); }));
  }
  menu.appendMenuItem(new draw2d.MenuItem("Delete Service", null,function(){ deleteService(oThis); }));
  
  return menu;
}