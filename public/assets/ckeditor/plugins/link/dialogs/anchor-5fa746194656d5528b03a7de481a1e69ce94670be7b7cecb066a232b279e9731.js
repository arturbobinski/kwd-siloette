CKEDITOR.dialog.add("anchor",function(e){function t(e,t){return e.createFakeElement(e.document.createElement("a",{attributes:t}),"cke_anchor","anchor")}return{title:e.lang.link.anchor.title,minWidth:300,minHeight:60,onOk:function(){var n=CKEDITOR.tools.trim(this.getValueOf("info","txtName")),n={id:n,name:n,"data-cke-saved-name":n};if(this._.selectedElement)this._.selectedElement.data("cke-realelement")?(n=t(e,n),n.replace(this._.selectedElement),CKEDITOR.env.ie&&e.getSelection().selectElement(n)):this._.selectedElement.setAttributes(n);else{var i=e.getSelection(),i=i&&i.getRanges()[0];i.collapsed?(n=t(e,n),i.insertNode(n)):(CKEDITOR.env.ie&&9>CKEDITOR.env.version&&(n["class"]="cke_anchor"),n=new CKEDITOR.style({element:"a",attributes:n}),n.type=CKEDITOR.STYLE_INLINE,e.applyStyle(n))}},onHide:function(){delete this._.selectedElement},onShow:function(){var t=e.getSelection(),n=t.getSelectedElement(),i=n&&n.data("cke-realelement"),o=i?CKEDITOR.plugins.link.tryRestoreFakeAnchor(e,n):CKEDITOR.plugins.link.getSelectedLink(e);if(o){this._.selectedElement=o;var a=o.data("cke-saved-name");this.setValueOf("info","txtName",a||""),!i&&t.selectElement(o),n&&(this._.selectedElement=n)}this.getContentElement("info","txtName").focus()},contents:[{id:"info",label:e.lang.link.anchor.title,accessKey:"I",elements:[{type:"text",id:"txtName",label:e.lang.link.anchor.name,required:!0,validate:function(){return this.getValue()?!0:(alert(e.lang.link.anchor.errorName),!1)}}]}]}});