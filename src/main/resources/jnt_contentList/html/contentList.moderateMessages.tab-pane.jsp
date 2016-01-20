<%@include file="../../includes/declarations.jspf" %>


<c:set var="tabPaneCSS" value="tab-pane"/>
<c:if test="${currentResource.moduleParams.first}">
    <c:set var="tabPaneCSS" value="${tabPaneCSS} active"/>
</c:if>
<c:if test="${currentResource.moduleParams.fade && not renderContext.editMode}">
    <c:set var="tabPaneCSS" value="${tabPaneCSS} fade"/>
    <c:if test="${currentResource.moduleParams.first}">
        <c:set var="tabPaneCSS" value="${tabPaneCSS} in"/>
    </c:if>
</c:if>

<div class="${tabPaneCSS}" id="tab${currentResource.moduleParams.count}-${currentResource.moduleParams.id}">

    <template:module path="${currentNode.path}" view="default"/>

</div>

