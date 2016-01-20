<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<%@include file="../../includes/declarations.jspf" %>
<html lang="${fn:substring(renderContext.request.locale,0,2)}">
<head>
    <meta charset="UTF-8">
    <jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:description" inherited="true"
                      var="description"/>
    <jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:createdBy" inherited="true" var="author"/>
    <c:set var="keywords" value="${jcr:getKeywords(renderContext.mainResource.node, true)}"/>
    <c:if test="${!empty description}">
        <meta name="description" content="${description.string}"/>
    </c:if>
    <c:if test="${!empty author}">
        <meta name="author" content="${author.string}"/>
    </c:if>
    <c:if test="${!empty keywords}">
        <meta name="keywords" content="${keywords}"/>
    </c:if>
    <title>${fn:escapeXml(renderContext.mainResource.node.displayableName)}</title>
</head>

<body>

<div class="well clearfix">
    <template:area path="pagecontent"/>
</div>
<div class="clearfix">
    <p class="text-center jahia-admin-copyright">
        <fmt:message key="jahia.copyright"/>
        <img src="<c:url value='/modules/default/images/jahia-bullet.png'/>" alt=""/>
        <fmt:message key="jahia.company"/>
    </p>
</div>
<c:if test="${renderContext.editMode}">
    <template:addResources type="css" resources="edit.css"/>
</c:if>

<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="jquery-ui.min.js"/>
<template:addResources type="javascript" resources="admin-bootstrap.js"/>
<template:addResources type="javascript" resources="bootstrap-filestyle.min.js"/>
<template:addResources type="javascript" resources="jquery.metadata.js"/>
<template:addResources type="javascript" resources="jquery.tablesorter.js"/>
<template:addResources type="javascript" resources="jquery.tablecloth.js"/>

<template:addResources type="javascript" resources="datatables/jquery.dataTables.js"/>
<template:addResources type="javascript" resources="i18n/jquery.dataTables-${currentResource.locale}.js"/>
<template:addResources type="javascript" resources="datatables/dataTables.bootstrap-ext.js"/>

<template:addResources type="css" resources="admin-bootstrap.css"/>
<template:addResources type="css" resources="admin-site-settings.css"/>
<template:addResources type="css" resources="moderateMessages.css"/>
<template:theme/>

</body>
</html>
