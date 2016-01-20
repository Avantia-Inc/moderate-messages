<%@include file="../../includes/declarations.jspf" %>

<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>

<h2>
    <fmt:message key="siteSettings.label.viewAllMessages"/>
    - ${fn:escapeXml(site.displayableName)}
</h2>
<c:set var="count" value="0" scope="page"/>
<div class="box-1">
    <h3>
        <fmt:message key="siteSettings.label.viewAllMessages"/>
    </h3>

    <c:if test="${not empty allPostlist}">

        <table id="MessagesTable"
               class="table table-bordered table-striped table-hover display data-table">
            <thead>
            <tr>
                <th width="3%">#</th>
                <th width="7%"><fmt:message
                        key="moderateMessages.table.postType"/></th>
                <th width="45%"><fmt:message
                        key="moderateMessages.table.post"/></th>
                <th width="10%"><fmt:message
                        key="moderateMessages.table.postdate"/></th>
                <th width="8%"><fmt:message
                        key="moderateMessages.table.postby"/></th>
                <th width="27%"><fmt:message
                        key="moderateMessages.table.postactions"/></th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${allPostlist}" var="loneMsg"
                       varStatus="status">

                <template:addCacheDependency node="${loneMsg}"/>

                <c:if test="${jcr:isNodeType(loneMsg, 'jnt:post')}">

                    <jcr:nodeProperty node="${loneMsg}" name="jcr:title"
                                      var="commentTitle"/>
                    <jcr:nodeProperty node="${loneMsg.parent}" name="topicSubject"
                                      var="topicSubject"/>
                    <jcr:nodeProperty node="${loneMsg.parent.parent}"
                                      name="jcr:title" var="sectionTitle"/>
                    <jcr:nodeProperty node="${loneMsg}" name="jcr:createdBy"
                                      var="createdBy"/>
                    <jcr:nodeProperty node="${loneMsg}" name="content"
                                      var="content"/>


                    <c:if
                            test="${jcr:isNodeType(loneMsg, 'jmix:moderated') and loneMsg.properties.moderated.boolean}">

                        <tr>

                            <td><c:set var="count" value="${count + 1}" scope="page"/>
                                <c:out value="${count}"/></td>
                            <td>
                                <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:blogPost')}"> Blog </c:if>
                                <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:page') and (loneMsg.parent.name == 'comments')}"> Comment </c:if>
                                <c:if test="${jcr:isNodeType(loneMsg.parent, 'jnt:topic') and (loneMsg.parent.name != 'comments')}"> Forum </c:if>
                            </td>
                            <td>
                                <a href="<c:url value='${url.baseLive}${loneMsg.parent.path}.html'/>"
                                   target="_blank"
                                   title='<fmt:message key=" label.navigateTo "/>' class="postTitle"><c:out
                                        value="${commentTitle.string}"/>
                                </a>
                                <br/>
                                <c:if test="${jcr:isNodeType(loneMsg.parent, 'jnt:topic') and (loneMsg.parent.name != 'comments')}">
                                    <i><b>Section:</b> <c:out value="${sectionTitle.string}"/>
                                        <br/>
                                        <b>Topic:</b> <c:out value="${topicSubject.string}"/></i>
                                </c:if>
                                <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:page') and (loneMsg.parent.name == 'comments')}">
                                    <i><b>Page:</b> <c:out value="${sectionTitle.string}"/></i>
                                </c:if>
                                <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:blogPost')}">
                                    <i><b>Blog:</b> <c:out value="${sectionTitle.string}"/></i>
                                </c:if>
                            </td>
                            <jcr:nodeProperty node="${loneMsg}" name="jcr:lastModified"
                                              var="lastModified"/>
                            <td><span class="docspacedate timestamp"><fmt:formatDate
                                    value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm"/></span>
                            </td>
                            <td><span class="author"> <c:if
                                    test="${createdBy.string ne 'guest'}">
                                <a
                                        href="<c:url value='${url.base}${functions:lookupUser(createdBy.string).localPath}.html'/>">${createdBy.string}</a>
                                <jcr:node var="userNode"
                                          path="${functions:lookupUser(createdBy.string).localPath}"/>
                                <c:forEach items="${userNode.properties}" var="property">
                                    <c:if test="${property.name == 'j:firstName'}">
                                        <c:set var="firstname" value="${property.string}"/>
                                    </c:if>
                                    <c:if test="${property.name == 'j:lastName'}">
                                        <c:set var="lastname" value="${property.string}"/>
                                    </c:if>
                                    <c:if test="${property.name == 'j:email'}">
                                        <c:set var="email" value="${property.string}"/>
                                    </c:if>
                                    <c:if test="${property.name == 'j:title'}">
                                        <c:set var="title" value="${property.string}"/>
                                    </c:if>

                                    <jcr:nodeProperty var="picture" node="${userNode}"
                                                      name="j:picture"/>


                                </c:forEach>
                                <br/>
                                <i>(${firstname}
                                    <br/>
                                        ${lastname})
                                </i>
                            </c:if> <c:if test="${createdBy.string eq 'guest'}">
                                ${fn:escapeXml(loneMsg.properties.pseudo.string)}
                                <br/>
                                <i>(guest)</i>
                            </c:if>
									</span></td>

                            <template:tokenizedForm>
                                <form
                                        action="<c:url value='${url.baseLive}${loneMsg.path}'/>"
                                        method="post" id="jahia-forum-post-delete-${loneMsg.UUID}">
                                    <input type="hidden" name="jcrRedirectTo"
                                           value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                    <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                    <input type="hidden" name="jcrMethodToCall" value="delete"/>
                                </form>
                            </template:tokenizedForm>
                            <td>
                                <c:if test="${jcr:hasPermission(loneMsg, 'deletePost')}">

                                    <fmt:message key="moderateMessages.confirmDeletePost"
                                                 var="confirmMsg"/>
                                    <button type="button" class="btn btn-danger"
                                            onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                    { document.getElementById("jahia-forum-post-delete-${loneMsg.UUID}").submit(); } return false;'>
                                        <i class="icon-remove icon-white"></i>
                                        <fmt:message key='moderateMessages.deletePost'/>
                                    </button>
                                </c:if>

                                <button type="button"
                                        class="btn btn-primary btn-${loneMsg.UUID}"
                                        id="btn-${loneMsg.UUID}" data-toggle="modal"
                                        data-target="#${loneMsg.UUID}">
                                    <i class="icon-info-sign icon-white"></i><span><fmt:message
                                        key="moderateMessages.viewPost"/></span>
                                </button>
                            </td>

                        </tr>
                        <!-- Button trigger modal -->


                        <!-- Modal -->
                        <div class="modal fade" id="${loneMsg.UUID}" tabindex="-1"
                             role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">&times;</button>
                                        <h2 class="modal-title" id="myModalLabel">${commentTitle.string}
                                        </h2>
                                        <i>(<fmt:message
                                                key="moderateMessages.table.postby"/>&nbsp;${firstname}&nbsp;${lastname})
                                        </i>
                                        <c:if test="${not empty picture}">
                                            <img align="right"
                                                 class='user-profile-img userProfileImage'
                                                 src="${picture.node.thumbnailUrls['avatar_120']}"
                                                 alt="${fn:escapeXml(title)} ${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}"
                                                 width="60" height="60"/>
                                        </c:if>
                                        <h4 class="modal-title" id="myModalLabel">
                                            <br/>
                                            <c:if test="${jcr:isNodeType(loneMsg.parent, 'jnt:topic') and (loneMsg.parent.name != 'comments')}">
                                                <i><b>Section:</b> <c:out value="${sectionTitle.string}"/>
                                                    <br/>
                                                    <b>Topic:</b> <c:out value="${topicSubject.string}"/></i>
                                            </c:if>
                                            <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:page') and (loneMsg.parent.name == 'comments')}">
                                                <i><b>Page:</b> <c:out value="${sectionTitle.string}"/></i>
                                            </c:if>
                                            <c:if test="${jcr:isNodeType(loneMsg.parent.parent, 'jnt:blogPost')}">
                                                <i><b>Blog:</b> <c:out value="${sectionTitle.string}"/></i>
                                            </c:if>
                                        </h4>
                                    </div>
                                    <div class="modal-body">
                                            ${functions:removeHtmlTags(content.string)}</div>
                                    <div class="modal-footer">

                                        <button type="button" class="btn btn-danger"
                                                onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                        { document.getElementById("jahia-forum-post-delete-${loneMsg.UUID}").submit(); } return false;'>
                                            <i class="icon-remove icon-white"></i>
                                            <fmt:message key='moderateMessages.deletePost'/>
                                        </button>
                                        <button type="button" class="btn btn-default"
                                                data-dismiss="modal">Close
                                        </button>

                                    </div>
                                </div>
                            </div>
                        </div>


                    </c:if>
                </c:if>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty allPostlist}">
        <div class="alert alert-info">
            <h2><fmt:message key='moderateMessages.noPostToModerate'/></h2>
        </div>
    </c:if>
</div>



