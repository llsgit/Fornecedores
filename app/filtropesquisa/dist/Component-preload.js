//@ui5-bundle claro/portalreparos/filtropesquisa/Component-preload.js
jQuery.sap.registerPreloadedModules({
"version":"2.0",
"modules":{
	"claro/portalreparos/filtropesquisa/Component.js":function(){sap.ui.define(["sap/fe/core/AppComponent"],function(e){"use strict";return e.extend("claro.portalreparos.filtropesquisa.Component",{metadata:{manifest:"json"}})});
},
	"claro/portalreparos/filtropesquisa/i18n/i18n.properties":'# This is the resource bundle for filtropesquisa\n\n#Texts for manifest.json\n\n#XTIT: Application name\nappTitle=Filtros de Pesquisa\n\n#YDES: Application description\nappDescription=App para configura\\u00e7\\u00e3o de par\\u00e2metros de pesquisa\n',
	"claro/portalreparos/filtropesquisa/manifest.json":'{"_version":"1.31.0","sap.app":{"id":"claro.portalreparos.filtropesquisa","type":"application","i18n":"i18n/i18n.properties","applicationVersion":{"version":"1.0.0"},"title":"{{appTitle}}","description":"{{appDescription}}","dataSources":{"mainService":{"uri":"ordem/","type":"OData","settings":{"odataVersion":"4.0"}}},"offline":false,"resources":"resources.json","sourceTemplate":{"id":"ui5template.fiorielements.v4.lrop","version":"1.0.0"},"crossNavigation":{"inbounds":{"claro-portalreparos-filtropesquisa-inbound":{"signature":{"parameters":{},"additionalParameters":"allowed"},"semanticObject":"FiltroPesquisa","action":"Editar","title":"Editar","subTitle":"","icon":""}}}},"sap.ui":{"technology":"UI5","icons":{"icon":"","favIcon":"","phone":"","phone@2":"","tablet":"","tablet@2":""},"deviceTypes":{"desktop":true,"tablet":true,"phone":true}},"sap.ui5":{"resources":{"js":[],"css":[]},"dependencies":{"minUI5Version":"1.76.0","libs":{"sap.ui.core":{},"sap.fe.templates":{}}},"models":{"i18n":{"type":"sap.ui.model.resource.ResourceModel","uri":"i18n/i18n.properties"},"":{"dataSource":"mainService","preload":true,"settings":{"synchronizationMode":"None","operationMode":"Server","autoExpandSelect":true,"earlyRequests":true}}},"routing":{"routes":[{"pattern":":?query:","name":"FiltrosPesquisaList","target":"FiltrosPesquisaList"},{"pattern":"FiltrosPesquisa({key}):?query:","name":"FiltrosPesquisaObjectPage","target":"FiltrosPesquisaObjectPage"}],"targets":{"FiltrosPesquisaList":{"type":"Component","id":"FiltrosPesquisaList","name":"sap.fe.templates.ListReport","options":{"settings":{"entitySet":"FiltrosPesquisa","variantManagement":"Page","navigation":{"FiltrosPesquisa":{"detail":{"route":"FiltrosPesquisaObjectPage"}}},"controlConfiguration":{"@com.sap.vocabularies.UI.v1.LineItem":{"tableSettings":{"type":"ResponsiveTable","creationMode":{"name":"NewPage"},"selectionMode":"Single","selectAll":false,"enableExport":true}}}}}},"FiltrosPesquisaObjectPage":{"type":"Component","id":"FiltrosPesquisaObjectPage","name":"sap.fe.templates.ObjectPage","options":{"settings":{"entitySet":"FiltrosPesquisa","navigation":{},"editableHeaderContent":false,"showRelatedApps":false,"content":{}}}}}},"contentDensities":{"compact":true,"cozy":true}},"sap.platform.abap":{"_version":"1.1.0","uri":""},"sap.platform.hcp":{"_version":"1.1.0","uri":""},"sap.fiori":{"_version":"1.1.0","registrationIds":[],"archeType":"transactional"},"sap.cloud":{"public":true,"service":"claro.manutencao"}}'
}});
