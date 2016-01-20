<%@include file="../../includes/declarations.jspf"%>

<c:set var="tabsPosition"
       value="${currentNode.properties['tabsPosition'].string ne 'top' ? currentNode.properties['tabsPosition'].string : ''}"/>
<c:set var="fadeIn" value="${currentNode.properties['fadeIn'].boolean}"/>
<c:if test="${not empty tabsPosition}">
    <c:set var="tabsPositionCss" value=" tabs-${tabsPosition}"/>
</c:if>
<c:set var="subLists" value="${jcr:getChildrenOfType(currentNode, 'jnt:contentList')}"/>
<c:set var="activatedTab"
       value="${not empty cookie['bootstrapTabularList-activatedTab'] ? cookie['bootstrapTabularList-activatedTab'].value : ''}"/>

<template:addResources type="inlinejavascript">

    <script type="text/javascript">

        $(document).ready(function () {

            $('a[data-toggle="tab"]').on('shown', function (e) {
                // e.target is the activated tab
                document.cookie = "bootstrapTabularList-activatedTab = " + e.target.attributes['href'].value;
            });

            <c:if test="${not empty activatedTab}">
            $('#jnt_bootstrapTabularList-${currentNode.identifier}').find('a[href="${activatedTab}"]').tab('show');
            </c:if>

        });

    </script>

</template:addResources>


<c:if test="${not renderContext.editMode && not empty param['bootstrapTab']}">
    <template:addResources type="inlinejavascript">

        <script type="text/javascript">

            $(document).ready(function () {

                $('#jnt_bootstrapTabularList-${currentNode.identifier}')
                        .find('a[href="#${param['bootstrapTab']}"]')
                        .tab('show');
            });

        </script>

    </template:addResources>
</c:if>

<div class="tabbable jnt_bootstrapTabularList ${not empty tabsPositionCss ? tabsPositionCss : ''}"
     id="jnt_bootstrapTabularList-${currentNode.identifier}">


    <ul class="nav nav-tabs">

        <c:forEach items="${subLists}" var="subList" varStatus="status">

            <template:module node="${subList}" view="moderateMessages.nav-tabs" editable="false" >
                <template:param name="first" value="${status.first}"/>
                <template:param name="count" value="${status.count}"/>
                <template:param name="id" value="${currentNode.identifier}"/>
            </template:module>

        </c:forEach>

    </ul>


    <div class="tab-content">

        <c:forEach items="${subLists}" var="subList" varStatus="status">

            <template:module node="${subList}" view="moderateMessages.tab-pane" editable="false">
                <template:param name="first" value="${status.first}"/>
                <template:param name="count" value="${status.count}"/>
                <template:param name="id" value="${currentNode.identifier}"/>
                <template:param name="fade" value="${fadeIn}"/>
            </template:module>

        </c:forEach>

    </div>
    <!-- /tab-content -->

    <c:if test="${renderContext.editMode}">
        <template:module path="*"/>
    </c:if>

</div>
