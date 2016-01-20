<%@include file="../../includes/declarations.jspf" %>
<script>


    $(document)
            .ready(function () {

                $('.data-table').dataTable({
                                               "sDom": "<'row-fluid'<'span6'l><'span6 text-right'f>r>t<'row-fluid'<'span6'i><'span6 text-right'p>>",
                                               "iDisplayLength": 5,
                                               "sPaginationType": "bootstrap",
                                               "aaSorting": [] //this option disable sort by default, the user steal can use column names to sort the table
                                           });

            });
</script>

<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>

<h2>
    <fmt:message key="siteSettings.label.moderateMessages"/>
    - ${fn:escapeXml(site.displayableName)}
</h2>
<c:set var="count" value="0" scope="page"/>
<div class="box-1">
    <h3>
        <fmt:message key="siteSettings.label.moderateForumMessages"/>
    </h3>

    <c:if test="${not empty forumPostlist}">

        <table id="forumMessagesTable"
               class="table table-bordered table-striped table-hover display data-table">
            <thead>
            <tr>
                <th width="3%">#</th>
                <th width="45%"><fmt:message
                        key="moderateMessages.table.post"/></th>
                <th width="10%"><fmt:message
                        key="moderateMessages.table.postdate"/></th>
                <th width="8%"><fmt:message
                        key="moderateMessages.table.postby"/></th>
                <th width="34%"><fmt:message
                        key="moderateMessages.table.postactions"/></th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${forumPostlist}" var="forumPost"
                       varStatus="status">

                <template:addCacheDependency node="${forumPost}"/>

                <c:if test="${jcr:isNodeType(forumPost, 'jnt:post')}">

                    <jcr:nodeProperty node="${forumPost}" name="jcr:title"
                                      var="commentTitle"/>
                    <jcr:nodeProperty node="${forumPost.parent}" name="topicSubject"
                                      var="topicSubject"/>
                    <jcr:nodeProperty node="${forumPost.parent.parent}"
                                      name="jcr:title" var="sectionTitle"/>
                    <jcr:nodeProperty node="${forumPost}" name="jcr:createdBy"
                                      var="createdBy"/>
                    <jcr:nodeProperty node="${forumPost}" name="content"
                                      var="content"/>


                    <c:if
                            test="${jcr:hasPermission(forumPost.parent.parent, 'moderatePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">

                        <tr>

                            <td><c:set var="count" value="${count + 1}" scope="page"/>
                                <c:out value="${count}"/></td>
                            <td>
                                <a href="<c:url value='${url.baseLive}${forumPost.parent.path}.html'/>"
                                   target="_blank"
                                   title='<fmt:message key=" label.navigateTo "/>' class="postTitle"><c:out
                                        value="${commentTitle.string}"/>
                                </a>
                                <br/>
                                <i><b>Section:</b> <c:out value="${sectionTitle.string}"/>
                                    <br/>
                                    <b>Topic:</b> <c:out value="${topicSubject.string}"/></i>
                                <br/>
                            </td>
                            <jcr:nodeProperty node="${forumPost}" name="jcr:lastModified"
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
                                ${fn:escapeXml(forumPost.properties.pseudo.string)}
                                <br/>
                                <i>(guest)</i>
                            </c:if>
									</span></td>
                            <template:tokenizedForm>
                                <form
                                        action="<c:url value='${url.baseLive}${forumPost.path}'/>"
                                        method="post"
                                        id="jahia-forum-post-moderate-${forumPost.UUID}">
                                    <input type="hidden" name="jcrRedirectTo"
                                           value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                    <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                    <input type="hidden" name="jcrMethodToCall" value="put"/>
                                    <input
                                            type="hidden" name="moderated" value="true"/>
                                </form>
                            </template:tokenizedForm>
                            <template:tokenizedForm>
                                <form
                                        action="<c:url value='${url.baseLive}${forumPost.path}'/>"
                                        method="post" id="jahia-forum-post-delete-${forumPost.UUID}">
                                    <input type="hidden" name="jcrRedirectTo"
                                           value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                    <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                    <input type="hidden" name="jcrMethodToCall" value="delete"/>
                                </form>
                            </template:tokenizedForm>
                            <td><c:if
                                    test="${jcr:hasPermission(forumPost.parent.parent, 'moderatePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">

                                <button type="button" class="btn btn-success"
                                        onclick="document.getElementById('jahia-forum-post-moderate-${forumPost.UUID}').submit(); return false;">
                                    <i class="icon-ok icon-white"></i>
                                    <fmt:message key='moderateMessages.moderatePost'/>
                                </button>
                            </c:if> <c:if test="${jcr:hasPermission(forumPost, 'deletePost')}">

                                <fmt:message key="moderateMessages.confirmDeletePost"
                                             var="confirmMsg"/>
                                <button type="button" class="btn btn-danger"
                                        onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                { document.getElementById("jahia-forum-post-delete-${forumPost.UUID}").submit(); } return false;'>
                                    <i class="icon-remove icon-white"></i>
                                    <fmt:message key='moderateMessages.deletePost'/>
                                </button>
                            </c:if>

                                <button type="button"
                                        class="btn btn-primary btn-${forumPost.UUID}"
                                        id="btn-${forumPost.UUID}" data-toggle="modal"
                                        data-target="#${forumPost.UUID}">
                                    <i class="icon-info-sign icon-white"></i><span><fmt:message
                                        key="moderateMessages.viewPost"/></span>
                                </button>
                            </td>

                        </tr>
                        <!-- Button trigger modal -->


                        <!-- Modal -->
                        <div class="modal fade" id="${forumPost.UUID}" tabindex="-1"
                             role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">&times;</button>
                                        <h3 class="modal-title" id="myModalLabel">${commentTitle.string}
                                        </h3>
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
                                            Section:
                                            <c:out value="${sectionTitle.string}"/>
                                            <br/>
                                            Topic:
                                            <c:out value="${topicSubject.string}"/>
                                        </h4>
                                    </div>
                                    <div class="modal-body">
                                            ${functions:removeHtmlTags(content.string)}</div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-success"
                                                onclick="document.getElementById('jahia-forum-post-moderate-${forumPost.UUID}').submit(); return false;">
                                            <i class="icon-ok icon-white"></i>
                                            <fmt:message key='moderateMessages.moderatePost'/>
                                        </button>
                                        <button type="button" class="btn btn-danger"
                                                onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                        { document.getElementById("jahia-forum-post-delete-${forumPost.UUID}").submit(); } return false;'>
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
    <c:if test="${empty forumPostlist}">
        <div class="alert alert-info">
            <h2><fmt:message key='moderateMessages.noPostToModerate'/></h2>
        </div>
    </c:if>
</div>


<c:set var="count" value="0" scope="page"/>
<div class="box-1">
    <h3>
        <fmt:message key="siteSettings.label.moderateBlogMessages"/>
    </h3>

    <c:if test="${not empty blogPostlist}">
        <table id="blogPostTable"
               class="table table-bordered table-striped table-hover  data-table">
            <thead>
            <tr>
                <th width="3%">#</th>
                <th width="45%"><fmt:message
                        key="moderateMessages.table.post"/></th>
                <th width="10%"><fmt:message
                        key="moderateMessages.table.postdate"/></th>
                <th width="8%"><fmt:message
                        key="moderateMessages.table.postby"/></th>
                <th width="34%"><fmt:message
                        key="moderateMessages.table.postactions"/></th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${blogPostlist}" var="blogPost"
                       varStatus="status">


                <template:addCacheDependency node="${blogPost}"/>

                <c:if
                        test="${jcr:isNodeType(blogPost, 'jnt:post') && jcr:hasPermission(blogPost, 'deletePost')}">

                    <jcr:nodeProperty node="${blogPost}" name="jcr:title"
                                      var="commentTitle"/>
                    <jcr:nodeProperty node="${blogPost.parent}" name="topicSubject"
                                      var="topicSubject"/>
                    <jcr:nodeProperty node="${blogPost.parent.parent}"
                                      name="jcr:title" var="sectionTitle"/>
                    <jcr:nodeProperty node="${blogPost}" name="jcr:createdBy"
                                      var="createdBy"/>
                    <jcr:nodeProperty node="${blogPost}" name="content" var="content"/>

                    <tr>

                        <td><c:set var="count" value="${count + 1}" scope="page"/>
                            <c:out value="${count}"/></td>
                        <td>
                            <a
                                    href="<c:url value='${url.baseLive}${blogPost.parent.parent.path}.html'/>"
                                    target="_blank" title='<fmt:message key=" label.navigateTo "/>' class="postTitle">
                                <c:out value="${commentTitle.string}"/>
                            </a>
                            <br/>
                            <i><b>Blog:</b> <c:out value="${sectionTitle.string}"/></i>
                            <br/>
                        </td>
                        <jcr:nodeProperty node="${blogPost}" name="jcr:lastModified"
                                          var="lastModified"/>
                        <td><span class="docspacedate timestamp"><fmt:formatDate
                                value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm"/></span></td>
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
                            ${fn:escapeXml(blogPost.properties.pseudo.string)}
                        </c:if>
								</span></td>
                        <td><c:if
                                test="${jcr:hasPermission(blogPost, 'deletePost')}">

                            <template:tokenizedForm>
                                <form action="<c:url value='${url.baseLive}${blogPost.path}'/>" method="post"
                                      id="jahia-forum-post-moderate-${blogPost.identifier}">
                                    <input type="hidden" name="jcrRedirectTo"
                                           value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                    <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                    <input type="hidden" name="jcrMethodToCall" value="put"/>
                                    <input type="hidden" name="jcr:mixinTypes" value="jmix:moderated"/>
                                    <input type="hidden" name="moderated" value="true"/>
                                </form>
                            </template:tokenizedForm>

                            <template:tokenizedForm>
                                <form
                                        action="<c:url value='${url.baseLive}${blogPost.path}'/>"
                                        method="post" id="jahia-forum-post-delete-${blogPost.UUID}">
                                    <input type="hidden" name="jcrRedirectTo"
                                           value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                    <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                    <input type="hidden" name="jcrMethodToCall" value="delete"/>
                                </form>
                            </template:tokenizedForm>


                            <fmt:message key="moderateMessages.moderatePost"
                                         var="confirmMsg"/>
                            <button type="button" class="btn btn-success"
                                    onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                            { document.getElementById("jahia-forum-post-moderate-${blogPost.UUID}").submit();} return false;'>
                                <i class="icon-remove icon-white"></i>
                                <fmt:message key='moderateMessages.moderatePost'/>
                            </button>

                            <fmt:message key="moderateMessages.confirmDeletePost"
                                         var="confirmMsg"/>
                            <button type="button" class="btn btn-danger"
                                    onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                            { document.getElementById("jahia-forum-post-delete-${blogPost.UUID}").submit(); } return false;'>
                                <i class="icon-remove icon-white"></i>
                                <fmt:message key='moderateMessages.deletePost'/>

                            </button>
                        </c:if>

                            <button type="button"
                                    class="btn btn-primary btn-${blogPost.UUID}"
                                    id="btn-${blogPost.UUID}" data-toggle="modal"
                                    data-target="#${blogPost.UUID}">
                                <i class="icon-info-sign icon-white"></i><span><fmt:message
                                    key="moderateMessages.viewPost"/></span>

                            </button>
                        </td>

                    </tr>
                    <div class="modal fade" id="${blogPost.UUID}" tabindex="-1"
                         role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"
                                            aria-hidden="true">&times;</button>
                                    <h3 class="modal-title" id="myModalLabel">${commentTitle.string}
                                    </h3>
                                    <i>(<fmt:message
                                            key="moderateMessages.table.postby"/>&nbsp;${firstname}&nbsp;${lastname})
                                    </i>
                                    <c:if test="${not empty picture}">
                                        <img align="right" class='user-profile-img userProfileImage'
                                             src="${picture.node.thumbnailUrls['avatar_120']}"
                                             alt="${fn:escapeXml(title)} ${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}"
                                             width="60" height="60"/>
                                    </c:if>
                                    <h4 class="modal-title" id="myModalLabel">
                                        Blog:
                                        <c:out value="${sectionTitle.string}"/>
                                    </h4>
                                </div>
                                <div class="modal-body">
                                        ${functions:removeHtmlTags(content.string)}</div>
                                <div class="modal-footer">
                                    <fmt:message key="moderateMessages.moderatePost"
                                                 var="confirmMsg"/>
                                    <button type="button" class="btn btn-success"
                                            onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                    { document.getElementById("jahia-forum-post-moderate-${blogPost.UUID}").submit();} return false;'>
                                        <i class="icon-remove icon-white"></i>
                                        <fmt:message key='moderateMessages.moderatePost'/>
                                    </button>

                                    <button type="button" class="btn btn-danger"
                                            onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                    { document.getElementById("jahia-forum-post-delete-${blogPost.UUID}").submit(); } return false;'>
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
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty blogPostlist}">
        <div class="alert alert-info">
            <h2><fmt:message key='moderateMessages.noPostToModerate'/></h2>
        </div>
    </c:if>

</div>


<c:set var="count" value="0" scope="page"/>
<div class="box-1">
    <h3>
        <fmt:message key="siteSettings.label.moderateCommentMessages"/>
    </h3>

    <c:if test="${not empty CommentPostlist}">

        <table id="commentPostTable"
               class="table table-bordered table-striped table-hover  data-table">
            <thead>
            <tr>
                <th width="3%">#</th>
                <th width="45%"><fmt:message key="moderateMessages.table.post"/></th>
                <th width="10%"><fmt:message
                        key="moderateMessages.table.postdate"/></th>
                <th width="8%"><fmt:message key="moderateMessages.table.postby"/></th>
                <th width="34%"><fmt:message
                        key="moderateMessages.table.postactions"/></th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${CommentPostlist}" var="commentPost"
                       varStatus="status">


                <template:addCacheDependency node="${commentPost}"/>

                <c:if
                        test="${jcr:isNodeType(commentPost, 'jnt:post') && jcr:hasPermission(commentPost, 'deletePost')}">

                    <jcr:nodeProperty node="${commentPost}" name="jcr:title"
                                      var="commentTitle"/>
                    <jcr:nodeProperty node="${commentPost.parent}" name="topicSubject"
                                      var="topicSubject"/>
                    <jcr:nodeProperty node="${commentPost.parent.parent}"
                                      name="jcr:title" var="sectionTitle"/>
                    <jcr:nodeProperty node="${commentPost}" name="jcr:createdBy"
                                      var="createdBy"/>
                    <jcr:nodeProperty node="${commentPost}" name="content"
                                      var="content"/>


                    <tr>

                        <td><c:set var="count" value="${count + 1}" scope="page"/>
                            <c:out value="${count}"/></td>
                        <td>
                            <a
                                    href="<c:url value='${url.baseLive}${commentPost.parent.parent.path}.html'/>"
                                    target="_blank" title='<fmt:message key=" label.navigateTo "/>' class="postTitle">
                                <c:out value="${commentTitle.string}"/>
                            </a>
                            <br/>
                            <i><b>Page:</b> <c:out value="${sectionTitle.string}"/></i>
                            <br/>
                        </td>
                        <jcr:nodeProperty node="${commentPost}" name="jcr:lastModified"
                                          var="lastModified"/>
                        <td><span class="docspacedate timestamp"> <fmt:formatDate
                                value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm"/></span></td>
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
                            ${fn:escapeXml(commentPost.properties.pseudo.string)}
                            <i>(guest)</i>
                        </c:if>

						</span></td>
                        <template:tokenizedForm>
                            <form
                                    action="<c:url value='${url.baseLive}${commentPost.path}'/>"
                                    method="post" id="jahia-forum-post-delete-${commentPost.UUID}">
                                <input type="hidden" name="jcrRedirectTo"
                                       value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                    <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                <input type="hidden" name="jcrMethodToCall" value="delete"/>
                            </form>
                        </template:tokenizedForm>

                        <template:tokenizedForm>
                            <form action="<c:url value='${url.baseLive}${commentPost.path}'/>" method="post"
                                  id="jahia-forum-post-moderate-${commentPost.identifier}">
                                <input type="hidden" name="jcrRedirectTo"
                                       value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                    <%-- Define the output format for the newly created node by default html or by redirectTo--%>
                                <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                <input type="hidden" name="jcrMethodToCall" value="put"/>
                                <input type="hidden" name="jcr:mixinTypes" value="jmix:moderated"/>
                                <input type="hidden" name="moderated" value="true"/>
                            </form>
                        </template:tokenizedForm>

                        <td><c:if
                                test="${jcr:hasPermission(commentPost, 'deletePost')}">

                            <fmt:message key="moderateMessages.moderatePost"
                                         var="confirmMsg"/>
                            <button type="button" class="btn btn-success"
                                    onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                            { document.getElementById("jahia-forum-post-moderate-${commentPost.UUID}").submit();} return false;'>
                                <i class="icon-remove icon-white"></i>
                                <fmt:message key='moderateMessages.moderatePost'/>
                            </button>

                            <fmt:message key="moderateMessages.confirmDeletePost"
                                         var="confirmMsg"/>
                            <button type="button" class="btn btn-danger"
                                    onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                            { document.getElementById("jahia-forum-post-delete-${commentPost.UUID}").submit(); } return false;'>
                                <i class="icon-remove icon-white"></i>
                                <fmt:message key='moderateMessages.deletePost'/>
                            </button>
                        </c:if>

                            <button type="button"
                                    class="btn btn-primary btn-${commentPost.UUID}"
                                    id="btn-${commentPost.UUID}" data-toggle="modal"
                                    data-target="#${commentPost.UUID}">
                                <i class="icon-info-sign icon-white"></i><span><fmt:message
                                    key="moderateMessages.viewPost"/></span>

                            </button>
                        </td>

                    </tr>
                    <div class="modal fade" id="${commentPost.UUID}" tabindex="-1"
                         role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"
                                            aria-hidden="true">&times;</button>
                                    <h3 class="modal-title" id="myModalLabel">${commentTitle.string}
                                    </h3>
                                    <i>(<fmt:message
                                            key="moderateMessages.table.postby"/>&nbsp;${firstname}&nbsp;${lastname})
                                    </i>
                                    <c:if test="${not empty picture}">
                                        <img align="right" class='user-profile-img userProfileImage'
                                             src="${picture.node.thumbnailUrls['avatar_120']}"
                                             alt="${fn:escapeXml(title)} ${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}"
                                             width="60" height="60"/>
                                    </c:if>
                                    <h4 class="modal-title" id="myModalLabel">
                                        Page:
                                        <c:out value="${sectionTitle.string}"/>
                                    </h4>
                                </div>
                                <div class="modal-body">
                                        ${functions:removeHtmlTags(content.string)}</div>
                                <div class="modal-footer">
                                    <c:if test="${jcr:hasPermission(commentPost, 'deletePost')}">
                                        <fmt:message key="moderateMessages.moderatePost"
                                                     var="confirmMsg"/>
                                        <button type="button" class="btn btn-success"
                                                onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                        { document.getElementById("jahia-forum-post-moderate-${commentPost.UUID}").submit();} return false;'>
                                            <i class="icon-remove icon-white"></i>
                                            <fmt:message key='moderateMessages.moderatePost'/>
                                        </button>

                                        <fmt:message key="moderateMessages.confirmDeletePost"
                                                     var="confirmMsg"/>
                                        <button type="button" class="btn btn-danger"
                                                onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                                        { document.getElementById("jahia-forum-post-delete-${commentPost.UUID}").submit(); } return false;'>
                                            <i class="icon-remove icon-white"></i>
                                            <fmt:message key='moderateMessages.deletePost'/>

                                        </button>
                                    </c:if>
                                    <button type="button" class="btn btn-default"
                                            data-dismiss="modal">Close
                                    </button>

                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty CommentPostlist}">
        <div class="alert alert-info">
            <h2><fmt:message key='moderateMessages.noPostToModerate'/></h2>
        </div>
    </c:if>
</div>



