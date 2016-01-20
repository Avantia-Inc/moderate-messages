<%@include file="../../includes/declarations.jspf"%>


<li ${currentResource.moduleParams.first ? 'class="active"' : ''}>
    <a href="#tab${currentResource.moduleParams.count}-${currentResource.moduleParams.id}"
       data-toggle="tab">${fn:escapeXml(currentNode.displayableName)}</a>
</li>

